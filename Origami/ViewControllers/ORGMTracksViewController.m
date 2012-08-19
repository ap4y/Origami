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

@interface ORGMTracksViewController () {
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

- (void)loadNext {
    _isLoading = YES;
    [ORGMTrack fetchTracksWithOffset:_entities.count success:^(NSArray *entities) {
        if (entities.count <= 0) {
            [_tableViewOutlet setTableFooterView:nil];
            return;
        }
        [_tableViewOutlet.tableFooterView setHidden:NO];
        _isLoading = NO;
        [_entities addObjectsFromArray:entities];
        [_tableViewOutlet reloadData];
    } failure:^(NSError *error) {
        _isLoading = NO;
        NSLog(@"%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backView = [ORGMCustomization backgroundImage];
    backView.frame = self.view.bounds;
    [self.view insertSubview:backView belowSubview:_tableViewOutlet];

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
    return _entities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORGMTrackCell *cell = [tableView dequeueReusableCellWithIdentifier:@"trackCell"];
    [cell setTrack:[_entities objectAtIndex:indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isLoading) return;
    NSArray *indexes = [_tableViewOutlet indexPathsForVisibleRows];
    NSIndexPath *lastIndex = [indexes objectAtIndex:indexes.count - 1];
    if ([lastIndex isEqual:[NSIndexPath indexPathForRow:(_entities.count - 2)
                                              inSection:0]]) {
        [self loadNext];
    }
}

@end
