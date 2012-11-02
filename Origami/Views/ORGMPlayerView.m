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

@interface ORGMPlayerView () <ORGMPlayerControllerDelegate> {
    CGFloat _savedPosition;
    CGFloat _savedViewPosition;
}
@property (weak, nonatomic) IBOutlet UILabel *trackTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *trackTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playedTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverArtImageView;
@property (weak, nonatomic) IBOutlet UILabel *shortTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shortCoverArtImageView;
@property (weak, nonatomic) IBOutlet UILabel *shortArtistLabel;
@property (weak, nonatomic) IBOutlet UISlider *seekSlider;
@property (strong, nonatomic) IBOutlet UIView *playerView;
@property (strong, nonatomic) IBOutlet UIView *controlsView;
@property (strong, nonatomic) IBOutlet UIView *shortPlayerView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (strong, nonatomic) UINavigationBar *navBar;
@property (assign, nonatomic) ORGMPlayerViewState viewState;
@property (strong, nonatomic) NSTimer* refreshTimer;
@property (nonatomic) BOOL isSeeking;
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
        
        ORGMPlayerController *controller = [ORGMPlayerController defaultPlayer];
        controller.delegate = self;        
        if (controller.currentTrack) {
            [self setCurrentTrackInfo:controller.currentTrack];
        } else {
            [self resetCurrentTrackInfo];
        }
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

- (IBAction)previous:(id)sender {
    [[ORGMPlayerController defaultPlayer] prev];
}

- (IBAction)toggle:(id)sender {
    [[ORGMPlayerController defaultPlayer] toggle];
}

- (IBAction)next:(id)sender {
    [[ORGMPlayerController defaultPlayer] next];
}

- (IBAction)startedSeekToValue:(id)sender {
    _isSeeking = YES;
}

- (IBAction)seekToValue:(id)sender {
    _isSeeking = NO;
    [[ORGMPlayerController defaultPlayer] seekToTime:seekSlider.value];
}

#pragma mark - private
- (NSString *)formatSeconds:(double)seconds {
    int minute = floor(seconds/60);
    int second = round(seconds - minute * 60);
    
    return [NSString stringWithFormat:@"%i:%02d", minute, second];
}

- (void)setCurrentTrackInfo:(ORGMTrack *)track {
    _trackTitleLabel.text = track.title;
    _albumTitleLabel.text = track.album.title;
    _artistTitleLabel.text = track.album.artist.title;
    _shortTitleLabel.text = track.title;
    _shortArtistLabel.text = track.album.artist.title;
    
    ORGMPlayerController *controller = [ORGMPlayerController defaultPlayer];
    double trackTime = [controller trackTime];
    _trackTimeLabel.text = [self formatSeconds:trackTime];
    _playedTimeLabel.text = [self formatSeconds:[controller amountPlayed]];
    seekSlider.maximumValue = trackTime;
    
    [controller currentCovertArtImage:^(UIImage *coverArt) {
        if (coverArt) {
            [_coverArtImageView setImage:coverArt];
            [_shortCoverArtImageView setImage:coverArt];
        } else {
            [_coverArtImageView setImage:[UIImage imageNamed:@"cover"]];
            [_shortCoverArtImageView setImage:[UIImage imageNamed:@"Icon"]];
        }
    }];
}

- (void)resetCurrentTrackInfo {
    _trackTitleLabel.text = NSLocalizedString(@"Origami", nil);
    _albumTitleLabel.text = @"";
    _artistTitleLabel.text = @"";
    _shortTitleLabel.text = NSLocalizedString(@"Origami", nil);
    _shortArtistLabel.text = @"";
    
    _trackTimeLabel.text = @"0:00";
    _playedTimeLabel.text = @"0:00";

    [_coverArtImageView setImage:[UIImage imageNamed:@"cover"]];
    [_shortCoverArtImageView setImage:[UIImage imageNamed:@"Icon"]];
}

- (void)refreshUI {
    ORGMPlayerController *controller = [ORGMPlayerController defaultPlayer];
    if (controller.currentState == ORGMEngineStatePlaying) {
        double played = [controller amountPlayed];
        _playedTimeLabel.text = [self formatSeconds:played];
        if (!_isSeeking) {
            seekSlider.value = played;
        }
    }
}

#pragma mark - ORGMPlayerControllerDelegate
- (void)playerController:(ORGMPlayerController *)controller startedTrack:(ORGMTrack *)track {
    [self setCurrentTrackInfo:track];
}

- (void)playerController:(ORGMPlayerController *)controller stoppedTrack:(ORGMTrack *)track {
    [self resetCurrentTrackInfo];
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
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(refreshUI)
                                                       userInfo:nil
                                                        repeats:YES];
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
    [_refreshTimer invalidate];
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
