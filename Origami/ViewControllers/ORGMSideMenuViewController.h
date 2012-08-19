//
//  ORGMSideMenuViewController.h
//  Origami
//
//  Created by ap4y on 8/16/12.
//
//

#import <UIKit/UIKit.h>

@class ORGMSideMenuViewController;
@interface UIViewController (ORGMSideMenuViewController)
- (ORGMSideMenuViewController *)sideMenuController;
@end

@interface ORGMSideMenuViewController : UIViewController
@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic, readonly) UIPanGestureRecognizer *panGesture;

- (void)anchorTopViewWithComplete:(void (^)())complete;
- (void)resetTopViewWithComplete:(void(^)())complete;
@end
