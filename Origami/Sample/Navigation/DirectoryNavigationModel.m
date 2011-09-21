//
//  DirectoryNavigationModel.m
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DirectoryNavigationModel.h"
#import "Audio/AudioPlayer.h"
#import "LibraryModelCommon.h"
#import "TableTrackItem.h"
//#import "TableUrlItem.h"
#import "NSString+URLEncode.h"

@implementation DirectoryNavigationModel
@synthesize directoryDelegate = _directoryDelegate, upnpItems = _upnpItems, selectedTracks = _selectedTracks;

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([_selectedTracks.allKeys containsObject:[NSNumber numberWithUnsignedInteger:indexPath.row]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

+ (NSMutableArray*)fileList:(NSURL*)currentDirectory {
    if (currentDirectory != nil) {     
        NSError* error = nil;
        
        NSArray* urlArray = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:currentDirectory includingPropertiesForKeys:[NSArray array] options:0 error:&error];
        
        if (error != nil) {
            NSLog(@"file list error:%@", [error localizedDescription]);
            return nil;
        }
                             
        NSMutableArray* filesList = [[[NSMutableArray alloc] init] autorelease];        
        for (id url in urlArray) {
            if ([url isKindOfClass:[NSURL class]]) {
                NSURL* fileUrl = (NSURL*) url;
                NSLog(@"url %@", fileUrl.absoluteString);
                
                if (CFURLHasDirectoryPath((CFURLRef)fileUrl)) { //directory ??                                
                    [filesList addObject:[TTTableTextItem itemWithText:fileUrl.lastPathComponent URL:[NSString stringWithFormat:@"tt://directory/%@", [NSString stringWithSpecialEncodeOfString:fileUrl.absoluteString]]]];                
                }
                else if (  [[AudioPlayer containerTypes] containsObject:[fileUrl pathExtension]] ) { //supported container ??

                    NSString* imageUrl = [NSString stringWithFormat:@"bundle://%@.png", fileUrl.pathExtension];
                    NSString* url = [NSString stringWithFormat:@"tt://container/%@", [NSString stringWithSpecialEncodeOfString:fileUrl.absoluteString]];
                    [filesList addObject:[TTTableImageItem itemWithText:fileUrl.lastPathComponent imageURL:imageUrl defaultImage:nil imageStyle:nil URL:url]];    
                }
                else if ( [[AudioPlayer fileTypes] containsObject:[fileUrl pathExtension]] ) { //supported format ??    
                    Track* track = [AudioMetadataReader trackmetadataForURL:fileUrl];
                    //TableUrlItem* item = [TableUrlItem itemWithText:fileUrl.lastPathComponent imageURL:[NSString stringWithFormat:@"bundle://%@.png", fileUrl.pathExtension]]; 
                    //item.url = fileUrl;
                    TableTrackItem* item = [TableTrackItem itemWithText:fileUrl.lastPathComponent imageURL:[NSString stringWithFormat:@"bundle://%@.png", fileUrl.pathExtension] track:track delegate:self selector:nil];
                    [filesList addObject: item];
                }      
            }
        }
        
        return filesList;
    }
    
    return nil;
}


- (id)initFromUPNPFolder:(UPNPFolder*)folder {
    self = [super init];
    if (self) {
        _selectedTracks = [[NSMutableDictionary alloc] init];
        if ([UPNPHelper defaultHelper]) {
            [UPNPHelper defaultHelper].delegate = self;
            [[UPNPHelper defaultHelper] contentsOfObjectAsync:folder];
        }
    }    
    
    return self;
}

- (id)initFromUrl:(NSURL*)url {    
    self = [super init];
    
    if (self) {
        NSArray *paths = [[NSFileManager defaultManager]  URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];;    
        NSURL* path = [paths lastObject];
        //NSURL* path = [NSBundle mainBundle].bundleURL;
        
        _selectedTracks = [[NSMutableDictionary alloc] init];
        
        if ([url isEqual:path]) {            
            if ([UPNPHelper defaultHelper]) {
                [UPNPHelper defaultHelper].delegate = self;
                [[UPNPHelper defaultHelper] contentsOfObjectAsync:nil];
            }
        }
    }    
    
    return self;
}

- (void)dealloc {
    [_selectedTracks release];
    [_upnpItems release];
    [super dealloc];
}

-(void)helper:(UPNPHelper *)helper didEndBrowsingFolder:(CgUpnpDevice*)dev withObjId:(NSString *)objId {
    if (!_upnpItems) {
        _upnpItems = [[NSMutableArray alloc] init];
    }
    
    [_upnpItems removeAllObjects];
    
    NSArray* content = helper.content;
    for (id url in content) {
        if ([url isKindOfClass:[UPNPFolder class]]) {
            UPNPFolder* folder = (UPNPFolder*)url;
            TableUPNPFolderItem* item = [TableUPNPFolderItem itemWithUPNPFolder:folder delegate:self selector:@selector(goToUpnpFolder:)];
            [_upnpItems addObject:item];
            [self.items addObject:item];
        }
        else if ([url isKindOfClass:[Track class]]) {
            Track* file = (Track*)url;
            NSURL* fileUrl = [NSURL URLWithString:file.url];
            if (  [[AudioPlayer containerTypes] containsObject:[fileUrl pathExtension]] ) { //supported container ??
                
                NSString* imageUrl = [NSString stringWithFormat:@"bundle://%@.png", fileUrl.pathExtension];
                NSString* url = [NSString stringWithFormat:@"tt://container/%@", [NSString stringWithSpecialEncodeOfString:fileUrl.absoluteString]];
                TTTableImageItem* item = [TTTableImageItem itemWithText:fileUrl.lastPathComponent imageURL:imageUrl defaultImage:nil imageStyle:nil URL:url];
                [self.items addObject:item];
                [_upnpItems addObject:item];
            }
            else if ( [[AudioPlayer fileTypes] containsObject:[fileUrl pathExtension]] ) { //supported format ?? 
                TableTrackItem* item = [TableTrackItem itemWithText:file.title imageURL:[NSString stringWithFormat:@"bundle://%@.png", fileUrl.pathExtension] track:file delegate:self selector:nil];
                [_upnpItems addObject:item];
                [self.items addObject: item];                
            }
        }
    }
    [_directoryDelegate directoryModel:self didLoadUpnpFolderData:objId];
}

- (void)goToUpnpFolder:(id)sender {
    TableUPNPFolderItem* folderItem = (TableUPNPFolderItem*)sender;
    
    NSString* folderUrl = [NSString stringWithFormat:@"upnp://%@", folderItem.folder.folderId];
    NSString* url = [NSString stringWithFormat:@"tt://directory/%@", [NSString stringWithSpecialEncodeOfString:folderUrl]];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:url] applyQuery:[NSDictionary dictionaryWithObject:folderItem.folder forKey:@"Folder"]]];
}

+ (id)dataSourceFromUPNPFolder:(UPNPFolder *)folder {
    DirectoryNavigationModel* item = [[[DirectoryNavigationModel alloc] initFromUPNPFolder:folder] autorelease];    
    return item;
}

+ (id)dataSourceFromUrl:(NSURL*)url {
    DirectoryNavigationModel* item = [[[DirectoryNavigationModel alloc] initFromUrl:url] autorelease];
    
    NSURL* currentDirectory = nil;
    if (url == nil) {
        currentDirectory = [NSBundle mainBundle].bundleURL;        
    }
    else if ([url isFileURL]) {                
        currentDirectory = url;        
    }
    
    item.items = [DirectoryNavigationModel fileList:currentDirectory];
    return item;
}

@end
