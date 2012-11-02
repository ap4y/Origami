//
//  ORGMMenuDataSource.m
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import "ORGMMenuDataSource.h"
#import "ORGMCustomization.h"
#import "ORGMLastfmProxyClient.h"

@interface ORGMMenuDataSource ()
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) UIImage *placeholder;
@end

@implementation ORGMMenuDataSource

- (id)init {
    self = [super init];
    if (self) {
        [self reloadData];
        self.placeholder = [UIImage imageNamed:@"empty_placeholder"];
    }
    return self;
}

- (void)reloadData {
    self.items = @[ [ORGMTrack topTracks],
                    [ORGMArtist topArtists],
                    [ORGMAlbum topAlbums],
                    [ORGMGenre topGenres],
                    @[ @"iTunes" ] ];
}

- (void)toggleImportIndicatorForTableView:(UITableView *)tableView {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:4];
    UITableViewCell *itunesImportCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!itunesImportCell) return;
    
    UIActivityIndicatorView *importIndicator =
        (UIActivityIndicatorView *)[itunesImportCell.contentView viewWithTag:1];
    if (importIndicator.isAnimating) {
        [importIndicator stopAnimating];
    } else {
        [importIndicator startAnimating];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subItems = [_items objectAtIndex:section];
    return [subItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
    UIView *backView = [[UIView alloc] initWithFrame:cell.bounds];
    [backView setBackgroundColor:RGB(238, 238, 238)];
    [cell setBackgroundView:backView];
    
    UIColor *random = [ORGMCustomization colorForColoredEntityType:arc4random()%4];
    [cell.imageView setBackgroundColor:random];
    
    ORGMLastfmProxyClient *imageProxy = [ORGMLastfmProxyClient sharedClient];
    
    NSArray *subItems = [_items objectAtIndex:indexPath.section];
    switch (indexPath.section) {
        case 0: {
            ORGMTrack *track = [subItems objectAtIndex:indexPath.row];
            cell.textLabel.text = track.title;
            cell.detailTextLabel.text = track.album.title;
            
            NSURL *imageUrl = [imageProxy albumImageUrlForArtist:track.album.artist.title
                                                      albumTitle:track.album.title];
            [cell.imageView setImageWithURL:imageUrl placeholderImage:_placeholder];

            break;
        }
        case 1: {
            ORGMArtist *artist = [subItems objectAtIndex:indexPath.row];
            cell.textLabel.text = artist.title;
            cell.detailTextLabel.text = nil;
            
            NSURL *imageUrl = [imageProxy artistImageUrlForArtist:artist.title];
            [cell.imageView setImageWithURL:imageUrl placeholderImage:_placeholder];
            break;
        }
        case 2: {
            ORGMAlbum *album = [subItems objectAtIndex:indexPath.row];
            cell.textLabel.text = album.title;
            cell.detailTextLabel.text = album.artist.title;
            
            NSURL *imageUrl = [imageProxy albumImageUrlForArtist:album.artist.title
                                                      albumTitle:album.title];
            [cell.imageView setImageWithURL:imageUrl placeholderImage:_placeholder];
            break;
        }
        case 3: {
            ORGMGenre *genre = [subItems objectAtIndex:indexPath.row];
            cell.textLabel.text = genre.title;
            cell.detailTextLabel.text = nil;
            
            NSURL *imageUrl = [imageProxy genreImageUrlForGenre:genre.title];
            [cell.imageView setImageWithURL:imageUrl placeholderImage:_placeholder];
            break;
        }
        case 4: {
            NSString *source = [subItems objectAtIndex:indexPath.row];
            cell.textLabel.text = source;
            cell.detailTextLabel.text = nil;
            cell.imageView.backgroundColor = [UIColor clearColor];
            [cell.imageView setImage:[UIImage imageNamed:@"ic_itunes"]];
            
            UIActivityIndicatorView *importIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [importIndicator setTag:1];
            [importIndicator setHidesWhenStopped:YES];
            CGRect frame = importIndicator.frame;
            frame.origin = CGPointMake(180.0, 10.0);
            importIndicator.frame = frame;
            [cell.contentView addSubview:importIndicator];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headerCell"];
        
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
    UIView *stripeView = [cell viewWithTag:2];
    UIButton *tapButton = (UIButton *)[cell viewWithTag:3];
    
    UIImage *backImage =
        [[UIImage imageNamed:@"nav_back"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [cell setBackgroundView:[[UIImageView alloc] initWithImage:backImage]];

    
    switch (section) {
        case 0: {
            titleLabel.text = NSLocalizedString(@"Tracks", nil);
            stripeView.backgroundColor = RGB(0, 204, 238);
            tapButton.titleLabel.tag = 0;
            break;
        }
        case 1: {
            titleLabel.text = NSLocalizedString(@"Artists", nil);
            stripeView.backgroundColor = RGB(204, 0, 238);
            tapButton.titleLabel.tag = 1;
            break;
        }
        case 2: {
            titleLabel.text = NSLocalizedString(@"Albums", nil);
            stripeView.backgroundColor = RGB(238, 0, 204);
            tapButton.titleLabel.tag = 2;
            break;
        }
        case 3: {
            titleLabel.text = NSLocalizedString(@"Genres", nil);
            stripeView.backgroundColor = RGB(238, 204, 0);
            tapButton.titleLabel.tag = 3;
            break;
        }
        case 4: {
            titleLabel.text = NSLocalizedString(@"Sources", nil);
            stripeView.backgroundColor = RGB(204, 238, 0);
            tapButton.titleLabel.tag = 4;
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
        }
        default:
            break;
    }
    
    return cell;
}

@end
