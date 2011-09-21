//
//  AlbumView.m
//  Sample
//
//  Created by Arthur Evstifeev on 25.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AlbumView.h"
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@implementation AlbumView
@synthesize albumName = _albumName;

- (id)initWithTitle:(NSString*)album artist:(NSString*)artist cover:(UIImage*)cover year:(NSNumber*)year {
    self = [super initWithFrame:CGRectMake(0, 0, 320, 120)];
    if (self) {
        self.backgroundColor = RGB(230, 230, 230);
        
        _albumName = album == @"Untitled" ? nil : album;
        
        UILabel* albumTitle = [[UILabel alloc] initWithFrame:CGRectMake(120, 30, 200, 20)];
        albumTitle.font = [UIFont fontWithName:@"Segoe UI" size:16];
        albumTitle.text = album;    
        albumTitle.backgroundColor = RGB(230, 230, 230);
        [self addSubview:albumTitle];

        UILabel* artistTitle = [[UILabel alloc] initWithFrame:CGRectMake(120, 50, 200, 20)];
        artistTitle.text = artist;      
        artistTitle.font = [UIFont fontWithName:@"Segoe UI" size:14];
        artistTitle.backgroundColor = RGB(230, 230, 230);
        artistTitle.textColor = RGB(110, 106, 124);
        [self addSubview:artistTitle];
        
        UILabel* yearText = [[UILabel alloc] initWithFrame:CGRectMake(120, 70, 200, 20)];
        yearText.text = year.stringValue;      
        yearText.font = [UIFont fontWithName:@"Segoe UI" size:14];
        yearText.backgroundColor = RGB(230, 230, 230);
        yearText.textColor = RGB(110, 106, 124);
        //[self addSubview:yearText];
        
        TTImageView* coverView = [[TTImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
        if (cover == nil)
            coverView.defaultImage = [UIImage imageNamed:@"disc.png"];
        else
            coverView.defaultImage = cover;
        
        coverView.backgroundColor = RGB(230, 230, 230);
        coverView.style = TTSTYLE(rounded);
        [self addSubview:coverView];
        
        [yearText release];
        [albumTitle release];
        [artistTitle release];
        [coverView release];        
    }
    return self;
}

+ (AlbumView*)viewWithTitle:(NSString*)album artist:(NSString*)artist cover:(UIImage*)cover year:(NSNumber*)year {
    return [[[AlbumView alloc] initWithTitle:album artist:artist cover:cover year:year] autorelease];
}

@end
