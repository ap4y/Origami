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

+ (UIColor *)colorForColoredEntityType:(ORGMColoredEntitiesType)entityType {
    switch (entityType) {
        case ORGMColoredEntitiesTypeTrack:
            return RGB(0, 204, 238);
        case ORGMColoredEntitiesTypeArtist:
            return RGB(204, 0, 238);
        case ORGMColoredEntitiesTypeAlbum:
            return RGB(238, 0, 204);
        case ORGMColoredEntitiesTypeGenre:
            return RGB(238, 204, 0);
    }
    return RGB(0, 204, 238);
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
