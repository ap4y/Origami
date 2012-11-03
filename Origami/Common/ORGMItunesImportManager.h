//
//  ORGMItunesImporter.h
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

#import <Foundation/Foundation.h>

@interface ORGMItunesImportManager : NSObject
+ (ORGMItunesImportManager *)defaultManager;

- (void)importFromDocumentsDirectoryWithSuccess:(void(^)())success;
@end
