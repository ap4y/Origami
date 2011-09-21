//
//  AlbumView.h
//  Sample
//
//  Created by Arthur Evstifeev on 25.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"

@interface AlbumView : UIView {
    NSString* _albumName;
}

@property(nonatomic, retain)NSString* albumName;

- (id)initWithTitle:(NSString*)album artist:(NSString*)artist cover:(UIImage*)cover year:(NSNumber*)year;
+ (AlbumView*)viewWithTitle:(NSString*)album artist:(NSString*)artist cover:(UIImage*)cover year:(NSNumber*)yearr;

@end
