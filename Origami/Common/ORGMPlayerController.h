//
//  ORGMPlayerController.h
//  Origami
//
//  Created by ap4y on 10/31/12.
//
//

#import <Foundation/Foundation.h>
#import "ORGMEngine.h"

@protocol ORGMPlayerControllerDelegate;
@protocol ORGMPlayerTrackDelegate;

@interface ORGMPlayerController : NSObject

@property (assign, nonatomic, readonly) ORGMEngineState currentState;
@property (strong, nonatomic, readonly) NSArray *playlist;
@property (strong, nonatomic, readonly) id<ORGMPlayerTrackDelegate> currentTrack;
@property (weak, nonatomic) id<ORGMPlayerControllerDelegate> delegate;

- (void)playTracks:(NSArray *)tracks from:(NSUInteger)index;
- (void)play;
- (void)prev;
- (void)next;
- (void)seekToTime:(double)time;
- (void)toggle;
- (void)stop;

- (void)handleRemoteControlEvent:(UIEvent *)event;

- (double)trackTime;
- (double)amountPlayed;

- (NSURL *)currentCovertArtUrl;
- (void)currentCovertArtImage:(void(^)(UIImage *coverArt))success;

+ (ORGMPlayerController *)defaultPlayer;

@end

@protocol ORGMPlayerTrackDelegate <NSObject>
@required
- (NSURL *)trackURL;
- (NSURL *)trackCoverArtImageURL;
- (NSString *)trackTitle;
- (NSString *)trackAlbumTitle;
- (NSString *)trackArtistTitle;
@end

@protocol ORGMPlayerControllerDelegate <NSObject>
@optional
- (void)playerController:(ORGMPlayerController *)controller startedTrack:(id<ORGMPlayerTrackDelegate>)track;
- (void)playerController:(ORGMPlayerController *)controller stoppedTrack:(id<ORGMPlayerTrackDelegate>)track;
- (void)playerController:(ORGMPlayerController *)controller pausedTrack:(id<ORGMPlayerTrackDelegate>)track;
@end
