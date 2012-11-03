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
#import "NSArray+orderBy.h"

@interface ORGMTracksViewController () <UISearchBarDelegate, UITableViewDelegate> {
    BOOL _isLoading;    
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@end

@implementation ORGMTracksViewController
NSUInteger const kMinSearchSymbols = 3;

- (void)reloadData {
    [self.entities removeAllObjects];
    if (!_tracks || _tracks.count <= 0) {
        [self.entities addObjectsFromArray:[ORGMTrack libraryTracks]];
    } else {
        [self.entities addObjectsFromArray:[_tracks orderBy:@"track_num", nil]];
    }
    
    [_tableViewOutlet reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableViewOutlet setTableFooterView:nil];
    
    UIImageView *backView = [ORGMCustomization backgroundImage];
    backView.frame = self.view.bounds;
    [self.view insertSubview:backView belowSubview:_tableViewOutlet];
    [self reloadData];    
    
    UIView *stripeView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 2.0)];
    stripeView.backgroundColor =
        [ORGMCustomization colorForColoredEntityType:ORGMColoredEntitiesTypeTrack];
    [self.navigationController.navigationBar addSubview:stripeView];
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
    return self.entities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORGMTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackCell"];
    [cell setTrack:[self.entities objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[ORGMPlayerController defaultPlayer] playTracks:self.entities from:indexPath.row];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (_isLoading) return;
//    NSArray *indexes = [_tableViewOutlet indexPathsForVisibleRows];
//    NSIndexPath *lastIndex = [indexes objectAtIndex:indexes.count - 1];
//    if ([lastIndex isEqual:[NSIndexPath indexPathForRow:(_entities.count - 2)
//                                              inSection:0]]) {
//        [self loadNext];
//    }
//}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length >= kMinSearchSymbols) {
        NSPredicate *searchPredicate =
            [NSPredicate predicateWithFormat:@"title contains[cd] %@ or album.title contains[cd] %@ or album.artist.title contains[cd] %@",
             searchText, searchText, searchText];
        self.tracks = [self.entities filteredArrayUsingPredicate:searchPredicate];
    }
    
    [self reloadData];
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
