//
//  ORGMAlbumCell.m
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORGMEntityWithCoverCell.h"

#import "ORGMLastfmProxyClient.h"
#import "ORGMCustomization.h"

typedef enum : NSInteger {
    ORGMEntityCellViewPositionLeft,
    ORGMEntityCellViewPositionRight
} ORGMEntityCellViewPosition;

@interface ORGMEntityWithCoverCell ()
@property (weak, nonatomic) IBOutlet UIView *leftAlbumView;
@property (weak, nonatomic) IBOutlet UIView *rigthAlbumView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDetailsLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDetailsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftLastfmLogo;
@property (weak, nonatomic) IBOutlet UIImageView *rightLastfmLogo;
@property (strong, nonatomic) ORGMEntity *leftEntity;
@property (strong, nonatomic) ORGMEntity *rightEntity;
@end

@implementation ORGMEntityWithCoverCell
@synthesize leftAlbumView;
@synthesize rigthAlbumView;
@synthesize leftImageView;
@synthesize rightImageView;
@synthesize leftTitleLabel;
@synthesize rightTitleLabel;
@synthesize leftDetailsLabel;
@synthesize rightDetailsLabel;
@synthesize leftLastfmLogo;
@synthesize rightLastfmLogo;

- (void)awakeFromNib {
    UITapGestureRecognizer *leftViewTapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(leftViewTapped:)];
    UITapGestureRecognizer *rightViewTapRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(rightViewTapped:)];

    [leftAlbumView addGestureRecognizer:leftViewTapRecognizer];
    [rigthAlbumView addGestureRecognizer:rightViewTapRecognizer];
}

#pragma mark - public
- (void)setEntities:(NSArray *)entities {
    [leftAlbumView setHidden:YES];
    [rigthAlbumView setHidden:YES];
    
    if (entities.count > 0) {
        if ([[entities objectAtIndex:0] isKindOfClass:[ORGMEntity class]]) {
            self.leftEntity = [entities objectAtIndex:0];
            [leftAlbumView setHidden:NO];
            [leftLastfmLogo setHidden:YES];
            [self refreshCellAtPosition:ORGMEntityCellViewPositionLeft
                             withEntity:_leftEntity];
        }
    }
    
    if (entities.count > 1) {
        if ([[entities objectAtIndex:1] isKindOfClass:[ORGMEntity class]]) {
            self.rightEntity = [entities objectAtIndex:1];
            [rigthAlbumView setHidden:NO];
            [rightLastfmLogo setHidden:YES];
            [self refreshCellAtPosition:ORGMEntityCellViewPositionRight
                             withEntity:_rightEntity];
        }
    }
}

#pragma mark - private
- (void)leftViewTapped:(id)sender {
    if (_delegate) {
        [_delegate coverCell:self didTapViewWithEntity:_leftEntity];
    }
}

- (void)rightViewTapped:(id)sender {
    if (_delegate) {
        [_delegate coverCell:self didTapViewWithEntity:_rightEntity];
    }
}

+ (NSString *)pluralizedString:(NSString *)string forAmount:(int)amount {
    return [NSString stringWithFormat:@"%@%@", string, amount != 1 ? @"s" : @""];
}

- (void)refreshCellAtPosition:(ORGMEntityCellViewPosition)position
                   withEntity:(ORGMEntity *)entity {
    
    if ([entity isKindOfClass:[ORGMAlbum class]]) {
        [self fillViewAtPosition:position withAlbum:(ORGMAlbum *)entity];
    } else if ([entity isKindOfClass:[ORGMArtist class]]) {
        [self fillViewAtPosition:position withArtist:(ORGMArtist *)entity];
    } else if ([entity isKindOfClass:[ORGMGenre class]]) {
        [self fillViewAtPosition:position withGenre:(ORGMGenre *)entity];
    }
}

- (void)fillViewAtPosition:(ORGMEntityCellViewPosition)position
                 withAlbum:(ORGMAlbum *)album {
    switch (position) {
        case ORGMEntityCellViewPositionLeft: {
            leftTitleLabel.text = album.title;
            leftDetailsLabel.text = album.artist.title;
            break;
        }
        case ORGMEntityCellViewPositionRight: {
            rightTitleLabel.text = album.title;
            rightDetailsLabel.text = album.artist.title;
            break;
        }
    }
    
    NSURL *imageUrl =
        [[ORGMLastfmProxyClient sharedClient] albumImageUrlForArtist:album.artist.title
                                                          albumTitle:album.title];
    [self setImageAtPosition:position
              withPrimaryUrl:nil
                andLastfmUrl:imageUrl];
}

- (void)fillViewAtPosition:(ORGMEntityCellViewPosition)position
                withArtist:(ORGMArtist *)artist {
    switch (position) {
        case ORGMEntityCellViewPositionLeft: {
            leftTitleLabel.text = artist.title;
            NSUInteger amount = [artist.albums count];
            leftDetailsLabel.text = [NSString stringWithFormat:@"%i %@", amount,
                                     [ORGMEntityWithCoverCell pluralizedString:@"album"
                                                           forAmount:amount]];
            break;
        }
        case ORGMEntityCellViewPositionRight: {
            rightTitleLabel.text = artist.title;
            NSUInteger amount = [artist.albums count];
            rightDetailsLabel.text = [NSString stringWithFormat:@"%i %@", amount,
                                      [ORGMEntityWithCoverCell pluralizedString:@"album"
                                                            forAmount:amount]];
            break;
        }
    }
    
    NSURL *imageUrl =
        [[ORGMLastfmProxyClient sharedClient] artistImageUrlForArtist:artist.title];
    [self setImageAtPosition:position
              withPrimaryUrl:nil
                andLastfmUrl:imageUrl];
}

- (void)fillViewAtPosition:(ORGMEntityCellViewPosition)position
                 withGenre:(ORGMGenre *)genre {
    switch (position) {
        case ORGMEntityCellViewPositionLeft: {
            leftTitleLabel.text = genre.title;
            NSUInteger amount = [genre.tracks count];
            leftDetailsLabel.text = [NSString stringWithFormat:@"%i %@", amount,
                                     [ORGMEntityWithCoverCell pluralizedString:@"track"
                                                           forAmount:amount]];
            break;
        }
        case ORGMEntityCellViewPositionRight: {
            rightTitleLabel.text = genre.title;
            NSUInteger amount = [genre.tracks count];
            rightDetailsLabel.text = [NSString stringWithFormat:@"%i %@", amount,
                                      [ORGMEntityWithCoverCell pluralizedString:@"track"
                                                            forAmount:amount]];
            break;
        }
    }
    
    NSURL *imageUrl =
        [[ORGMLastfmProxyClient sharedClient] genreImageUrlForGenre:genre.title];
    [self setImageAtPosition:position
              withPrimaryUrl:nil
                andLastfmUrl:imageUrl];
}

- (void)setImageAtPosition:(ORGMEntityCellViewPosition)position
            withPrimaryUrl:(NSURL *)url
              andLastfmUrl:(NSURL *)lastfmUrl {
    
    UIImageView *imageView;
    UIImageView *lastfmBadge;
    switch (position) {
        case ORGMEntityCellViewPositionLeft: {
            imageView = leftImageView;
            lastfmBadge = leftLastfmLogo;
            break;
        }
        case ORGMEntityCellViewPositionRight: {
            imageView = rightImageView;
            lastfmBadge = rightLastfmLogo;
            break;
        }
    }
    
    UIColor *random = [ORGMCustomization colorForColoredEntityType:arc4random()%4];
    [imageView setBackgroundColor:random];
    
    if (url) {
        [imageView setImageWithURL:url];
    } else {
        [imageView setImageWithURLRequest:[NSURLRequest requestWithURL:lastfmUrl]
                         placeholderImage:nil
                                  success:^(NSURLRequest *request,
                                            NSHTTPURLResponse *response,
                                            UIImage *image) {
                                      [lastfmBadge setHidden:NO];
                                  } failure:nil];
    }
}
@end
