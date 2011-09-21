//
//  TrackView.h
//  Sample
//
//  Created by Arthur Evstifeev on 25.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Track.h"

@interface TrackView : UIView {
    UIImageView* highlight;
    UILabel* trackNo;
    UILabel* title;
    UILabel* time;
    
    Track* _track;
}

@property(nonatomic, retain) Track* track;

- (id)initWithTrack:(Track*)track;
+ (TrackView*)viewWithTrack:(Track*)track;
- (void)highlight:(BOOL)selected;

@end
