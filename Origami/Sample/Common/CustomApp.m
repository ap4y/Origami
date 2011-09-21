//
//  CustomWindow.m
//  Sample
//
//  Created by Arthur Evstifeev on 27.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomApp.h"
#import "OOAudioPlayer.h"

@implementation CustomApp

-(void)sendEvent:(UIEvent *)event {
    [super sendEvent:event];
    if (event.type == UIEventTypeRemoteControl) {
        [[OOAudioPlayer defaultPlayer] remoteControlReceivedWithEvent:event];
    }
    
}

@end
