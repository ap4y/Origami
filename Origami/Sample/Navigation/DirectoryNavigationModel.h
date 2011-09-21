//
//  DirectoryNavigationModel.h
//  Sample
//
//  Created by Arthur Evstifeev on 23.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Three20/Three20.h"
#import "UPNPHelper.h"

@protocol DirectoryNavigationModelProtocol;
@interface DirectoryNavigationModel : TTListDataSource <UPNPHelperProtocol> {
    id<DirectoryNavigationModelProtocol> _directoryDelegate;
    NSMutableArray* _upnpItems;
    NSMutableDictionary* _selectedTracks;
}

@property(nonatomic, retain) NSMutableDictionary* selectedTracks;
@property(nonatomic, retain) NSMutableArray* upnpItems;
@property(nonatomic, retain)id<DirectoryNavigationModelProtocol> directoryDelegate;

+ (id)dataSourceFromUrl:(NSURL*)url;
+ (id)dataSourceFromUPNPFolder:(UPNPFolder*)folder;

@end

@protocol DirectoryNavigationModelProtocol <NSObject>
@optional
-(void)directoryModel:(DirectoryNavigationModel*)directoryModel didLoadUpnpFolderData:(NSString *)objId;

@end