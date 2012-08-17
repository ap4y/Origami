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
    
    UIImageView* imageView =
        [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back"]];
    [[UITableView appearance] setBackgroundView:imageView];
}

#pragma mark - private
+ (void)navigationBar {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"nav_back"]
                                       forBarMetrics:UIBarMetricsDefault];
    
    UIImage* barButton = [[UIImage imageNamed:@"barbutton_back"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0)];
    [[UIBarButtonItem appearance] setBackgroundImage:barButton
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
}

@end
