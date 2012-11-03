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
@property (strong, nonatomic) ORGMEntity *segueEntity;
@end

@implementation ORGMLibraryViewController
@synthesize tableViewOutlet = _tableViewOutlet;

NSString * const tracksSegueName = @"entityTracksSegue";

- (void)reloadData {
    [self reloadDataWithData:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableViewOutlet setTableFooterView:nil];
    
    [_tableViewOutlet setBackgroundView:[ORGMCustomization backgroundImage]];
    [self reloadData];
    
    UIView *stripeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 2.0)];
    stripeView.backgroundColor =
        [ORGMCustomization colorForColoredEntityType:_controllerType];
    [self.navigationController.navigationBar addSubview:stripeView];
    
    __weak ORGMLibraryViewController *weakSelf = self;
    [self.playerView setStartPlayRequestBlock:^{
        NSMutableArray *tracks = [NSMutableArray array];
        [self.entities enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [tracks addObjectsFromArray:[weakSelf entityTracksForEntity:obj]];
        }];
        [[ORGMPlayerController defaultPlayer] playTracks:tracks from:0];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    ORGMPlayerController *controller = [ORGMPlayerController defaultPlayer];    
    if (controller.currentTrack) {
        [self.playerView setCurrentTrackInfo:controller.currentTrack];
    } else {
        [self.playerView resetCurrentTrackInfo];
    }
}

- (void)viewDidUnload {
    [self setTableViewOutlet:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:tracksSegueName]) {
        ORGMTracksViewController *controller = [segue destinationViewController];
        controller.tracks = [self entityTracksForEntity:_segueEntity];
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
    
    [self.entities removeAllObjects];
    [self.entities addObjectsFromArray:items];
    [_tableViewOutlet reloadData];
}

- (NSArray *)entityTracksForEntity:(ORGMEntity *)entity {
    switch (_controllerType) {
        case ORGMLibraryControllerAlbum:
            return [((ORGMAlbum *)entity).tracks allObjects];
        case ORGMLibraryControllerGenre:
            return [((ORGMGenre *)entity).tracks allObjects];
        case ORGMLibraryControllerArtist: {
            ORGMArtist *artist = (ORGMArtist *)entity;
            NSSet *tracks =
                [artist.albums valueForKeyPath:@"@distinctUnionOfSets.tracks"];
            return [tracks allObjects];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return round(self.entities.count/2.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORGMEntityWithCoverCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"coverCell"];
    cell.delegate = self;
    NSInteger index = indexPath.row * 2;
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:[self.entities objectAtIndex:index]];
    if (index + 1 < self.entities.count) {
        [items addObject:[self.entities objectAtIndex:index + 1]];
    }
    [cell setEntities:items];
    return cell;
}

#pragma mark - ORGMEntityWithCoverCellDelegate
- (void)coverCell:(ORGMEntityWithCoverCell *)coverCell didTapViewWithEntity:(ORGMEntity *)entity {
    self.segueEntity = entity;
    [self performSegueWithIdentifier:tracksSegueName sender:self];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSArray *items = nil;
    if (searchText.length >= kMinSearchSymbols) {
        NSPredicate *searchPredicate =
            [NSPredicate predicateWithFormat:@"title contains[cd] %@", searchText];
        if (_controllerType == ORGMLibraryControllerAlbum) {
            searchPredicate =
                [NSPredicate predicateWithFormat:@"title contains[cd] %@ or artist.title",
                 searchText, searchText];
        }
        items = [self.entities filteredArrayUsingPredicate:searchPredicate];
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
