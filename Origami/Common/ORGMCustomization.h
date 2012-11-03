//
//  ORGMCustomization.h
//  Origami
//
//  Created by ap4y on 8/17/12.
//
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    ORGMColoredEntitiesTypeTrack,
    ORGMColoredEntitiesTypeArtist,
    ORGMColoredEntitiesTypeAlbum,
    ORGMColoredEntitiesTypeGenre
} ORGMColoredEntitiesType;

@interface ORGMCustomization : NSObject
+ (void)prepareTheme;
+ (UIImageView *)backgroundImage;
+ (UIColor *)colorForColoredEntityType:(ORGMColoredEntitiesType)entityType;
@end
