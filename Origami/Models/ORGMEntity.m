//
//  ORGMEntity.m
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORGMEntity.h"

@implementation ORGMEntity
@dynamic id;

+ (NSString *)jsonRoot {
    return nil;
}

+ (void)fetchEntitesWithPath:(NSString*)path
                      offset:(NSInteger)offset
                      success:(void (^)(NSArray *entities))success
                      failure:(void (^)(NSError *error))failure {
    [self fetchWithClient:[ORGMHTTPClient sharedClient]
                     path:path
               parameters:@{@"from": [NSNumber numberWithInteger:offset]}
                  success:success
                  failure:failure];
}

@end
