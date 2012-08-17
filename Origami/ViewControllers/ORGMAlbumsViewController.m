//
//  ORGMLibraryViewController.m
//  Origami
//
//  Created by ap4y on 8/16/12.
//
//

#import "ORGMAlbumsViewController.h"
#import "ORGMAlbum.h"
#import "ORGMAlbumCell.h"

const NSInteger loadMoreThreshold = 100;

@interface ORGMAlbumsViewController () <UITableViewDataSource, UITableViewDelegate> {
    BOOL _isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) NSMutableArray *albums;
@end

@implementation ORGMAlbumsViewController
@synthesize tableViewOutlet = _tableViewOutlet;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.albums = [[NSMutableArray alloc] init];
        _isLoading = NO;
    }
    return self;
}

- (void)loadNext {
    _isLoading = YES;
    [ORGMAlbum fetchAlbumsWithOffset:_albums.count success:^(NSArray *entities) {
        if (entities.count <= 0) {
            [_tableViewOutlet setTableFooterView:nil];
            return;
        }
        [_tableViewOutlet.tableFooterView setHidden:NO];
        _isLoading = NO;
        [_albums addObjectsFromArray:entities];
        [_tableViewOutlet reloadData];
    } failure:^(NSError *error) {
        _isLoading = NO;
        NSLog(@"%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableViewOutlet.tableFooterView setHidden:YES];
    [self loadNext];
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
    return _albums.count/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ORGMAlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell"];
    NSInteger index = indexPath.row * 2;
    [cell setAlbums:@[[_albums objectAtIndex:index], [_albums objectAtIndex:index + 1]]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isLoading) return;
    NSArray *indexes = [_tableViewOutlet indexPathsForVisibleRows];
    NSIndexPath *lastIndex = [indexes objectAtIndex:indexes.count - 1];
    if ([lastIndex isEqual:[NSIndexPath indexPathForRow:(_albums.count/2 - 1)
                                              inSection:0]]) {
        NSLog(@"loading!!!");
        [self loadNext];
    }
}
@end
