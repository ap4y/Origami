//
//  ORGMAlbum.h
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORGMEntity.h"

@interface ORGMAlbum : ORGMEntity <ORGMRemoteEntity>
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *album_artist;
@property (nonatomic, retain) NSNumber *tracks_count;
@property (nonatomic, retain) NSString *random_cover;
@end
