//
//  TrackView.m
//  Sample
//
//  Created by Arthur Evstifeev on 25.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TrackView.h"
#import "OOAudioPlayer.h"
#import "Three20/Three20.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation TrackView
@synthesize track = _track;

/*- (void)dealloc {
    [_track dealloc];
    [super dealloc];
}*/

- (void)highlight:(BOOL)selected {
    if (selected) {         
        highlight.hidden = NO;
        //trackNo.textColor = RGB(110, 106, 124);
        title.textColor = [UIColor whiteColor];
        //time.textColor = RGB(110, 106, 124);
    }
    else {
        highlight.hidden = YES;  
        //trackNo.textColor = RGB(110, 106, 124);
        title.textColor = [UIColor blackColor];
        //time.textColor = RGB(110, 106, 124);
    }
}

- (id)initWithTrack:(Track*)track
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 40)];
    if (self) {        
        
        _track = track;
        
        highlight = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];        
        highlight.image = [UIImage imageNamed:@"highlight.png"];
        highlight.hidden = YES;
        [self addSubview:highlight];
        
        trackNo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 40)];
        trackNo.text = track.trackNo.stringValue;
        trackNo.font = [UIFont fontWithName:@"Segoe UI" size:12];        
        trackNo.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
        trackNo.textColor = RGB(110, 106, 124);
        trackNo.textAlignment = UITextAlignmentRight;
        [self addSubview:trackNo];
        
        UIImageView* splitter = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 20, 30)];        
        splitter.contentMode = UIViewContentModeCenter;
        splitter.image = [UIImage imageNamed:@"splitter.png"];
        [self addSubview:splitter];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 250, 40)];
        title.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
        title.text = track.title;
        title.font = [UIFont fontWithName:@"Segoe UI" size:12];        
        [self addSubview:title];
        
        time = [[UILabel alloc] initWithFrame:CGRectMake(290, 0, 30, 40)];
        time.text = @"";
        time.font = [UIFont fontWithName:@"Segoe UI" size:12];        
        time.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0];
        time.textColor = RGB(110, 106, 124);
        time.textAlignment = UITextAlignmentCenter;
        [self addSubview:time];
             
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(swipeDidOccurRight:)];
        
        [recognizer setDirection:UISwipeGestureRecognizerDirectionRight];
        [self addGestureRecognizer:recognizer];
        
        [recognizer release];
        [highlight release];
        [time release];
        [splitter release];
        [title release];
        [trackNo release];        
    }
    return self;
}

- (void) swipeDidOccurRight:(UISwipeGestureRecognizer *)recognizer {
    if ([OOAudioPlayer defaultPlayer].status != OOAudioPlayerStatusPlaying) {
        [[OOAudioPlayer defaultPlayer] playLoadedTracks:_track];        
    }        
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://nowplaying/"]];
}

+ (TrackView*)viewWithTrack:(Track*)track {
    return [[[TrackView alloc] initWithTrack:track] autorelease];    
}

@end
