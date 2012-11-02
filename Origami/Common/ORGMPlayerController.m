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
#import "ORGMLastfmProxyClient.h"

@interface ORGMPlayerController () <ORGMEngineDelegate>
@property (strong, nonatomic) ORGMEngine *engine;
@property (strong, nonatomic) NSArray *playlist;
@property (nonatomic) NSInteger curTrack;
@end

@implementation ORGMPlayerController

+ (ORGMPlayerController *)defaultPlayer {
    static ORGMPlayerController *defaultPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultPlayer = [[ORGMPlayerController alloc] init];
    });
    return defaultPlayer;
}

- (id)init {
    self = [super init];
    if (self) {
        self.engine = [[ORGMEngine alloc] init];
        _engine.delegate = self;
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
        [session setActive:YES error:&sessionError];
//        [session setDelegate:self];
        
        AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
                                        audioRouteChangeListenerCallback,
                                        (__bridge void *)(self));
    }
    return self;
}

- (void)playTracks:(NSArray *)tracks from:(NSUInteger)index {
    if (!tracks || tracks.count <= index) return;
    self.playlist = tracks;
    
    [self playTrackAtIndex:index];
}

- (void)prev {
    _curTrack--;
    if (_curTrack < 0) {
        _curTrack = _playlist.count - 1;
    }
    [self playTrackAtIndex:_curTrack];
}

- (void)next {
    _curTrack++;
    if (_curTrack >= _playlist.count) {
        _curTrack = 0;
    }
    [self playTrackAtIndex:_curTrack];
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
            [self playTrackAtIndex:0];
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

- (double)trackTime {
    return _engine.trackTime;
}

- (double)amountPlayed {
    return _engine.amountPlayed;
}

- (void)currentCovertArtImage:(void(^)(UIImage *coverArt))success {
    ORGMTrack *track = [self currentTrack];
    ORGMLastfmProxyClient *client = [ORGMLastfmProxyClient sharedClient];
    NSURL *imageUrl = [client albumImageUrlForArtist:track.album.artist.title
                                          albumTitle:track.album.title];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageUrl];
    AFImageRequestOperation *operation =
        [AFImageRequestOperation imageRequestOperationWithRequest:imageRequest
                                                          success:success];
    [operation start];
}

#pragma mark - private
- (void)playTrackAtIndex:(NSUInteger)index {
    if (!_playlist || _playlist.count <= index) return;
    
    ORGMTrack *track = [_playlist objectAtIndex:index];
    NSURL* url = [NSURL URLWithString:track.track_path];
    if (_engine.currentState != ORGMEngineStatePlaying) {
        [_engine playUrl:url];
    } else {
        [_engine setNextUrl:url withDataFlush:YES];
    }
}

- (ORGMEngineState)currentState {
    return _engine.currentState;
}

- (ORGMTrack *)currentTrack {
    return [_playlist objectAtIndex:_curTrack];
}

- (void)postNowPlayingInfo {
    ORGMTrack *track = self.currentTrack;
    
    [self currentCovertArtImage:^(UIImage *coverArt) {
        MPMediaItemArtwork* albumArt = [[MPMediaItemArtwork alloc] initWithImage:coverArt];
        
        NSDictionary *currentlyPlayingTrackInfo = @{
            MPMediaItemPropertyTitle: track.title,
            MPMediaItemPropertyAlbumTitle: track.album.title,
            MPMediaItemPropertyArtist: track.album.artist.title,
            MPMediaItemPropertyPlaybackDuration: @([self trackTime]),
            MPMediaItemPropertyArtwork: albumArt
        };
        
        [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = currentlyPlayingTrackInfo;
    }];
    
    NSDictionary *currentlyPlayingTrackInfo = @{
        MPMediaItemPropertyTitle: track.title,
        MPMediaItemPropertyAlbumTitle: track.album.title,
        MPMediaItemPropertyArtist: track.album.artist.title,
        MPMediaItemPropertyPlaybackDuration: @([self trackTime])
    };    
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = currentlyPlayingTrackInfo;
}

- (void)clearNowPlayingInfo {
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nil;
}

#pragma mark - ORGMEngineDelegate
- (NSURL *)engineExpectsNextUrl:(ORGMEngine *)engine {
    _curTrack++;
    if (_curTrack >= _playlist.count) {
        _curTrack = 0;
    }
    
    if (!_playlist || _playlist.count <= _curTrack) return nil;
    
    ORGMTrack *track = [_playlist objectAtIndex:_curTrack];
    NSURL* url = [NSURL URLWithString:track.track_path];
    return url;
}

- (void)engine:(ORGMEngine *)engine didChangeState:(ORGMEngineState)state {
    switch (state) {
        case ORGMEngineStateStopped: {
            [self clearNowPlayingInfo];
            break;
        }
        case ORGMEngineStatePlaying: {
            [self postNowPlayingInfo];
            break;
        }
        default:
            break;
    }
}

#pragma mark - route change callback
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
