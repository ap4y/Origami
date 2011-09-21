//
//  UPNPHelper.h
//  Sample
//
//  Created by Arthur Evstifeev on 28.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CyberLink/UPnP.h>
#import "Three20/Three20.h"

@interface UPNPFolder : NSObject {
    NSString* _title;
    NSString* _folderId;
    CGUpnpDevice* _deviceId;
}

@property(nonatomic, retain)NSString* title;
@property(nonatomic, retain)CGUpnpDevice* deviceId;
@property(nonatomic, retain)NSString* folderId;

+ (UPNPFolder*)folderWithTitle:(NSString*)title deviceId:(CGUpnpDevice*)deviceId folderId:(NSString*)folderId;

@end

@protocol UPNPHelperProtocol;

@interface UPNPHelper : NSObject {
    id<UPNPHelperProtocol> _delegate;
    NSMutableArray* _content;
    CGUpnpControlPoint* ctrlPoint;
}

@property(nonatomic, retain)id<UPNPHelperProtocol> delegate;
@property(nonatomic, retain)NSMutableArray* content;

+ (UPNPHelper *)defaultHelper;
- (void)contentsOfObject:(UPNPFolder*)folder;
- (void)contentsOfObjectAsync:(UPNPFolder*)folder;
@end

@protocol UPNPHelperProtocol <NSObject>

- (void)helper:(UPNPHelper*)helper didEndBrowsingFolder:(CgUpnpDevice*)dev withObjId:(NSString*)objId;

@end

@interface TableUPNPFolderItem : TTTableTextItem{
    UPNPFolder* _folder;
}

@property(nonatomic, retain) UPNPFolder* folder;

+ (id)itemWithUPNPFolder:(UPNPFolder *)folder delegate:(id)delegate selector:(SEL)selector;

@end