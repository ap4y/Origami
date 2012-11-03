//
//  ORGMWithControlsViewController.m
//  Origami
//
//  Created by ap4y on 11/3/12.
//
//

#import "ORGMWithControlsViewController.h"

@interface ORGMWithControlsViewController ()
@property (strong, nonatomic) NSMutableArray *entities;
@property (strong, nonatomic) ORGMPlayerView *playerView;
@end

@implementation ORGMWithControlsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.entities = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playerView = [[ORGMPlayerView alloc] initWithFrame:CGRectNull];
    [self.playerView addShortControlsForNavItem:self.navigationItem];
    [self.playerView setViewStateChangeBlock:^(ORGMPlayerViewState newState) {
        if (newState == ORGMPlayerViewStatePresented) {
            self.sideMenuController.panGesture.enabled = NO;
        } else {
            self.sideMenuController.panGesture.enabled = YES;
        }
    }];
    [self.playerView presentInView:self.view
                        uponNavBar:self.navigationController.navigationBar];    
}

@end