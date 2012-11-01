//
//  ORGMEntity.h
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORManagedObject.h"

@interface ORGMEntity : ORManagedObject
@property (nonatomic, retain) NSNumber *id;
@property (nonatomic, retain) NSDate *updated_at;

+ (id)createOrFindByTitle:(NSString *)title
         inManagedContext:(NSManagedObjectContext*)context;
@end