//
//  ORGMPlayerView.h
//  Origami
//
//  Created by ap4y on 8/19/12.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    ORGMPlayerViewStateHidden,
    ORGMPlayerViewStatePresented
} ORGMPlayerViewState;
typedef void(^ViewStateChangeBlock)(ORGMPlayerViewState newState);

@interface ORGMPlayerView : UIView
@property (assign, nonatomic, readonly) ORGMPlayerViewState viewState;
@property (copy, nonatomic) ViewStateChangeBlock viewStateChangeBlock;

- (void)presentInView:(UIView *)view uponNavBar:(UINavigationBar *)navBar;
- (void)addShortControlsForNavItem:(UINavigationItem *)navItem;
- (void)setCurrentTrackInfo:(ORGMTrack *)track;
- (void)resetCurrentTrackInfo;
@end
