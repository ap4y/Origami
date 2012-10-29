//
//  ORGMTrack.h
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

#import "ORGMEntity.h"

@class ORGMAlbum, ORGMGenre;
@interface ORGMTrack : ORGMEntity
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSNumber *track_num;
@property (strong, nonatomic) NSString *track_path;
@property (strong, nonatomic) ORGMAlbum *album;
@property (strong, nonatomic) ORGMGenre *genre;
@end
