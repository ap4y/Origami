//
//  ORGMPlayerController.h
//  Origami
//
//  Created by ap4y on 10/31/12.
//
//

#import <Foundation/Foundation.h>
#import "ORGMEngine.h"

@interface ORGMPlayerController : NSObject
@property (assign, nonatomic, readonly) ORGMEngineState currentState;
@property (strong, nonatomic, readonly) NSArray *playlist;
@property (strong, nonatomic, readonly) ORGMTrack *currentTrack;

+ (ORGMPlayerController *)defaultPlayer;

- (void)playTracks:(NSArray *)tracks from:(NSUInteger)index;
- (void)prev;
- (void)next;
- (void)seekToTime:(double)time;
- (void)toggle;
- (void)stop;

- (void)handleRemoteControlEvent:(UIEvent *)event;

- (double)trackTime;
- (double)amountPlayed;
@end
