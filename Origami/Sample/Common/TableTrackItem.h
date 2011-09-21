//
//  TableTrackItem.h
//  Sample
//
//  Created by Arthur Evstifeev on 24.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "Track.h"

@interface TableTrackItem : TTTableImageItem{
    Track* _track;
}

@property(nonatomic, retain) Track* track;

+ (id)itemWithText:(NSString*)text imageURL:(NSString*)url track:(Track*)track delegate:(id)delegate selector:(SEL)selector;

@end
