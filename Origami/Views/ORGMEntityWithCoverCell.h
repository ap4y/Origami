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

@protocol ORGMEntityWithCoverCellDelegate;
@interface ORGMEntityWithCoverCell : UITableViewCell
@property (weak, nonatomic) id<ORGMEntityWithCoverCellDelegate> delegate;

- (void)setEntities:(NSArray *)entities;
@end

@protocol ORGMEntityWithCoverCellDelegate <NSObject>
- (void)coverCell:(ORGMEntityWithCoverCell *)coverCell didTapViewWithEntity:(ORGMEntity *)entity;
@end
