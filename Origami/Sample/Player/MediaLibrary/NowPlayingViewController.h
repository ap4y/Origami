//
//  NowPlayingViewController.h
//  Sample
//
//  Created by Arthur Evstifeev on 26.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@interface NowPlayingViewController : UIViewController {
    
    IBOutlet UIImageView *coverArt;
    IBOutlet UILabel *timePlayed;
    IBOutlet UILabel *timeLeft;
    IBOutlet UISlider *trackProgress;
    IBOutlet UILabel *titleStr;
    IBOutlet UILabel *artist;
    IBOutlet UILabel *year;
    IBOutlet UILabel *trackCount;
}
- (IBAction)seekToValue:(id)sender;

@end
