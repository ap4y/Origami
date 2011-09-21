//
//  PlayerControlView.m
//  Sample
//
//  Created by Arthur Evstifeev on 26.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlayerControlView.h"
#import "Three20/Three20.h"
#import "NSString+URLEncode.h"

@implementation PlayerControlView

-(void)dealloc {
    [btnAdd release];
    [btnFlex release];
    [btnNext release];    
    [btnPause release];
    [btnPlay release];
    [btnPrev release];
    [super dealloc];
}

-(void)setStatePlay:(BOOL) play {    
    if (play)
        [self setItems:[NSArray arrayWithObjects:btnFlex, btnPrev, btnFlex, btnPause, btnFlex, btnNext, btnFlex, btnAdd, nil]];        
    else
        [self setItems:[NSArray arrayWithObjects:btnFlex, btnPrev, btnFlex, btnPlay, btnFlex, btnNext, btnFlex, btnAdd, nil]];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        btnPrev = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRewind target:self action:@selector(prev:)];
        
        btnPause = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pause:)];
        
        btnPlay = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play:)];
        
        btnNext = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFastForward target:self action:@selector(next:)];
        
        btnFlex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                
        btnAdd = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goToNavigator:)];
        
        //toolBar.translucent = YES;
        self.tintColor = [UIColor blackColor];
        [self setStatePlay:NO];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didStartedPlay:) name:@"OOAudioPlayerdidStartedPlay" object:[OOAudioPlayer defaultPlayer]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPausedPlay:) name:@"OOAudioPlayerdidPausedPlay" object:[OOAudioPlayer defaultPlayer]];
    }
    return self;
}

-(void)didStartedPlay:(NSNotification*)notification {
    [self setStatePlay:YES];
}

-(void)didPausedPlay:(NSNotification*)notification {
    [self setStatePlay:NO];
}

-(void)prev:(id)sender {
    [[OOAudioPlayer defaultPlayer] previous];
}

-(void)pause:(id)sender {
    [[OOAudioPlayer defaultPlayer] pause];
    [self setStatePlay:NO];
}

-(void)play:(id)sender {
    OOAudioPlayer* player = [OOAudioPlayer defaultPlayer];
    
    if (player.status == OOAudioPlayerStatusPaused) {
        [player resume];
    }
    else if(player.status != OOAudioPlayerStatusPlaying) {
        [player playLoadedTracks];
    }
    
    [self setStatePlay:YES];
}

-(void)next:(id)sender {
    [[OOAudioPlayer defaultPlayer] next];
}

-(void)goToNavigator:(id)sender {
    NSArray *paths = [[NSFileManager defaultManager]  URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];;    
    NSURL* path = [paths lastObject];
    
    //NSURL* path = [NSBundle mainBundle].bundleURL;
    
    NSString* urlPath = [NSString stringWithFormat:@"tt://directory/%@", [NSString stringWithSpecialEncodeOfString:path.absoluteString]];
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:urlPath]];
}

@end
