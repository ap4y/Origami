//
//  ORGMArtist.h
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

#import "ORGMEntity.h"

@class ORGMAlbum;
@interface ORGMArtist : ORGMEntity
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSSet *albums;
@end

@interface ORGMArtist (CoreDataGeneratedAccessors)
- (void)addAlbumsObject:(ORGMAlbum *)value;
- (void)removeAlbumsObject:(ORGMAlbum *)value;
- (void)addAlbums:(NSSet *)values;
- (void)removeAlbums:(NSSet *)values;
@end
