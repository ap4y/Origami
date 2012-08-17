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
    
    UIImage *backImage =
        [[UIImage imageNamed:@"back"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    UIImageView *imageView =
        [[UIImageView alloc] initWithImage:backImage];
    [[UITableView appearance] setBackgroundView:imageView];
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
