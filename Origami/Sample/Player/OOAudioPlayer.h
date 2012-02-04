//
//  OOAudioPlayer.h
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioPlayer.h"
#import "Status.h"
#import "Track.h"

//@protocol OOAudioPlayerDelegate;

typedef enum playerStatuses {
    OOAudioPlayerStatusStopped = kCogStatusStopped,
    OOAudioPlayerStatusPaused = kCogStatusPaused,
    OOAudioPlayerStatusPlaying = kCogStatusPlaying
} OOAudioPlayerStatuses;

@interface OOAudioPlayer : NSObject {
    //id<OOAudioPlayerDelegate> _delegate;
    
    AudioPlayer* _player;
    NSArray* _tracks;
    int _currentTrack;
    
    OOAudioPlayerStatuses _status;
}

@property(nonatomic) OOAudioPlayerStatuses status;
@property(nonatomic, readwrite) int currentTrack;
@property(nonatomic, retain) NSArray* tracks;
//@property(nonatomic, retain) id<OOAudioPlayerDelegate> delegate;

- (void)next;
- (void)previous;
- (void)pause;
- (void)stop;
- (void)resume;
- (void)play:(NSArray*)tracks fromTrack:(int)firstTrack;
- (void)play:(NSArray*)tracks;
- (void)playLoadedTracks;
- (void)playLoadedTracks:(Track*)fromTrack;
- (void)seek:(double)time;
- (double)trackTime;
- (double)amountPlayed;
- (Track*)track;
- (void)remoteControlReceivedWithEvent:(UIEvent *)event;

+ (OOAudioPlayer *)defaultPlayer;
@end

/*@protocol OOAudioPlayerDelegate <NSObject>

- (void)player:(OOAudioPlayer*)player  didStartedPlay:(Track*)track;
- (void)player:(OOAudioPlayer*)player didPausedPlay:(Track*)track;

//- (void)didFinishedPlay;
//- (void)didStartedPlay;
//- (void)didPausedPlay;
//- (void)didNextPlay;
//- (void)didPreviousPlay;
//- (void)didStopedPlay;

@end
*/