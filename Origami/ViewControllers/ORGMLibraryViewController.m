//
//  ORGMLibraryViewController.m
//  Origami
//
//  Created by ap4y on 8/16/12.
//
//

#import "ORGMLibraryViewController.h"

#import "ORGMEntityWithCoverCell.h"
#import "ORGMCustomization.h"
#import "ORGMPlayerView.h"
#import "ORGMTracksViewController.h"

@interface ORGMLibraryViewController () <UITableViewDataSource, UITableViewDelegate,
                                         ORGMEntityWithCoverCellDelegate,
                                         UISearchBarDelegate> {
    BOOL _isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) NSMutableArray *entities;
@property (strong, nonatomic) ORGMEntity *segueEntity;
@property (strong, nonatomic) ORGMPlayerView *playerView;
@property (strong, nonatomic) NSArray *savedTracks;
@end

@implementation ORGMLibraryViewController
@synthesize tableViewOutlet = _tableViewOutlet;

NSString * const tracksSegueName = @"entityTracksSegue";
NSUInteger const kMinSearchSymbols = 3;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.entities = [[NSMutableArray alloc] init];
        _isLoading = NO;
    }
    return self;
}

- (void)reloadData {
    [self reloadDataWithData:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableViewOutlet setTableFooterView:nil];
    
    [_tableViewOutlet setBackgroundView:[ORGMCustomization backgroundImage]];
    [self reloadData];
    
    self.playerView = [[ORGMPlayerView alloc] initWithFrame:CGRectNull];
    [_playerView addShortControlsForNavItem:self.navigationItem];
    [_playerView setViewStateChangeBlock:^(ORGMPlayerViewState newState) {
        if (newState == ORGMPlayerViewStatePresented) {
            self.sideMenuController.panGesture.enabled = NO;
        } else {
            self.sideMenuController.panGesture.enabled = YES;
        }
    }];
    [_playerView presentInView:self.view
                    uponNavBar:self.navigationController.navigationBar];
    
    UIView *stripeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 2.0)];
    stripeView.backgroundColor =
        [ORGMCustomization colorForColoredEntityType:_controllerType];
    [self.navigationController.navigationBar addSubview:stripeView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ORGMPlayerController *controller = [ORGMPlayerController defaultPlayer];    
    if (controller.currentTrack) {
        [_playerView setCurrentTrackInfo:controller.currentTrack];
    } else {
        [_playerView resetCurrentTrackInfo];
    }
}

- (void)viewDidUnload {
    [self setTableViewOutlet:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:tracksSegueName]) {
        ORGMTracksViewController *controller = [segue destinationViewController];
        switch (_controllerType) {
            case ORGMLibraryControllerAlbum:
                controller.tracks = [((ORGMAlbum *)_segueEntity).tracks allObjects];
                break;
            case ORGMLibraryControllerGenre:
                controller.tracks = [((ORGMGenre *)_segueEntity).tracks allObjects];
                break;
            case ORGMLibraryControllerArtist: {
                ORGMArtist *artist = (ORGMArtist *)_segueEntity;
                NSSet *tracks =
                    [artist.albums valueForKeyPath:@"@distinctUnionOfSets.tracks"];
                controller.tracks = [tracks allObjects];
                break;
            }
        }
        self.segueEntity = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - private
- (void)reloadDataWithData:(NSArray *)data {
    NSArray *items = nil;
    if (data && [data count] > 0) {
        items = data;
    } else {
        switch (_controllerType) {
            case ORGMLibraryControllerArtist:
                items = [ORGMArtist libraryArtists];
                break;
            case ORGMLibraryControllerAlbum:
                items = [ORGMAlbum libraryAlbums];
                break;
            case ORGMLibraryControllerGenre:
                items = [ORGMGenre libraryGenres];
                break;
        }
    }
    
    [_entities removeAllObjects];
    [_entities addObjectsFromArray:items];
    [_tableViewOutlet reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return round(_entities.count/2.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORGMEntityWithCoverCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"coverCell"];
    cell.delegate = self;
    NSInteger index = indexPath.row * 2;
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[_entities objectAtIndex:index]];
    if (index + 1 < _entities.count) {
        [items addObject:[_entities objectAtIndex:index + 1]];
    }
    [cell setEntities:items];
    return cell;
}

#pragma mark - UITableViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (_isLoading) return;
//    NSArray *indexes = [_tableViewOutlet indexPathsForVisibleRows];
//    NSIndexPath *lastIndex = [indexes objectAtIndex:indexes.count - 1];
//    if ([lastIndex isEqual:[NSIndexPath indexPathForRow:(_entities.count/2 - 1)
//                                              inSection:0]]) {
//        [self loadNext];
//    }
//}

#pragma mark - ORGMEntityWithCoverCellDelegate
- (void)coverCell:(ORGMEntityWithCoverCell *)coverCell didTapViewWithEntity:(ORGMEntity *)entity {
    self.segueEntity = entity;
    [self performSegueWithIdentifier:tracksSegueName sender:self];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSArray *items = nil;
    if (searchText.length >= kMinSearchSymbols) {
        self.savedTracks = _entities;
        NSPredicate *searchPredicate =
            [NSPredicate predicateWithFormat:@"title contains[cd] %@", searchText];
        if (_controllerType == ORGMLibraryControllerAlbum) {
            searchPredicate =
                [NSPredicate predicateWithFormat:@"title contains[cd] %@ or artist.title",
                 searchText, searchText];
        }
        items = [_entities filteredArrayUsingPredicate:searchPredicate];
    }

    [self reloadDataWithData:items];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
}

@end
