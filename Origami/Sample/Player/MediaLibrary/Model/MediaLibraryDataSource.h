//
//  MediaLibraryDataSource.h
//  Sample
//
//  Created by Arthur Evstifeev on 24.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import <CoreData/CoreData.h>

@interface MediaLibraryDataSource : TTListDataSource {
}

+ (MediaLibraryDataSource*)dataSource;
@end
