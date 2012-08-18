//
//  ORGMGenre.h
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import "ORGMEntity.h"

@interface ORGMGenre : ORGMEntity <ORGMRemoteEntity>
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *tracks_count;
@property (nonatomic, retain) NSString *random_cover;

@end
