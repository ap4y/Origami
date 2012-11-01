//
//  ORGMAlbum.h
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

#import "ORGMEntity.h"

@class ORGMArtist, ORGMTrack;
@interface ORGMAlbum : ORGMEntity
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSSet *tracks;
@property (strong, nonatomic) ORGMArtist *artist;

+ (NSArray *)libraryAlbums;
+ (NSArray *)topAlbums;
@end

@interface ORGMAlbum (CoreDataGeneratedAccessors)
- (void)addTracksObject:(ORGMTrack *)value;
- (void)removeTracksObject:(ORGMTrack *)value;
- (void)addTracks:(NSSet *)values;
- (void)removeTracks:(NSSet *)values;
@end
