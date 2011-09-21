//
//  FilePlayerController.h
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@interface FilePlayerController : TTTableViewController {
    NSURL* _currentUrl;
}

- (id)initWithUrl:(NSString*)url;

@end
