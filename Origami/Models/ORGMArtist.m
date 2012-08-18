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

+ (void)fetchArtistsWithOffset:(NSInteger)offset
                       success:(void (^)(NSArray *))success
                       failure:(void (^)(NSError *))failure {
    [self fetchEntitiesWithPath:@"artists"
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
