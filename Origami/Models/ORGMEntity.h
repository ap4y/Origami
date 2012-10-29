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

+ (id)createOrFindByTitle:(NSString *)title
         inManagedContext:(NSManagedObjectContext*)context;
@end