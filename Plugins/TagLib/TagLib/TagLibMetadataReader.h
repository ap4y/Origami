//
//  TagLibMetadataReader.h
//  TagLib
//
//  Created by Vincent Spader on 2/24/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Plugin.h"
#import <UIKit/UIKit.h>

@interface TagLibMetadataReader : NSObject <CogMetadataReader>
{

}

+ (BOOL)isCoverFile:(NSString *)fileName;
+ (NSArray *)coverNames;

@end
