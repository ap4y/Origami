//
//  ORGMPlayerController.m
//  Origami
//
//  Created by ap4y on 10/31/12.
//
//

#import "ORGMPlayerController.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ORGMPlayerController () <ORGMEngineDelegate>

@property (strong, nonatomic) ORGMEngine *engine;
@property (strong, nonatomic) NSArray *playlist;
@property (nonatomic) NSInteger curIndex;

- (void)playTrackAtIndex:(NSUInteger)index;

- (void)postNowPlayingInfo;
- (void)clearNowPlayingInfo;

- (NSDictionary *)nowPlayingInfoWithImage:(UIImage *)image;
- (NSDictionary *)nowPlayingInfo;

@end

@implementation ORGMPlayerController

- (id)init {
    self = [super init];
    if (self) {
        self.engine = [[ORGMEngine alloc] init];
        _engine.delegate = self;
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
        [session setActive:YES error:&sessionError];
        
        AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
                                        audioRouteChangeListenerCallback,
                                        (__bridge void *)(self));
    }
    return self;
}

#pragma mark - Actions

- (void)playTracks:(NSArray *)tracks from:(NSUInteger)index {
    if (!tracks || tracks.count <= index) return;
    self.playlist = tracks;
    self.curIndex = index;
    
    [self playTrackAtIndex:index];
}

- (void)play {
    [self playTrackAtIndex:_curIndex];
}

- (void)prev {
    _curIndex--;
    if (_curIndex < 0) {
        _curIndex = _playlist.count - 1;
    }
    [self playTrackAtIndex:_curIndex];
}

- (void)next {
    _curIndex++;
    if (_curIndex >= _playlist.count) {
        _curIndex = 0;
    }
    [self playTrackAtIndex:_curIndex];
}

- (void)seekToTime:(double)time {
    [_engine seekToTime:time];
}

- (void)toggle {
    if (_engine.currentState == ORGMEngineStatePaused) {
        [_engine resume];
    } else if (_engine.currentState == ORGMEngineStatePlaying) {
        [_engine pause];
    }
}

- (void)stop {
    [_engine stop];
}

- (void)handleRemoteControlEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self prev];
            break;
        case UIEventSubtypeRemoteControlPlay:
            [self play];
            break;
        case UIEventSubtypeRemoteControlNextTrack:
            [self next];
            break;
        case UIEventSubtypeRemoteControlPause:
            [self toggle];
            break;
        case UIEventSubtypeRemoteControlTogglePlayPause:
            [self toggle];
            break;
        default:
            break;
    }
}

#pragma mark - Info

- (double)trackTime {
    return _engine.trackTime;
}

- (double)amountPlayed {
    return _engine.amountPlayed;
}

- (NSURL *)currentCovertArtUrl {
    return [[self currentTrack] trackCoverArtImageURL];
}

- (void)currentCovertArtImage:(void(^)(UIImage *coverArt))success {
    NSURL *imageUrl = [self currentCovertArtUrl];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageUrl];
    AFImageRequestOperation *operation =
        [AFImageRequestOperation imageRequestOperationWithRequest:imageRequest
                                                          success:success];
    [operation start];
}

- (ORGMEngineState)currentState {
    return _engine.currentState;
}

- (ORGMTrack *)currentTrack {
    return [_playlist objectAtIndex:_curIndex];
}

#pragma mark - Helpers

- (void)playTrackAtIndex:(NSUInteger)index {
    if (!_playlist || _playlist.count <= index) return;
    
    id<ORGMPlayerTrackDelegate> track = [_playlist objectAtIndex:index];
    NSURL* url = [track trackURL];
    if (_engine.currentState != ORGMEngineStatePlaying) {
        [_engine playUrl:url];
    } else {
        [_engine setNextUrl:url withDataFlush:YES];
    }
}

- (void)postNowPlayingInfo {
    [self currentCovertArtImage:^(UIImage *coverArt) {
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [self nowPlayingInfoWithImage:coverArt];
    }];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = [self nowPlayingInfo];
}

- (void)clearNowPlayingInfo {
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
}

- (NSDictionary *)nowPlayingInfoWithImage:(UIImage *)image {
    id<ORGMPlayerTrackDelegate> track = self.currentTrack;
    NSMutableDictionary *d = [NSMutableDictionary new];
    if ([track trackTitle])
        [d setObject:[track trackTitle]
              forKey:MPMediaItemPropertyTitle];
    if ([track trackAlbumTitle])
        [d setObject:[track trackAlbumTitle]
              forKey:MPMediaItemPropertyAlbumTitle];
    if ([track trackArtistTitle])
        [d setObject:[track trackArtistTitle]
              forKey:MPMediaItemPropertyArtist];
    if (image)
        [d setObject:[[MPMediaItemArtwork alloc] initWithImage:image]
              forKey:MPMediaItemPropertyArtwork];
    [d setObject:[NSNumber numberWithDouble:[self trackTime]]
          forKey:MPMediaItemPropertyPlaybackDuration];
    
    return d;
}

- (NSDictionary *)nowPlayingInfo {
    return [self nowPlayingInfoWithImage:nil];
}

#pragma mark - ORGMEngineDelegate

- (NSURL *)engineExpectsNextUrl:(ORGMEngine *)engine {
    _curIndex++;
    if (_curIndex >= _playlist.count) {
        _curIndex = 0;
    }
    
    if (!_playlist || _playlist.count <= _curIndex) return nil;
    
    id<ORGMPlayerTrackDelegate> track = [_playlist objectAtIndex:_curIndex];
    return [track trackURL];
}

- (void)engine:(ORGMEngine *)engine didChangeState:(ORGMEngineState)state {
    switch (state) {
        case ORGMEngineStateStopped: {
            [self clearNowPlayingInfo];
            if (_delegate) {
                [_delegate playerController:self stoppedTrack:[self currentTrack]];
            }
            break;
        }
        case ORGMEngineStatePlaying: {
            [self postNowPlayingInfo];
            if (_delegate) {
                [_delegate playerController:self startedTrack:[self currentTrack]];
            }
            break;
        }
        case ORGMEngineStatePaused:
            if (_delegate) {
                [_delegate playerController:self pausedTrack:[self currentTrack]];
            }
            break;
        default:
            break;
    }
}

#pragma mark - Singleton

+ (ORGMPlayerController *)defaultPlayer {
    static ORGMPlayerController *defaultPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultPlayer = [[ORGMPlayerController alloc] init];
    });
    return defaultPlayer;
}

#pragma mark - Route change callback

void audioRouteChangeListenerCallback(void                   *inUserData,
                                      AudioSessionPropertyID inPropertyID,
                                      UInt32                 inPropertyValueSize,
                                      const void             *inPropertyValue) {
    
	if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
    
    ORGMPlayerController* engine = [ORGMPlayerController defaultPlayer];
    
	if (engine.currentState != ORGMEngineStateStopped ) {
		CFDictionaryRef	routeChangeDictionary = inPropertyValue;
        
		CFNumberRef routeChangeReasonRef =
            CFDictionaryGetValue(routeChangeDictionary,
                                 CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 routeChangeReason;
		CFNumberGetValue(routeChangeReasonRef,
                         kCFNumberSInt32Type,
                         &routeChangeReason);
        
		if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable) {
			[engine.engine pause];
		}
	}
}

@end
