//
//  FilePlayerController.m
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FilePlayerController.h"
#import "OOAudioPlayer.h"
#import "NSString+URLEncode.h"

@implementation FilePlayerController

- (void)createModel {
    self.dataSource = [TTListDataSource dataSourceWithObjects:[TTTableTextItem itemWithText:_currentUrl.lastPathComponent],nil];
}

- (id)initWithUrl:(NSString*)url {
    self = [super init];
    if (self) {
        if (url != nil) {
            NSString* urlPath = [[NSString stringWithSpecialDencodeOfString:url] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"%@", urlPath);
            _currentUrl = [NSURL URLWithString:urlPath];
            self.title = _currentUrl.lastPathComponent;
            //[[OOAudioPlayer defaultPlayer] play:[NSArray arrayWithObject:<#(id)#>]];
        }
    }
    
    return self;
}

@end
