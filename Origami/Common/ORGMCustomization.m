//
//  ORGMCustomization.m
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import "ORGMCustomization.h"

@implementation ORGMCustomization

#pragma mark - public
+ (void)prepareTheme {
    [self navigationBar];
}

+ (UIImageView *)backgroundImage {
    UIImage *backImage =
        [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    return [[UIImageView alloc] initWithImage:backImage];
}

#pragma mark - private
+ (void)navigationBar {
    UIImage *backImage =
        [[UIImage imageNamed:@"nav_back"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [[UINavigationBar appearance] setBackgroundImage:backImage
                                       forBarMetrics:UIBarMetricsDefault];
    
    UIImage *barButton = [[UIImage imageNamed:@"clear_image"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [[UIBarButtonItem appearance] setBackgroundImage:barButton
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
}

@end
