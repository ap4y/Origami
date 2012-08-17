//
//  ORGMSideMenuViewController.m
//  Origami
//
//  Created by ap4y on 8/16/12.
//
//

#import "ORGMSideMenuViewController.h"

#import <QuartzCore/QuartzCore.h>

const CGFloat screenWidth = 320.0;
const CGFloat resettedCenter = 160.0;
const CGFloat anchorRightPeekAmount = 100.0;

@interface ORGMSideMenuViewController () {
    CGFloat _initialTouchPositionX;
    CGFloat _initialHoizontalCenter;
    BOOL _underLeftShowing;
}
@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;
@end

@implementation ORGMSideMenuViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        

    }
    return self;
}

#pragma mark - public
- (void)anchorTopViewWithComplete:(void (^)())complete {
    CGFloat newCenter = screenWidth + resettedCenter - anchorRightPeekAmount;    
    [self topViewHorizontalCenterWillChange:newCenter];    
    [UIView animateWithDuration:0.25f animations:^{
        [self updateTopViewHorizontalCenter:newCenter];
    } completion:^(BOOL finished){
        if (complete) {
            complete();
        }
    }];
}

- (void)resetTopViewWithComplete:(void(^)())complete {
    [self topViewHorizontalCenterWillChange:resettedCenter];    
    [UIView animateWithDuration:0.25f animations:^{
        [self updateTopViewHorizontalCenter:resettedCenter];
    } completion:^(BOOL finished) {
        if (complete) {
            complete();
        }
        [self topViewHorizontalCenterDidChange:resettedCenter];
    }];
}

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                          action:@selector(panGesture:)];
    [self.view addGestureRecognizer:_panGesture];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIPanGestureRecognizer
- (void)panGesture:(UIPanGestureRecognizer *)recognizer {
    CGPoint currentTouchPoint     = [recognizer locationInView:self.view];
    CGFloat currentTouchPositionX = currentTouchPoint.x;
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        _initialTouchPositionX = currentTouchPositionX;
        _initialHoizontalCenter = self.topView.center.x;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat panAmount = _initialTouchPositionX - currentTouchPositionX;
        CGFloat newCenterPosition = _initialHoizontalCenter - panAmount;
        
        if (newCenterPosition < resettedCenter) {
            newCenterPosition = resettedCenter;
        }
        
        [self topViewHorizontalCenterWillChange:newCenterPosition];
        [self updateTopViewHorizontalCenter:newCenterPosition];
        [self topViewHorizontalCenterDidChange:newCenterPosition];
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint currentVelocityPoint = [recognizer velocityInView:self.view];
        CGFloat currentVelocityX     = currentVelocityPoint.x;
        
        if (_underLeftShowing && currentVelocityX > 100) {
            [self anchorTopViewWithComplete:nil];
        } else {
            [self resetTopViewWithComplete:nil];
        }
    }
}

#pragma mark - private
- (void)setTopViewController:(UIViewController *)theTopViewController {
    _topViewController = theTopViewController;
    
    [self addChildViewController:self.topViewController];
    
    [_topViewController.view setFrame:self.view.bounds];
    _topViewController.view.layer.shadowOffset = CGSizeZero;
    _topViewController.view.layer.shadowPath =
    [UIBezierPath bezierPathWithRect:self.view.layer.bounds].CGPath;
    
    _topViewController.view.layer.shadowOpacity = 0.75f;
    _topViewController.view.layer.shadowRadius = 3.0f;
    _topViewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [self.view addSubview:_topViewController.view];
}

- (UIView *)topView {
    return self.topViewController.view;
}

- (void)updateTopViewHorizontalCenter:(CGFloat)newHorizontalCenter {
    CGPoint center = self.topView.center;
    center.x = newHorizontalCenter;
    self.topView.layer.position = center;
}

- (void)topViewHorizontalCenterWillChange:(CGFloat)newHorizontalCenter {
    CGPoint center = self.topView.center;
    if (center.x <= resettedCenter && newHorizontalCenter > resettedCenter) {
        _underLeftShowing  = YES;
    }
}

- (void)topViewHorizontalCenterDidChange:(CGFloat)newHorizontalCenter {
    if (newHorizontalCenter == resettedCenter) {
        _underLeftShowing   = NO;
    }
}

@end
