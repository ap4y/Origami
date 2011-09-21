//
//  TableUrlItem.h
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"

@interface TableUrlItem : TTTableImageItem {
    NSURL* _url;
}

@property(nonatomic, copy) NSURL* url;

+ (id)itemWithText:(NSString*)text pathUrl:(NSURL*)url delegate:(id)delegate selector:(SEL)selector;
+ (id)itemWithText:(NSString*)text pathUrl:(NSURL*)url;

@end
