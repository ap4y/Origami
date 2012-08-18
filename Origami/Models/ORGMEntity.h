//
//  ORGMEntity.h
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORManagedObject.h"

#import "ORGMHTTPClient.h"

@interface ORGMEntity : ORManagedObject
@property (nonatomic, retain) NSNumber *id;

+ (void)fetchEntitiesWithPath:(NSString*)path
                       offset:(NSInteger)offset
                      success:(void (^)(NSArray *entities))success
                      failure:(void (^)(NSError *error))failure;
@end