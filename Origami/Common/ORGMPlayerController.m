//
//  ORGMPlayerController.m
//  Origami
//
//  Created by ap4y on 10/31/12.
//
//

#import "ORGMPlayerController.h"

#import <AVFoundation/AVFoundation.h>
#import "ORGMEngine.h"

@interface ORGMPlayerController () <ORGMEngineDelegate>
@property (strong, nonatomic) ORGMEngine *engine;
@property (strong, nonatomic) NSArray *playlist;
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
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError = nil;
        [session setCategory:AVAudioSessionCategoryPlayback error:&sessionError];
        [session setActive:YES error:&sessionError];
//        [session setDelegate:self];
    }
    return self;
}

- (void)playTracks:(NSArray *)tracks from:(NSUInteger)index {
    if (!tracks || tracks.count <= index) return;
    self.playlist = tracks;
    ORGMTrack *track = [tracks objectAtIndex:index];
    [_engine playUrl:[NSURL URLWithString:track.track_path]];
}

- (void)playTracks:(NSArray *)tracks {
    [self playTracks:tracks from:0];
}

#pragma mark - ORGMEngineDelegate
- (NSURL *)engineExpectsNextUrl:(ORGMEngine *)engine {
    return nil;
}

@end
