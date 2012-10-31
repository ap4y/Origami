//
//  ORGMPlayerController.h
//  Origami
//
//  Created by ap4y on 10/31/12.
//
//

#import <Foundation/Foundation.h>

@interface ORGMPlayerController : NSObject
+ (ORGMPlayerController *)defaultPlayer;

- (void)playTracks:(NSArray *)tracks from:(NSUInteger)index;
- (void)playTracks:(NSArray *)tracks;
@end
