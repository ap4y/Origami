//
//  ORGMArtist.m
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import "ORGMArtist.h"

@implementation ORGMArtist
@dynamic title;
@dynamic albums_count;
@dynamic random_cover;

#pragma mark - ORGMRemoteEntity
+ (void)fetchEntitesWithOffset:(NSInteger)offset
                       success:(void (^)(NSArray *))success
                       failure:(void (^)(NSError *))failure {
    [self fetchEntitesWithPath:@"artists"
                        offset:offset
                       success:success
                       failure:failure];
}

@end
