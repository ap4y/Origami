//
//  DirectoryNavigationController.h
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Three20/Three20.h"
#import "DirectoryNavigationModel.h"
#import "UPNPHelper.h"

@interface DirectoryNavigationController : TTTableViewController <DirectoryNavigationModelProtocol> {
    NSURL* _currentUrl;
    UPNPFolder* _folder;
    
    DirectoryNavigationModel* _navigationModel;        
    UIBarButtonItem* _addBtn;
}

- (id)initWithUrl:(NSString*)url query:(NSDictionary*)query;

@end
