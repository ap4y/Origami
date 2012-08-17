//
//  ORGMHTTPClient.h
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "AFHTTPClient.h"

#define kTTBaseURLString @"http://loon.herokuapp.com/api/v0/"
#define kMissingImageUrl @"/cover_arts/normal/missing.png"

@interface ORGMHTTPClient : AFHTTPClient
+ (ORGMHTTPClient*)sharedClient;
@end
