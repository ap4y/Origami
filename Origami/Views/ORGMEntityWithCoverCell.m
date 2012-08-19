//
//  ORGMAlbumCell.m
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORGMEntityWithCoverCell.h"

#import "UIImageView+AFNetworking.h"
#import "ORGMLastfmProxyClient.h"

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

#pragma mark - public
- (void)setEntities:(NSArray *)entities {
    [leftAlbumView setHidden:YES];
    [rigthAlbumView setHidden:YES];
    
    if (entities.count > 0) {
        if ([[entities objectAtIndex:0] isKindOfClass:[ORGMEntity class]]) {
            [leftAlbumView setHidden:NO];
            [leftLastfmLogo setHidden:YES];
            [self refreshCellAtPosition:ORGMEntityCellViewPositionLeft
                             withEntity:[entities objectAtIndex:0]];
        }
    }
    
    if (entities.count > 1) {
        if ([[entities objectAtIndex:1] isKindOfClass:[ORGMEntity class]]) {
            [rigthAlbumView setHidden:NO];
            [rightLastfmLogo setHidden:YES];
            [self refreshCellAtPosition:ORGMEntityCellViewPositionRight
                             withEntity:[entities objectAtIndex:1]];
        }
    }
}

#pragma mark - private
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
            leftDetailsLabel.text = album.album_artist;
            break;
        }
        case ORGMEntityCellViewPositionRight: {
            rightTitleLabel.text = album.title;
            rightDetailsLabel.text = album.album_artist;
            break;
        }
    }
    
    NSURL *imageUrl =
        [[ORGMLastfmProxyClient sharedClient] albumImageUrlForArtist:album.album_artist
                                                          albumTitle:album.title];
    [self setImageAtPosition:position
              withPrimaryUrl:[album getCoverArtUrl]
                andLastfmUrl:imageUrl];
}

- (void)fillViewAtPosition:(ORGMEntityCellViewPosition)position
                withArtist:(ORGMArtist *)artist {
    switch (position) {
        case ORGMEntityCellViewPositionLeft: {
            leftTitleLabel.text = artist.title;
            NSNumber* amount = artist.albums_count;
            leftDetailsLabel.text = [NSString stringWithFormat:@"%@ %@", amount,
                                     [ORGMEntityWithCoverCell pluralizedString:@"album"
                                                           forAmount:amount.intValue]];
            break;
        }
        case ORGMEntityCellViewPositionRight: {
            rightTitleLabel.text = artist.title;
            NSNumber* amount = artist.albums_count;            
            rightDetailsLabel.text = [NSString stringWithFormat:@"%@ %@", amount,
                                      [ORGMEntityWithCoverCell pluralizedString:@"album"
                                                            forAmount:amount.intValue]];
            break;
        }
    }
    
    NSURL *imageUrl =
        [[ORGMLastfmProxyClient sharedClient] artistImageUrlForArtist:artist.title];
    [self setImageAtPosition:position
              withPrimaryUrl:[artist getCoverArtUrl]
                andLastfmUrl:imageUrl];
}

- (void)fillViewAtPosition:(ORGMEntityCellViewPosition)position
                 withGenre:(ORGMGenre *)genre {
    switch (position) {
        case ORGMEntityCellViewPositionLeft: {
            leftTitleLabel.text = genre.title;
            NSNumber* amount = genre.tracks_count;
            leftDetailsLabel.text = [NSString stringWithFormat:@"%@ %@", amount,
                                     [ORGMEntityWithCoverCell pluralizedString:@"track"
                                                           forAmount:amount.intValue]];
            break;
        }
        case ORGMEntityCellViewPositionRight: {
            rightTitleLabel.text = genre.title;
            NSNumber* amount = genre.tracks_count;
            rightDetailsLabel.text = [NSString stringWithFormat:@"%@ %@", amount,
                                      [ORGMEntityWithCoverCell pluralizedString:@"track"
                                                            forAmount:amount.intValue]];
            break;
        }
    }
    
    NSURL *imageUrl =
        [[ORGMLastfmProxyClient sharedClient] genreImageUrlForGenre:genre.title];
    [self setImageAtPosition:position
              withPrimaryUrl:[genre getCoverArtUrl]
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
