//
//  TableTrackItem.m
//  Sample
//
//  Created by Arthur Evstifeev on 24.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableTrackItem.h"

@implementation TableTrackItem
@synthesize track = _track;

- (void)dealloc {
    TT_RELEASE_SAFELY(_track);
    
    [super dealloc];
}

+ (id)itemWithText:(NSString*)text imageURL:(NSString*)url track:(Track*)track delegate:(id)delegate selector:(SEL)selector {
    TableTrackItem* item = [[[self alloc] init] autorelease];
    item.text = text;
    item.imageURL = url;
    item.delegate = delegate;
    item.selector = selector;
    item.track = track;
    return item;
}
@end
