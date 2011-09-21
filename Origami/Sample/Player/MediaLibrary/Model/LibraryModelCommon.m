//
//  LibraryModelCommon.m
//  Sample
//
//  Created by Arthur Evstifeev on 24.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LibraryModelCommon.h"

@implementation LibraryModelCommon

+ (NSManagedObjectModel *)managedObjectModel {
    static NSManagedObjectModel *managedObjectModel;
    
    @synchronized(self)
    {
        if (!managedObjectModel) {
            NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MediaLibrary" withExtension:@"momd"];
            managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
        }
        
        return managedObjectModel;
    }
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    static NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
    @synchronized(self)
    {
        if (!persistentStoreCoordinator) {
            NSURL* applicationDocumentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
            NSURL *storeURL = [applicationDocumentsDirectory URLByAppendingPathComponent:@"MediaLibrary.sqlite"];            
            NSError *error = nil;
            persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
            if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
            {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
        
        return persistentStoreCoordinator;
    }
}

+ (NSManagedObjectContext *)managedObjectContext {
    static NSManagedObjectContext *managedObjectContext;
    
    @synchronized(self)
    {
        if (!managedObjectContext) {
            NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
            if (coordinator != nil)
            {
                managedObjectContext = [[NSManagedObjectContext alloc] init];
                [managedObjectContext setPersistentStoreCoordinator:coordinator];
            }
        }
        
        return managedObjectContext;
    }
}

@end

@implementation MediaLibrary (Additional)

+ (MediaLibrary *)defaultLibrary {    
    static MediaLibrary* defaultLibrary;
    
    @synchronized(self)
    {
        if (!defaultLibrary) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"MediaLibrary" inManagedObjectContext:[LibraryModelCommon managedObjectContext]];
            [fetchRequest setEntity:entity];    
            [fetchRequest setFetchBatchSize:20];
            
            NSArray* libraries = [[LibraryModelCommon managedObjectContext] executeFetchRequest:fetchRequest error:nil];
            
            if(libraries == nil || libraries.count == 0)
            {
                defaultLibrary = [[MediaLibrary alloc] initWithEntity:entity insertIntoManagedObjectContext:[LibraryModelCommon managedObjectContext]];
                
                NSError* error;
                if(![[LibraryModelCommon managedObjectContext] save:&error]){
                    NSLog(@"MediaLibrary save error: %@", error.localizedDescription);
                }
            }
            else
            {
                defaultLibrary = [[libraries lastObject] retain];
            }
            
            [fetchRequest release];

        }
        
        return defaultLibrary;
    }
}

- (NSArray *)albumTracks:(NSString*)album {    

    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:[LibraryModelCommon managedObjectContext]];
    [fetchRequest setEntity:entity];    
    //[fetchRequest setFetchBatchSize:20];
    
    NSPredicate* albumPredicate = [NSPredicate predicateWithFormat:@"album == %@", album];
    [fetchRequest setPredicate:albumPredicate];
    
    NSError *error = nil;
    NSArray* tracks = [[LibraryModelCommon managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"request error: %@", error.localizedDescription);
        return nil;
    }
    return tracks;
}

- (void)addTrack:(Track *)track {    
    [self addTracksObject:track];
    NSError* error;
    
    if (![[LibraryModelCommon managedObjectContext] save:&error])
        NSLog(@"Track adding error: %@", error.localizedDescription);
    else
        [_delegate libraryDidAddedTrack:self];
}

- (void)addTracks:(NSArray *)tracks {
    for (Track* item in tracks) {
        [self addTracksObject:item];
    }
    
    NSError* error = nil;
    [[LibraryModelCommon managedObjectContext] save:&error];
    if (error)
        NSLog(@"Track adding error: %@", error.localizedDescription);
    else
        [_delegate libraryDidAddedTracks:self];
}

- (void)removeTrack:(Track *)track {

    [[LibraryModelCommon managedObjectContext] deleteObject:track];
    
    NSError *error = nil;
    if (![[LibraryModelCommon managedObjectContext] save:&error])
        NSLog(@"Unresolved error %@", error.localizedDescription);
    else
        [_delegate libraryDidRemovedTrack:self];
}

- (void)removeTracksFromAlbum:(NSString *)album {
    NSArray* tracks = [self albumTracks:album];
    for (Track* track in tracks) {
        [[LibraryModelCommon managedObjectContext] deleteObject:track];
    }        

    NSError *error = nil;
    if (![[LibraryModelCommon managedObjectContext] save:&error])
        NSLog(@"Unresolved error %@", error.localizedDescription);
    else
        [_delegate libraryDidRemovedTracks:self];
}

-(NSArray*)tracksData {
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:[LibraryModelCommon managedObjectContext]];
    [fetchRequest setEntity:entity];    
    //[fetchRequest setFetchBatchSize:20];
    
    NSSortDescriptor *sortDescriptorAlbum = [[[NSSortDescriptor alloc] initWithKey:@"album" ascending:YES] autorelease];
    NSSortDescriptor *sortDescriptorArtist = [[[NSSortDescriptor alloc] initWithKey:@"artist" ascending:YES] autorelease];
    NSSortDescriptor *sortDescriptorTrack = [[[NSSortDescriptor alloc] initWithKey:@"trackNo" ascending:YES] autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptorAlbum, sortDescriptorArtist, sortDescriptorTrack, nil] autorelease];    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate* libraryPredicate = [NSPredicate predicateWithFormat:@"library == %@", self];
    [fetchRequest setPredicate:libraryPredicate];
             
    return [[LibraryModelCommon managedObjectContext] executeFetchRequest:fetchRequest error:nil];
}

@end

@implementation Track (Additional)

-(id)initWithTitle:(NSString*)title album:(NSString*)album artist:(NSString*)artist genre:(NSString*)genre url:(NSString*)url trackNo:(NSNumber*)trackNo year:(NSNumber*)year cover:(NSData*)cover {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Track" inManagedObjectContext:[LibraryModelCommon managedObjectContext]];
    self = [super initWithEntity:entity insertIntoManagedObjectContext:[LibraryModelCommon managedObjectContext]];
    if (self) {
        self.title = title == nil ? @"Untitled" : title;
        self.album = album == nil ? @"Untitled" : album;
        self.artist = artist == nil ? @"Untitled" : artist;
        self.genre = genre;
        if ([trackNo isKindOfClass:[NSNumber class]]) {
            self.trackNo = trackNo;
        }
        
        if ([year isKindOfClass:[NSNumber class]]) {
            self.year = year;            
        }
        self.url = url;
        self.cover = cover;
    }
    
    return self;
}

+(Track*)trackWithTitle:(NSString*)title album:(NSString*)album artist:(NSString*)artist genre:(NSString*)genre url:(NSString*)url trackNo:(NSNumber*)trackNo year:(NSNumber*)year cover:(NSData*)cover {
    return [[[Track alloc] initWithTitle:title album:album artist:artist genre:genre url:url trackNo:trackNo year:year cover:cover] autorelease];
}
    
@end

@implementation AudioMetadataReader (Additional)

+(Track*)trackmetadataForURL:(NSURL *)url {
    NSDictionary* metadata = [self metadataForURL:url];
    NSNumber* year = [metadata objectForKey:@"year"];
    NSNumber* trackNo = [metadata objectForKey:@"track"];
    
    NSString* artist = [metadata objectForKey:@"artist"];
    NSString* album = [metadata objectForKey:@"album"];
    NSString* title = [metadata objectForKey:@"title"];
    NSString* genre = [metadata objectForKey:@"genre"];
    NSData* image = [metadata objectForKey:@"albumArt"];
    
    return [Track trackWithTitle:title album:album artist:artist genre:genre url:url.absoluteString trackNo:trackNo year:year cover:image];
}
@end