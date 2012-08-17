//
//  ORGMAlbumCell.m
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORGMAlbumCell.h"

#import "ORGMAlbum.h"
#import "UIImageView+AFNetworking.h"

@interface ORGMAlbumCell ()
@property (weak, nonatomic) IBOutlet UIView *leftAlbumView;
@property (weak, nonatomic) IBOutlet UIView *rigthAlbumView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDetailsLabel;

@end

@implementation ORGMAlbumCell
@synthesize leftAlbumView;
@synthesize rigthAlbumView;
@synthesize leftImageView;
@synthesize rightImageView;
@synthesize leftTitleLabel;
@synthesize rightTitleLabel;
@synthesize leftDetailsLabel;
@synthesize rightDetailsLabel;

- (void)setAlbums:(NSArray *)albums {
    [leftAlbumView setHidden:YES];
    [rigthAlbumView setHidden:YES];
    
    if (albums.count > 0) {
        if ([[albums objectAtIndex:0] isKindOfClass:[ORGMAlbum class]]) {
            [leftAlbumView setHidden:NO];
            ORGMAlbum *firstAlbum = [albums objectAtIndex:0];
            leftTitleLabel.text = firstAlbum.title;
            leftDetailsLabel.text = firstAlbum.album_artist;
            if (![firstAlbum.random_cover isEqualToString:kMissingImageUrl]) {
                [leftImageView setImageWithURL:[NSURL URLWithString:firstAlbum.random_cover]];
            } else {
                [leftImageView setImage:nil];
            }
        }
    }
    
    if (albums.count > 1) {
        if ([[albums objectAtIndex:1] isKindOfClass:[ORGMAlbum class]]) {
            [rigthAlbumView setHidden:NO];
            ORGMAlbum *secondAlbum = [albums objectAtIndex:1];
            rightTitleLabel.text = secondAlbum.title;
            rightDetailsLabel.text = secondAlbum.album_artist;
            if (![secondAlbum.random_cover isEqualToString:kMissingImageUrl]) {
                [rightImageView setImageWithURL:[NSURL URLWithString:secondAlbum.random_cover]];
            } else {
                [rightImageView setImage:nil];
            }
        }
    }
}

@end
