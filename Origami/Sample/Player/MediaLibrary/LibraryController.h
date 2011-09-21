//
//  LibraryController.h
//  Sample
//
//  Created by Arthur Evstifeev on 24.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "TrackView.h"
#import "OOAudioPlayer.h"
#import "PlayerControlView.h"
#import "MediaLibraryDataSource.h"
#import "MediaLibrary.h"

@interface LibraryController : TTTableViewController <MediaLibraryDelegate> {    
    //MediaLibraryDataSource* _datasource;
    PlayerControlView* _playerControl;
}

@end
