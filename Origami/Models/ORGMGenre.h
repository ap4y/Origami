//
//  ORGMGenre.h
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

#import "ORGMEntity.h"

@class ORGMTrack;
@interface ORGMGenre : ORGMEntity
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSSet *tracks;

+ (NSArray *)libraryGenres;
@end

@interface ORGMGenre (CoreDataGeneratedAccessors)
- (void)addTracksObject:(ORGMTrack *)value;
- (void)removeTracksObject:(ORGMTrack *)value;
- (void)addTracks:(NSSet *)values;
- (void)removeTracks:(NSSet *)values;
@end
