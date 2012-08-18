//
//  ORGMAlbum.m
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORGMAlbum.h"

@implementation ORGMAlbum
@dynamic title;
@dynamic album_artist;
@dynamic tracks_count;
@dynamic random_cover;

#pragma mark - ORGMRemoteEntity
+ (void)fetchEntitesWithOffset:(NSInteger)offset
                       success:(void (^)(NSArray *))success
                       failure:(void (^)(NSError *))failure {
    [self fetchEntitesWithPath:@"albums"
                        offset:offset
                       success:success
                       failure:failure];
}

@end
