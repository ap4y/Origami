//
//  ContainerController.m
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ContainerController.h"
#import "Audio/AudioContainer.h"
#import "OOAudioPlayer.h"
#import "TableTrackItem.h"
#import "NSString+URLEncode.h"
#import "MediaLibrary.h"
#import "LibraryModelCommon.h"
#import "Track.h"

@implementation ContainerController

- (void)createModel {
    NSArray* fileUrls = [AudioContainer urlsForContainerURL:_currentUrl];
    NSMutableArray* items = [[NSMutableArray alloc] init];
    for (NSURL* fileUrl in fileUrls) {
        Track* track = [AudioMetadataReader trackmetadataForURL:fileUrl];
        NSString* imageUrl = [NSString stringWithFormat:@"bundle://%@.png", fileUrl.pathExtension];                
        TableTrackItem* item = [TableTrackItem itemWithText:[NSString stringWithFormat:@"%@ - %@", track.artist, track.title] imageURL:imageUrl defaultImage:nil imageStyle:nil URL:nil];
        item.track = track;
        [items addObject: item];
    }
    
    self.dataSource = [TTListDataSource dataSourceWithItems:items];
    [items release];
}

/*-(void)playTrack:(id)sender {
    if ([sender isKindOfClass:[TableTrackItem class]]) {
        TableTrackItem* item = sender;
        [[OOAudioPlayer defaultPlayer] play:[NSURL URLWithString:item.track.url]];
    }    
}*/

-(void)addToLibrary:(id)sender {
    TTListDataSource* datasource = self.dataSource;
    NSMutableArray* tracks = [[[NSMutableArray alloc] init] autorelease];
    for (TableTrackItem* item in datasource.items) {
        [tracks addObject:item.track];
    }
    
    [[MediaLibrary defaultLibrary] addTracks:tracks];
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://library/"]];
}

- (id)initWithUrl:(NSString*)url {
    self = [super init];
    if (self) {
        if (url != nil) {
            NSString* urlPath = [[NSString stringWithSpecialDencodeOfString:url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@", urlPath);
            _currentUrl = [NSURL URLWithString:urlPath];
            [_currentUrl retain];
            self.title = _currentUrl.lastPathComponent;
            self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addToLibrary:)] autorelease];
        }        
    }
    
    return self;
}

@end
