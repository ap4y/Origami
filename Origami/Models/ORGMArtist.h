//
//  ORGMArtist.h
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import "ORGMEntity.h"

@interface ORGMArtist : ORGMEntity

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *albums_count;
@property (nonatomic, retain) NSString *random_cover;

@end
