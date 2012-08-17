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
                      success:(void (^)(NSArray *entities))success
                       failure:(void (^)(NSError *error))failure {
    [self fetchWithClient:[ORGMHTTPClient sharedClient]
                     path:@"albums"
               parameters:@{@"from": [NSNumber numberWithInteger:offset]}
                  success:success
                  failure:failure];
}

@end
