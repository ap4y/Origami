//
//  ORGMGenre.h
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import "ORGMEntity.h"

@interface ORGMGenre : ORGMEntity
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *tracks_count;
@property (nonatomic, retain) NSString *random_cover;

+ (void)fetchGenresWithOffset:(NSInteger)offset
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSError *))failure;

- (NSURL *)getCoverArtUrl;
@end
