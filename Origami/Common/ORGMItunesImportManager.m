//
//  ORGMItunesImporter.m
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

#import "ORGMItunesImportManager.h"
#import "ORGMTrack.h"
#import "ORGMInputUnit.h"
#import "CueSheetContainer.h"

NSString * const ORGMAlbumTitle = @"ORGMAlbumTitle";
NSString * const ORGMArtistTitle = @"ORGMArtistTitle";
NSString * const ORGMGenreTitle = @"ORGMGenreTitle";
NSString * const ORGMTrackTitle = @"ORGMTrackTitle";
NSString * const ORGMTrackNumber = @"ORGMTrackNumber";
NSString * const ORGMTrackPath = @"ORGMTrackPath";
NSString * const ORGMTrackId = @"ORGMTrackId";

NSString * const kSyncDateKey = @"ORGMItunesImportManagerSyncDate";

@interface ORGMItunesImportManager ()
@property (strong, nonatomic) NSDictionary *localFiles;
@property (strong, nonatomic) NSDate *changeDate;
@end

@implementation ORGMItunesImportManager

+ (ORGMItunesImportManager *)defaultImportManager {
    static ORGMItunesImportManager *defaultImportManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultImportManager = [[ORGMItunesImportManager alloc] init];
    });
    return defaultImportManager;
}

- (void)syncWithDocumentsDirectory {
    if (![self documentsPath] || ![self shouldReSyncItems]) return;
    
    NSManagedObjectContext *context = mainThreadContext();
    
    self.localFiles = [self getLocalFiles];
    NSArray *savedTracks = [ORGMTrack requestResult:[ORGMTrack all]
                               managedObjectContext:context];

    NSPredicate *removedPredicate = [NSPredicate predicateWithFormat:@"not (id in %@)",
                                     [_localFiles allKeys]];
    NSArray *removedTracks = [savedTracks filteredArrayUsingPredicate:removedPredicate];
    for (id obj in removedTracks) {
        [context deleteObject:obj];
    }
    
    NSArray *savedIds = [savedTracks valueForKeyPath:@"@distinctUnionOfObjects.id"];
    NSMutableDictionary *newFiles = [NSMutableDictionary dictionary];
    [_localFiles enumerateKeysAndObjectsUsingBlock:^(NSNumber *hash, NSURL *url, BOOL *stop) {
        if (![savedIds containsObject:hash]) {
            [newFiles setObject:url forKey:hash];
        }
    }];
    [self processNewFilesDictionary:newFiles inMangedContext:context];
    
    [CoreDataHelper save:context];
        
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_changeDate forKey:kSyncDateKey];
    [defaults synchronize];
    self.changeDate = nil;
}

#pragma mark - private
- (NSString *)documentsPath {
    static NSString *documentsPath = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask,
                                                             YES);
        documentsPath = [[paths objectAtIndex:0] copy];
    });
    return documentsPath;
}

- (BOOL)shouldReSyncItems {
    NSError *err = nil;
    NSFileManager *manager = [NSFileManager defaultManager];    
    NSDictionary *attributes = [manager attributesOfItemAtPath:[self documentsPath]
                                                         error:&err];
    if (err || !attributes) return NO;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *syncDate = [defaults objectForKey:kSyncDateKey];
    NSDate *changeDate = [attributes objectForKey:NSFileModificationDate];
    
    if ([changeDate isEqualToDate:syncDate]) return NO;    
    
    self.changeDate = changeDate;
    return YES;
}

- (NSDictionary *)getLocalFiles {
    NSFileManager *manager = [NSFileManager defaultManager];    
    NSArray *files = [manager contentsOfDirectoryAtPath:[self documentsPath] error:nil];
    
    NSMutableDictionary *localFiles = [NSMutableDictionary dictionary];
    NSURL *docsUrl = [NSURL fileURLWithPath:[self documentsPath]];
    [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSURL *fullUrl = [docsUrl URLByAppendingPathComponent:obj];
        NSString *fullPath = [fullUrl absoluteString];
        NSUInteger hash = [fullPath hash];
        [localFiles setObject:fullUrl forKey:[NSNumber numberWithInteger:hash]];
    }];
    return localFiles;
}

- (void)processNewFilesDictionary:(NSDictionary *)newFiles
                  inMangedContext:(NSManagedObjectContext *)context {
    
    ORGMInputUnit* input = [[ORGMInputUnit alloc] init];
    [newFiles enumerateKeysAndObjectsUsingBlock:^(NSNumber *hash, NSURL *url, BOOL *stop) {
        if ([[url pathExtension] isEqualToString:@"cue"]) {
            NSArray *fileUrls = [CueSheetContainer urlsForContainerURL:url];
            [fileUrls enumerateObjectsUsingBlock:^(NSURL *cueUrl, NSUInteger idx, BOOL *stop) {
                if (![input openWithUrl:cueUrl]) return;
                
                NSMutableDictionary *metadata = [self processCueMetadata:[input metadata]];
                if (metadata) {
                    NSString *absolutePath = [cueUrl absoluteString];
                    [metadata setObject:[NSNumber numberWithInteger:[absolutePath hash]]
                                 forKey:ORGMTrackId];
                    [metadata setObject:absolutePath forKey:ORGMTrackPath];                    
                    
                    [self createObjectsFromMetadata:metadata inManagedContext:context];
                }
            }];
        } else if ([[url pathExtension] isEqualToString:@"flac"]) {
            if (![input openWithUrl:url]) return;
            
            NSMutableDictionary *metadata = [self processFlacMetadata:[input metadata]];
            if (metadata) {
                [metadata setObject:hash forKey:ORGMTrackId];
                [metadata setObject:[url absoluteString] forKey:ORGMTrackPath];
                
                [self createObjectsFromMetadata:metadata inManagedContext:context];
            }
        }
    }];
}

- (NSMutableDictionary *)processCueMetadata:(NSDictionary *)metadata {
    NSMutableDictionary *correctMetadata = [self processFlacMetadata:metadata];
    if (!correctMetadata) return nil;
    
    NSString *tracknumber = [metadata objectForKey:@"track"];    
    [correctMetadata setValue:[NSNumber numberWithInteger:[tracknumber integerValue]] ?: nil
                       forKey:ORGMTrackNumber];
    
    return correctMetadata;
}

- (NSMutableDictionary *)processFlacMetadata:(NSDictionary *)metadata {
    NSString *title = [metadata objectForKey:@"title"];
    if (!title) return nil;
    
    NSString *album = [metadata objectForKey:@"album"];
    NSString *artist = [metadata objectForKey:@"artist"];
    NSString *genre = [metadata objectForKey:@"genre"];
    NSString *tracknumber = [metadata objectForKey:@"tracknumber"];
    
    NSMutableDictionary *correctMetadata = [NSMutableDictionary dictionary];
    [correctMetadata setValue:album ?: nil forKey:ORGMAlbumTitle];
    [correctMetadata setValue:artist ?: nil forKey:ORGMArtistTitle];
    [correctMetadata setValue:genre ?: nil forKey:ORGMGenreTitle];
    [correctMetadata setValue:title ?: nil forKey:ORGMTrackTitle];
    [correctMetadata setValue:[NSNumber numberWithInteger:[tracknumber integerValue]] ?: nil
                       forKey:ORGMTrackNumber];
    
    return correctMetadata;
}

- (void)createObjectsFromMetadata:(NSDictionary *)metadata
                 inManagedContext:(NSManagedObjectContext *)context {
    ORGMArtist *artist =
        [ORGMArtist createOrFindByTitle:[metadata objectForKey:ORGMArtistTitle]
                       inManagedContext:context];
    
    ORGMAlbum *album =
        [ORGMAlbum createOrFindByTitle:[metadata objectForKey:ORGMAlbumTitle]
                      inManagedContext:context];
    album.artist = artist;

    ORGMGenre *genre =
        [ORGMGenre createOrFindByTitle:[metadata objectForKey:ORGMGenreTitle]
                      inManagedContext:context];

    NSEntityDescription *description = [ORGMTrack enityDescriptionInContext:context];
    ORGMTrack *track = [[ORGMTrack alloc] initWithEntity:description
                          insertIntoManagedObjectContext:context];
    track.id = [metadata objectForKey:ORGMTrackId];
    track.title = [metadata objectForKey:ORGMGenreTitle];
    track.track_num = [metadata objectForKey:ORGMTrackNumber];
    track.track_path = [metadata objectForKey:ORGMTrackPath];
    track.genre = genre;
    track.album = album;
}

@end
