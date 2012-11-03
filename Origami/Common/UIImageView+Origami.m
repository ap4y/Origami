//
//  UIImageView+Origami.m
//  Origami
//
//  Created by ap4y on 11/3/12.
//
//

#import "UIImageView+Origami.h"
#import "UIImageView+AFNetworking.h"

@implementation UIImageView (Origami)

- (void)setRemoteImageWithURL:(NSURL *)url
             placeholderImage:(UIImage *)placeholderImage {
    NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:url
                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                            timeoutInterval:60.0*60.0*24.0*30.0];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    [self setImageWithURLRequest:request
                placeholderImage:placeholderImage
                         success:nil
                         failure:nil];
}

- (void)setRemoteImageWithURL:(NSURL *)url {
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setRemoteImageWithURLRequest:(NSURLRequest *)urlRequest
                    placeholderImage:(UIImage *)placeholderImage
                             success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, UIImage *))success
                             failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *))failure {
    [self setImageWithURLRequest:urlRequest
                placeholderImage:placeholderImage
                         success:success
                         failure:failure];
}

@end
