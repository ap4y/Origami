//
//  ORGMTrack.h
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import "ORGMEntity.h"

@interface ORGMTrack : ORGMEntity
@property (nonatomic, retain) NSNumber *track_num;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *track_album;
@property (nonatomic, retain) NSString *track_artist;
@property (nonatomic, retain) NSString *track_genre;

+ (void)fetchTracksWithOffset:(NSInteger)offset
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSError *))failure;
@end
