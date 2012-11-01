//
//  ORGMMenuDataSource.h
//  Origami
//
//  Created by ap4y on 8/18/12.
//
//

#import <Foundation/Foundation.h>

@interface ORGMMenuDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>
- (void)reloadData;
- (void)toggleImportIndicator;
@end
