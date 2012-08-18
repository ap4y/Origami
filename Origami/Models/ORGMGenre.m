//
//  ORGMGenre.m
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import "ORGMGenre.h"

@implementation ORGMGenre
@dynamic title;
@dynamic tracks_count;
@dynamic random_cover;

#pragma mark - ORGMRemoteEntity
+ (void)fetchEntitesWithOffset:(NSInteger)offset
                       success:(void (^)(NSArray *))success
                       failure:(void (^)(NSError *))failure {
    [self fetchEntitesWithPath:@"genres"
                        offset:offset
                       success:success
                       failure:failure];
}

@end
