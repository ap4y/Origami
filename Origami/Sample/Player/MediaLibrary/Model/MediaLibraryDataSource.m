//
//  MediaLibraryDataSource.m
//  Sample
//
//  Created by Arthur Evstifeev on 24.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MediaLibraryDataSource.h"
#import "MediaLibrary.h"
#import "Track.h"
#import "LibraryModelCommon.h"
#import "AlbumView.h"
#import "CustomTableFlushViewCell.h"
#import "TrackView.h"

@implementation MediaLibraryDataSource

- (void)formatTrackCells {
    for (int i = 0; i < self.items.count; i++) {
        UIView* view = [self.items objectAtIndex:i];
        if ([view isKindOfClass:[TrackView class]] && (i%2) != 0) {            
            TrackView* trackView = (TrackView*)view;
            trackView.backgroundColor = [UIColor whiteColor];
        }
        else 
        {
            TrackView* trackView = (TrackView*)view;
            trackView.backgroundColor = (UIColor*)TTSTYLE(backgroundColor);
        }
    }
}

- (void)formatedItems {
    [self.items removeAllObjects];
    MediaLibrary* library = [MediaLibrary defaultLibrary];    
    NSArray* tracks = library.tracksData;      
    
    if (tracks.count == 0) {
        return;
    }
    
    NSString* album = @"";
    for (Track* track in tracks) {
        if (![album isEqualToString:track.album]) {                        
            album = track.album;            
            [self.items addObject:[AlbumView viewWithTitle:track.album artist:track.artist cover:[UIImage imageWithData:track.cover] year:track.year]];                                    
        }
        [self.items addObject:[TrackView viewWithTrack:track]];        
    }        
    
    //little hack
    UIView* view = [[[UIView alloc] init] autorelease];
    [self.items addObject:view];
    
    [self formatTrackCells];
}

-(Class)tableView:(UITableView *)tableView cellClassForObject:(id)object {
    if ([object isKindOfClass:[AlbumView class]] || [object isKindOfClass:[TrackView class]])
        return [CustomTableFlushViewCell class];
    else
        return [super tableView:tableView cellClassForObject:object];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIView* cell = [self.items objectAtIndex:indexPath.row]; 
        if ([cell isKindOfClass:[TrackView class]]) {
            TrackView* view = (TrackView*)cell;
            [[MediaLibrary defaultLibrary] removeTrack:view.track];
        }
        else if ([cell isKindOfClass:[AlbumView class]]) {
            AlbumView* view = (AlbumView*)cell;
            [[MediaLibrary defaultLibrary] removeTracksFromAlbum:view.albumName];
        }                        
    }
}

+ (MediaLibraryDataSource*)dataSource {
    MediaLibraryDataSource* source = [[[MediaLibraryDataSource alloc] init] autorelease];    
    [source formatedItems];
    
    return source;
}

@end
