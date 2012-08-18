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

+ (void)fetchGenresWithOffset:(NSInteger)offset
                      success:(void (^)(NSArray *))success
                      failure:(void (^)(NSError *))failure {
    [self fetchEntitiesWithPath:@"genres"
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
