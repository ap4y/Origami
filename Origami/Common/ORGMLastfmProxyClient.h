//
//  ORGMLastfmProxyClient.h
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import "AFHTTPClient.h"

#define kTTLastfmProxyBaseURLString @"http://lastfm-proxy.herokuapp.com/"

@interface ORGMLastfmProxyClient : AFHTTPClient
+ (ORGMLastfmProxyClient*)sharedClient;

- (NSURL*)albumImageUrlForArtist:(NSString *)artist albumTitle:(NSString *)title;
- (NSURL*)artistImageUrlForArtist:(NSString *)artist;
- (NSURL*)genreImageUrlForGenre:(NSString *)genre;
@end
