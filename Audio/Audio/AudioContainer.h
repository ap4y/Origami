//
//  AudioContainer.h
//  CogAudio
//
//  Created by Zaphod Beeblebrox on 10/8/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "Plugin.h"

@interface AudioContainer : NSObject {

}

+ (NSArray *) urlsForContainerURL:(NSURL *)url;

@end
