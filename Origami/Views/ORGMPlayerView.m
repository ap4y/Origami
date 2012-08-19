//
//  ORGMPlayerView.m
//  Origami
//
//  Created by ap4y on 8/19/12.
//
//

#import "ORGMPlayerView.h"

const CGFloat screenHeight = 460.0;
const CGFloat resetHeight = 460.0/2;
const CGFloat viewThreshold = -22.0;

@interface ORGMPlayerView () {
    CGFloat _savedPosition;
    CGFloat _savedViewPosition;
}
@property (weak, nonatomic) IBOutlet UISlider *seekSlider;
@property (strong, nonatomic) IBOutlet UIView *playerView;
@property (strong, nonatomic) IBOutlet UIView *controlsView;
@property (strong, nonatomic) IBOutlet UIView *shortPlayerView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (assign, nonatomic) ORGMPlayerViewState viewState;
@end

@implementation ORGMPlayerView
@synthesize seekSlider;
@synthesize playerView;
@synthesize controlsView;
@synthesize shortPlayerView;
@synthesize backImageView;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frameRect = frame;
        if (frame.size.width == 0 || frame.size.height == 0) {
            frameRect = CGRectMake(0.0, -screenHeight, 320.0, 416.0);
        }
        [[NSBundle mainBundle] loadNibNamed:@"ORGMPlayerView" owner:self options:nil];
        playerView.frame = CGRectMake(0.0, 0.0,
                                      frameRect.size.width, frameRect.size.height);
        self.frame = frameRect;
        [self addSubview:playerView];
        
        UIImage *backImage =
            [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        [backImageView setImage:backImage];
        
        _viewState = ORGMPlayerViewStateHidden;
    }
    return self;
}

- (void)presentInView:(UIView *)view uponNavBar:(UINavigationBar *)navBar {
    self.navBar = navBar;            
    UIPanGestureRecognizer *panGesture =
        [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [navBar addGestureRecognizer:panGesture];
    [view addSubview:self];
}

- (void)addShortControlsForNavItem:(UINavigationItem *)navItem {
    UIBarButtonItem *rightButton =
        [[UIBarButtonItem alloc] initWithCustomView:controlsView];
    [navItem setRightBarButtonItem:rightButton];
    
    [navItem setTitleView:shortPlayerView];
}

#pragma mark - UIPanGestureRecognizer
- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint curPosition = [gestureRecognizer translationInView:_navBar];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _savedPosition = _navBar.center.y;
        _savedViewPosition = self.center.y;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        if (curPosition.y + _savedPosition < 44.0 + viewThreshold) {
            curPosition.y = 44.0 + viewThreshold - _savedPosition;
        }
        _navBar.center = CGPointMake(_navBar.center.x, curPosition.y + _savedPosition);
        self.center = CGPointMake(self.center.x, curPosition.y + _savedViewPosition);
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
               gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint currentVelocityPoint = [gestureRecognizer velocityInView:_navBar];

        if (curPosition.y > resetHeight || currentVelocityPoint.y > 100) {
            [self presentFullView];
        } else {
            [self resetView];
        }
    }
}

- (void)presentFullView {
    [UIView animateWithDuration:0.2 animations:^{
        _navBar.center = CGPointMake(_navBar.center.x, screenHeight + viewThreshold);
        self.center = CGPointMake(self.center.x,
                                  (self.frame.size.height - 44.0)/2 + viewThreshold);
    } completion:^(BOOL finished) {
        _viewState = ORGMPlayerViewStatePresented;
        if (_viewStateChangeBlock) {
            _viewStateChangeBlock(_viewState);
        }
    }];
}

- (void)resetView {
    [UIView animateWithDuration:0.2 animations:^{
        _navBar.center = CGPointMake(_navBar.center.x, 44.0 + viewThreshold);
        self.center = CGPointMake(self.center.x, -screenHeight/2 + viewThreshold);
    } completion:^(BOOL finished) {
        _viewState = ORGMPlayerViewStateHidden;
        if (_viewStateChangeBlock) {
            _viewStateChangeBlock(_viewState);
        }
    }];
}

@end
