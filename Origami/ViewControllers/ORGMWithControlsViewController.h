//
//  ORGMWithControlsViewController.h
//  Origami
//
//  Created by ap4y on 11/3/12.
//
//

#import <UIKit/UIKit.h>
#import "ORGMPlayerView.h"

@interface ORGMWithControlsViewController : UIViewController
@end

@interface ORGMWithControlsViewController (Private)
@property (strong, nonatomic) NSMutableArray *entities;
@property (strong, nonatomic) ORGMPlayerView *playerView;
@end