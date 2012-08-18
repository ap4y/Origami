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

+ (void)fetchAlbumsWithOffset:(NSInteger)offset
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSError *))failure {
    [self fetchEntitiesWithPath:@"albums"
                         offset:offset
                        success:success
                        failure:failure];
}

- (NSURL *)getCoverArtUrl {
    if ([self.random_cover isEqualToString:kMissingImageUrl]) {
        return nil;
    }
    return [NSURL URLWithString:self.random_cover];
}

@end
