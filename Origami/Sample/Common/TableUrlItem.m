//
//  TableUrlItem.m
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TableUrlItem.h"

@implementation TableUrlItem
@synthesize url = _url;

- (void)dealloc {
    TT_RELEASE_SAFELY(_url);
    
    [super dealloc];
}

+ (id)itemWithText:(NSString*)text pathUrl:(NSURL*)url delegate:(id)delegate selector:(SEL)selector {
    TableUrlItem* item = [[[self alloc] init] autorelease];
    item.text = text;
    item.delegate = delegate;
    item.selector = selector;
    item.url = url;
    return item;
}

+ (id)itemWithText:(NSString*)text pathUrl:(NSURL*)url {
    TableUrlItem* item = [[[self alloc] init] autorelease];
    item.text = text;
    item.url = url;
    return item;
}

@end
