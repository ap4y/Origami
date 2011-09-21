//
//  LibraryController.m
//  Sample
//
//  Created by Arthur Evstifeev on 24.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LibraryController.h"
#import "OOAudioPlayer.h"
#import "LibraryModelCommon.h"
#import "CustomTableFlushViewCell.h"

@implementation LibraryController

- (void)dealloc {
    [_playerControl release];
    //[_dataSource release];
    [super dealloc];
}

- (void)createModel {
    //_datasource = [MediaLibraryDataSource dataSource];
    self.dataSource = [MediaLibraryDataSource dataSource];;    
    Track* saveTrack = [OOAudioPlayer defaultPlayer].track;
    [OOAudioPlayer defaultPlayer].tracks = [MediaLibrary defaultLibrary].tracksData;
    [OOAudioPlayer defaultPlayer].currentTrack = [[OOAudioPlayer defaultPlayer].tracks indexOfObject:saveTrack];
}

-(void)reloadDatasource {
    [self createModel];
    [self.tableView reloadData];    
}

-(void)libraryDidRemovedTrack:(MediaLibrary *)library {
    [self reloadDatasource];    
}

-(void)libraryDidRemovedTracks:(MediaLibrary *)library {
    [self reloadDatasource];    
}

-(void)libraryDidAddedTrack:(MediaLibrary *)library {
    [self reloadDatasource];    
}

-(void)libraryDidAddedTracks:(MediaLibrary *)library {    
    [self reloadDatasource];    
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    if ([object isKindOfClass:[TrackView class]]) {    
        TrackView* track = object;
        if (![[OOAudioPlayer defaultPlayer].track isEqual:track.track])                
            [[OOAudioPlayer defaultPlayer] playLoadedTracks:track.track];    
    }        
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES]; 
    [super viewWillAppear:animated];
}

-(void)viewDidLoad {
    [super viewDidLoad];        
    
    _playerControl = [[PlayerControlView alloc] initWithFrame:CGRectMake(0, 416, 320, 44)];
    [self.view addSubview:_playerControl];
        
    [MediaLibrary defaultLibrary].delegate = self;
    self.variableHeightRows = YES;    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartedPlay:) name:@"OOAudioPlayerdidStartedPlay" object:[OOAudioPlayer defaultPlayer]];
}

-(void)didStartedPlay:(NSNotification*)notification {
    Track* track = [OOAudioPlayer defaultPlayer].track;
    MediaLibraryDataSource* datasource = (MediaLibraryDataSource*)self.dataSource;    
    
    for (id trackItem in datasource.items) {
        if ([trackItem isKindOfClass:[TrackView class]]) {
            TrackView* tableTrackItem = (TrackView*) trackItem;

            if (track != nil && [tableTrackItem.track isEqual:track]) {
                [tableTrackItem highlight:YES];
                
                [self performSelectorOnMainThread:@selector(scrollTableView:) withObject:[NSIndexPath indexPathForRow:[datasource.items indexOfObject:trackItem] inSection:0] waitUntilDone:NO];
            }
            else
                [tableTrackItem highlight:NO];            
        }
    }            
}

- (void)scrollTableView:(NSIndexPath*)path {
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

@end
