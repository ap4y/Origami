//
//  ORGMTrackCell.m
//  Origami
//
//  Created by ap4y on 8/19/12.
//
//

#import "ORGMTrackCell.h"

@interface ORGMTrackCell ()
@property (weak, nonatomic) IBOutlet UILabel *trackNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistLabel;
@property (weak, nonatomic) IBOutlet UILabel *albumLabel;
@end

@implementation ORGMTrackCell
@synthesize trackNumberLabel;
@synthesize titleLabel;
@synthesize artistLabel;
@synthesize albumLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)setTrack:(ORGMTrack *)track {
    trackNumberLabel.text = track.track_num.stringValue;
    titleLabel.text = track.title;
    artistLabel.text = track.track_artist;
    albumLabel.text = track.track_album;
}
@end
