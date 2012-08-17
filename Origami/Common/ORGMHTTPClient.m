//
//  ORGMHTTPClient.m
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORGMHTTPClient.h"

#import "AFJSONRequestOperation.h"
#import "AFNetworkActivityIndicatorManager.h"

@implementation ORGMHTTPClient

+ (ORGMHTTPClient*)sharedClient {
    static ORGMHTTPClient* _sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[ORGMHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kTTBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setStringEncoding:NSUTF8StringEncoding];
	[self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end
