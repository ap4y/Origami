//
//  ORGMAlbum.h
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORGMEntity.h"

@interface ORGMAlbum : ORGMEntity
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *album_artist;
@property (nonatomic, retain) NSNumber *tracks_count;
@property (nonatomic, retain) NSString *random_cover;

+ (void)fetchAlbumsWithOffset:(NSInteger)offset
                      success:(void (^)(NSArray *entities))success
                      failure:(void (^)(NSError *error))failure;
@end
