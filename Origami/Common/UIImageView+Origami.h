//
//  UIImageView+Origami.h
//  Origami
//
//  Created by ap4y on 11/3/12.
//
//

#import "AFImageRequestOperation.h"

@interface UIImageView (Origami)

- (void)setRemoteImageWithURL:(NSURL *)url;
- (void)setRemoteImageWithURL:(NSURL *)url
       placeholderImage:(UIImage *)placeholderImage;
- (void)setRemoteImageWithURLRequest:(NSURLRequest *)urlRequest
                    placeholderImage:(UIImage *)placeholderImage
                             success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                             failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure;

@end
