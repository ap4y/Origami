//
//  ORGMHTTPClient.h
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "AFHTTPClient.h"

#define kTTBaseURLString @"http://loon.herokuapp.com/api/v0/"

@interface ORGMHTTPClient : AFHTTPClient
+ (ORGMHTTPClient*)sharedClient;
@end
