//
//  PlayerControlView.h
//  Sample
//
//  Created by Arthur Evstifeev on 26.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OOAudioPlayer.h"

@interface PlayerControlView : UIToolbar {    
    UIBarButtonItem* btnPrev;
    UIBarButtonItem* btnPause;
    UIBarButtonItem* btnPlay;
    UIBarButtonItem* btnNext;
    UIBarButtonItem* btnFlex;
    UIBarButtonItem* btnAdd;
}

-(void)setStatePlay:(BOOL) play;

@end
