//
//  ORGMAlbumCell.h
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import <UIKit/UIKit.h>

#import "ORGMTrack.h"
#import "ORGMArtist.h"
#import "ORGMAlbum.h"
#import "ORGMGenre.h"

@interface ORGMAlbumCell : UITableViewCell
- (void)setEntities:(NSArray *)entities;
@end
