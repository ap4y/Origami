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

@interface ORGMLibraryViewController () <UITableViewDataSource, UITableViewDelegate> {
    BOOL _isLoading;
}
@property (weak, nonatomic) IBOutlet UITableView *tableViewOutlet;
@property (strong, nonatomic) NSMutableArray *entities;
@end

@implementation ORGMLibraryViewController
@synthesize tableViewOutlet = _tableViewOutlet;

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
    void (^success)(NSArray *entities) = ^(NSArray *entities) {
        if (entities.count <= 0) {
            [_tableViewOutlet setTableFooterView:nil];
            return;
        }
        [_tableViewOutlet.tableFooterView setHidden:NO];
        _isLoading = NO;
        [_entities addObjectsFromArray:entities];
        [_tableViewOutlet reloadData];
    };
    void (^failure)(NSError *error) = ^(NSError *error) {
        _isLoading = NO;
        NSLog(@"%@", error);
    };
//    switch (_controllerType) {
//        case ORGMLibraryControllerArtist:
//            [ORGMArtist fetchArtistsWithOffset:_entities.count
//                                       success:success failure:failure];
//            break;
//        case ORGMLibraryControllerAlbum:
//            [ORGMAlbum fetchAlbumsWithOffset:_entities.count
//                                     success:success failure:failure];
//            break;
//        case ORGMLibraryControllerGenre:
//            [ORGMGenre fetchGenresWithOffset:_entities.count
//                                     success:success failure:failure];
//            break;
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_tableViewOutlet setBackgroundView:[ORGMCustomization backgroundImage]];
    [self loadNext];
    
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
        [ORGMCustomization colorForColoredEntityType:_controllerType];
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
    return _entities.count/2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ORGMEntityWithCoverCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"coverCell"];
    NSInteger index = indexPath.row * 2;
    [cell setEntities:@[[_entities objectAtIndex:index],
                        [_entities objectAtIndex:index + 1]]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isLoading) return;
    NSArray *indexes = [_tableViewOutlet indexPathsForVisibleRows];
    NSIndexPath *lastIndex = [indexes objectAtIndex:indexes.count - 1];
    if ([lastIndex isEqual:[NSIndexPath indexPathForRow:(_entities.count/2 - 1)
                                              inSection:0]]) {
        [self loadNext];
    }
}
@end
