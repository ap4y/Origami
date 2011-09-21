//
//  MediaLibrary.m
//  Sample
//
//  Created by Arthur Evstifeev on 27.08.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MediaLibrary.h"
#import "Track.h"


@implementation MediaLibrary
@synthesize delegate = _delegate;
@dynamic id;
@dynamic tracks;

- (void)dealloc {
    
    [super dealloc];
}

@end
