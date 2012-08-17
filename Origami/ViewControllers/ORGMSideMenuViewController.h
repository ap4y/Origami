//
//  ORGMSideMenuViewController.h
//  Origami
//
//  Created by ap4y on 8/16/12.
//
//

#import <UIKit/UIKit.h>

@interface ORGMSideMenuViewController : UIViewController
@property (strong, nonatomic) UIViewController *topViewController;

- (void)anchorTopViewWithComplete:(void (^)())complete;
- (void)resetTopViewWithComplete:(void(^)())complete;
@end
