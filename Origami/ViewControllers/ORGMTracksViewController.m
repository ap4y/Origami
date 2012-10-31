//
//  ORGMTracksViewController.m
//  Origami
//
//  Created by ap4y on 8/19/12.
//
//

#import "ORGMTracksViewController.h"

#import "ORGMTrackCell.h"
#import "ORGMCustomization.h"
#import "ORGMPlayerView.h"

#import "ORGMItunesImportManager.h"

@interface ORGMTracksViewController () <UITableViewDelegate> {
    BOOL _isLoading;    
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) NSMutableArray *entities;
@end

@implementation ORGMTracksViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.entities = [[NSMutableArray alloc] init];
        _isLoading = NO;
    }
    return self;
}

- (void)reloadData {
    if (!_tracks || _tracks.count <= 0) {
        self.tracks = [ORGMTrack libraryTracks];
    }
    [_entities addObjectsFromArray:_tracks];
    [_tableViewOutlet reloadData];    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableViewOutlet setTableFooterView:nil];
    
    UIImageView *backView = [ORGMCustomization backgroundImage];
    backView.frame = self.view.bounds;
    [self.view insertSubview:backView belowSubview:_tableViewOutlet];
    [self reloadData];
    
    ORGMPlayerView *playerView = [[ORGMPlayerView alloc] initWithFrame:CGRectNull];
    [playerView addShortControlsForNavItem:self.navigationItem];
    [playerView setViewStateChangeBlock:^(ORGMPlayerViewState newState) {
        if (newState == ORGMPlayerViewStatePresented) {
            self.sideMenuController.panGesture.enabled = NO;
        } else {
            self.sideMenuController.panGesture.enabled = YES;
        }
    }];
    [playerView presentInView:self.view
                   uponNavBar:self.navigationController.navigationBar];
    
    UIView *stripeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 2.0)];
    stripeView.backgroundColor =
        [ORGMCustomization colorForColoredEntityType:ORGMColoredEntitiesTypeTrack];
    [self.navigationController.navigationBar addSubview:stripeView];
}

- (void)viewDidAppear:(BOOL)animated {
    [[ORGMItunesImportManager defaultManager] importFromDocumentsDirectoryWithSuccess:^{
        NSLog(@"done");
    }];
}

- (void)viewDidUnload {
    [self setTableViewOutlet:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _entities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORGMTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackCell"];
    [cell setTrack:[_entities objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[ORGMPlayerController defaultPlayer] playTracks:_entities from:indexPath.row];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (_isLoading) return;
//    NSArray *indexes = [_tableViewOutlet indexPathsForVisibleRows];
//    NSIndexPath *lastIndex = [indexes objectAtIndex:indexes.count - 1];
//    if ([lastIndex isEqual:[NSIndexPath indexPathForRow:(_entities.count - 2)
//                                              inSection:0]]) {
//        [self loadNext];
//    }
}

@end
