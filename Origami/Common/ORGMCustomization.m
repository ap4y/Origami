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
    
    [[UINavigationBar appearance] setTintColor:RGB(238, 238, 238)];
    
    NSDictionary *textAttr = @{
        UITextAttributeTextColor: RGB(60, 60, 60),
        UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
        UITextAttributeFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0]
    };
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttr
                                                forState:UIControlStateNormal];
}

@end
