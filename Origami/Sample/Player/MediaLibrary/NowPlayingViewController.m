//
//  NowPlayingViewController.m
//  Sample
//
//  Created by Arthur Evstifeev on 26.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "OOAudioPlayer.h"
#import "PlayerControlView.h"
#import "Track.h"

@implementation NowPlayingViewController

- (NSString*)formatSeconds:(double)seconds {
    int minute = floor(seconds/60);
    int second = round(seconds - minute * 60);
    
    return [NSString stringWithFormat:@"%i:%i", minute, second];
}

- (void)setValues {
    OOAudioPlayer* player = [OOAudioPlayer defaultPlayer];
    
    double played = player.amountPlayed;
    double trackTime = player.trackTime <= 0 ? 1 : player.trackTime;
    
    timePlayed.text = [self formatSeconds:played];
    double left = trackTime >= played ? trackTime - played : 0;
    timeLeft.text = [self formatSeconds:left];
    trackProgress.value = played/trackTime;
}

- (void)setTrackValues {
    OOAudioPlayer* player = [OOAudioPlayer defaultPlayer];
    Track* track = player.track;
    titleStr.text = track.title;
    artist.text = [NSString stringWithFormat:@"%@ - %@", track.artist, track.album];
    year.text = track.trackNo.stringValue;
    trackCount.text = [NSString stringWithFormat:@"%i/%i", player.currentTrack + 1, player.tracks.count];
    
    if (track.cover != nil)
        coverArt.image = [UIImage imageWithData:track.cover];
    else
        coverArt.image = [UIImage imageNamed:@"disc.png"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    timeLeft.font = [UIFont fontWithName:@"Segoe UI" size:12];
    timePlayed.font = [UIFont fontWithName:@"Segoe UI" size:12];
    titleStr.font = [UIFont fontWithName:@"Segoe UI" size:16];
    artist.font = [UIFont fontWithName:@"Segoe UI" size:14];
    year.font = [UIFont fontWithName:@"Segoe UI" size:14];
    trackCount.font = [UIFont fontWithName:@"Segoe UI" size:14];
      
    [self setTrackValues];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(setValues) userInfo:nil repeats:YES];
    
    PlayerControlView* playerControl = [[[PlayerControlView alloc] initWithFrame:CGRectMake(0, 416, 320, 44)] autorelease];
    [playerControl setStatePlay:YES];
    [self.view addSubview:playerControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartedPlay:) name:@"OOAudioPlayerdidStartedPlay" object:[OOAudioPlayer defaultPlayer]];
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]
                                            initWithTarget:self
                                            action:@selector(swipeDidOccur:)];
    [recognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    coverArt.userInteractionEnabled = YES;
    [coverArt addGestureRecognizer:recognizer];
    [recognizer release]; 
    
    [self setValues];
}

- (void) swipeDidOccur:(UISwipeGestureRecognizer *)recognizer {
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://library/"]];
}

-(void)didStartedPlay:(NSNotification*)notification {
    [self setTrackValues];
}

- (IBAction)seekToValue:(id)sender {
    OOAudioPlayer* player = [OOAudioPlayer defaultPlayer];
    
    [player seek:trackProgress.value*player.trackTime];
}

- (void)dealloc {
    [trackProgress release];
    [timeLeft release];
    [timePlayed release];
    [coverArt release];
    [titleStr release];
    [artist release];
    [year release];
    [trackCount release];
    [super dealloc];
}

- (void)viewDidUnload {
    [trackProgress release];
    trackProgress = nil;
    [timeLeft release];
    timeLeft = nil;
    [timePlayed release];
    timePlayed = nil;
    [coverArt release];
    coverArt = nil;
    [titleStr release];
    titleStr = nil;
    [artist release];
    artist = nil;
    [year release];
    year = nil;
    [trackCount release];
    trackCount = nil;
    [super viewDidUnload];
}
@end
