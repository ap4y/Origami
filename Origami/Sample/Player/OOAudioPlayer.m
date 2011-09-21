//
//  OOAudioPlayer.m
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OOAudioPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@implementation OOAudioPlayer
@synthesize tracks = _tracks, currentTrack = _currentTrack, status = _status;

- (void)postStartedPlayNotification:(Track*)track; {
    if (self) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OOAudioPlayerdidStartedPlay" object:self];    
    }    
}

- (void)postPausedPlayNotification {
    if (self) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OOAudioPlayerdidPausedPlay" object:self];
    }
    //[_delegate player:self didPausedPlay:self.track];
}

- (void)next {
    if (_status == OOAudioPlayerStatusPlaying) {
        [_player pause];    
        [self play:_tracks fromTrack:_currentTrack + 1];
    }
}

- (void)previous {
    if (_status == OOAudioPlayerStatusPlaying) {
        [_player pause];    
        [self play:_tracks fromTrack:_currentTrack - 1];
    }
}

- (void)pause {
    [_player pause];
    [self postPausedPlayNotification];
}

- (void)stop {
    [_player stop];
    [self postPausedPlayNotification];
}

- (void)resume {
    [_player resume];
}

- (void)play:(NSArray*)tracks fromTrack:(int)firstTrack {
    _tracks = tracks;
    _currentTrack = firstTrack;
    
    if (_tracks != nil && _currentTrack >= 0 && _tracks.count > _currentTrack) {
        Track* track = [_tracks objectAtIndex:_currentTrack];
        [_player play:[NSURL URLWithString: track.url]];
        //[_delegate player:self didStartedPlay:track];
        [self postStartedPlayNotification:track];
  
        NSLog(@"%f", self.trackTime);
    }    
    else {
        [_player stop];
        _currentTrack = 0;
        //[_delegate player:self didStartedPlay:nil];
        [self postStartedPlayNotification:nil];
    }
}

- (void)play:(NSArray*)tracks {
    [self play:tracks fromTrack:0];
}

- (void)playLoadedTracks {
    [self play:_tracks fromTrack:0];
}

- (void)playLoadedTracks:(Track*)fromTrack {
    [self play:_tracks fromTrack:[_tracks indexOfObject:fromTrack]];
}

- (void)seek:(double)time {
    [_player seekToTime:time];
}

- (double)trackTime {
    return _player.trackTime;
}

- (double)amountPlayed {
    return _player.amountPlayed;
}

- (Track*)track {
    if (_tracks && _tracks.count > _currentTrack) {
        return [_tracks objectAtIndex:_currentTrack];
    }
    return nil;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous];
            break;
        case UIEventSubtypeRemoteControlPlay:
            [self playLoadedTracks];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;    
        case UIEventSubtypeRemoteControlPause:
            [self pause];
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if (_status == OOAudioPlayerStatusPaused)
                [self resume];
            else
                [self pause];
            break;
        default:
            break;
    }
}

-(void)audioPlayer:(AudioPlayer *)player willEndStream:(id)userInfo {    
    NSLog(@"tracks count: %i, wish to play: %i", _tracks.count, _currentTrack + 1);
    if (_tracks.count > _currentTrack + 1) {
        _currentTrack++;
        [player setNextStream:[NSURL URLWithString:self.track.url]];
        //[_delegate player:self didStartedPlay:track];
        [self postStartedPlayNotification:self.track];
    }    
    else
        [player stop];
}

-(void)audioPlayer:(AudioPlayer *)player didBeginStream:(id)userInfo {
    
}

-(void)audioPlayer:(AudioPlayer *)player didChangeStatus:(int)status {
    _status = (OOAudioPlayerStatuses)status;
}

+ (OOAudioPlayer *)defaultPlayer
{
    static OOAudioPlayer *defaultPlayer;
    
    @synchronized(self)
    {
        if (!defaultPlayer)
            defaultPlayer = [[OOAudioPlayer alloc] init];        
        
        return defaultPlayer;
    }
}

void audioRouteChangeListenerCallback (void                      *inUserData,
                                       AudioSessionPropertyID    inPropertyID,
                                       UInt32                    inPropertyValueSize,
                                       const void                *inPropertyValue) {	
    
	if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    
    OOAudioPlayer* player = [OOAudioPlayer defaultPlayer];
    
	if (player.status == OOAudioPlayerStatusStopped ) {        
		NSLog (@"Audio route change while application audio is stopped.");
		return;
		
	} else {        
		CFDictionaryRef	routeChangeDictionary = inPropertyValue;
		
		CFNumberRef routeChangeReasonRef =
        CFDictionaryGetValue (routeChangeDictionary,
                              CFSTR (kAudioSession_AudioRouteChangeKey_Reason));        
		SInt32 routeChangeReason;		
		CFNumberGetValue (
                          routeChangeReasonRef,
                          kCFNumberSInt32Type,
                          &routeChangeReason
                          );
		
		if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {            
			[player pause];
			NSLog (@"Output device removed, so application audio was paused.");
            
		} else {            
			NSLog (@"A route change occurred that does not require pausing of application audio.");
		}
	}
}

- (id)init {
    self = [super init];
    if (self) {
        _player = [[AudioPlayer alloc] init];
        _player.delegate = self;           
        
        // Set AudioSession
        NSError *sessionError = nil;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
        [[AVAudioSession sharedInstance] setActive:YES error:&sessionError];
        [[AVAudioSession sharedInstance] setDelegate:self];
        
        AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange,
                                         audioRouteChangeListenerCallback,
                                         self
                                         );
        
        
    }
    return self;
}

@end
