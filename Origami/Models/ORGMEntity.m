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

+ (id)createOrFindByTitle:(NSString *)title
         inManagedContext:(NSManagedObjectContext*)context {
    if (!title || !context) return nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", title];
    ORGMEntity *entity = [self requestFirstResult:[self where:predicate]
                             managedObjectContext:context];
    if (!entity) {
        entity = [[ORGMEntity alloc] initWithEntity:[self enityDescriptionInContext:context]
                     insertIntoManagedObjectContext:context];
        [entity setValue:title forKey:@"title"];
    }
    
    return entity;
}

@end
