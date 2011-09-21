//
//  UPNPHelper.m
//  Sample
//
//  Created by Arthur Evstifeev on 28.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UPNPHelper.h"
#import "LibraryModelCommon.h"
#import "NSString+URLEncode.h"
#import "Reachability.h"

@implementation UPNPHelper
@synthesize delegate = _delegate, content = _content;

- (void)dealloc {
    [ctrlPoint release];
    [_content release];
    [super dealloc];
}

- (NSString*)parseXmlParam:(NSString*)paramName paramContent:(NSString*)paramContent {
    NSError* err;
    
    NSString* pattern = [NSString stringWithFormat:@"<%@>.*?</%@>", paramName, paramName];    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:(NSRegularExpressionDotMatchesLineSeparators) error:&err];
    
    NSArray* paramArray = [regex matchesInString:paramContent options:NSMatchingCompleted range:NSMakeRange(0, paramContent.length)];
    
    NSString *result = @"";
    if (paramArray.count > 0) {
        NSTextCheckingResult* paramArrayResult = [paramArray objectAtIndex:0];
        result = [paramContent substringWithRange:paramArrayResult.range];
        result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", paramName] withString:@""];
        result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", paramName] withString:@""];            
    }    
    else
        return nil;
    
    return result;
}

- (NSString*)parseXmlParamWithUrl:(NSString*)paramName paramContent:(NSString*)paramContent {
    NSError* err;
    
    NSString* pattern = [NSString stringWithFormat:@"<%@.*?>.*?</%@>", paramName, paramName];    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:(NSRegularExpressionDotMatchesLineSeparators) error:&err];
    
    NSArray* paramArray = [regex matchesInString:paramContent options:NSMatchingCompleted range:NSMakeRange(0, paramContent.length)];
    
    NSString *result = @"";
    if (paramArray.count > 0) {
        NSTextCheckingResult* paramArrayResult = [paramArray objectAtIndex:0];
        result = [paramContent substringWithRange:paramArrayResult.range];
        result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<%@>", paramName] withString:@""];
        result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", paramName] withString:@""];            
    }    
    else
        return nil;
    
    return result;
}

- (NSString*)parseXmlUrlParam:(NSString*)paramName paramContent:(NSString*)paramContent {
    NSError* err;
    
    //NSLog(@"%@", paramContent);
    //NSLog(@"%@", [NSString stringWithFormat:@"http:.*?</%@>", paramName]);
    
    NSRegularExpression* regexUrl = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"http:.*", paramName] options:(NSRegularExpressionDotMatchesLineSeparators) error:&err];
    
    NSArray* urlArray = [regexUrl matchesInString:paramContent options:NSMatchingCompleted range:NSMakeRange(0, paramContent.length)];
    
    NSString* result;
    if (urlArray.count > 0) {
        NSTextCheckingResult* urlArrayResult = [urlArray objectAtIndex:0];
        result = [paramContent substringWithRange:urlArrayResult.range];
        //result = [result stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"</%@>", paramName] withString:@""];            
    }
    else
        return nil;
    
    return result;
}

- (NSArray*)PrintContentDirectory:(CGUpnpAction*)browseAction deviceId:(CGUpnpDevice*)deviceId objectId:(NSString*)objectId
{
	[browseAction setArgumentValue:objectId forName:@"ObjectID"];
	[browseAction setArgumentValue:@"BrowseDirectChildren" forName:@"BrowseFlag"];
	[browseAction setArgumentValue:@"*" forName:@"Filter"];
	[browseAction setArgumentValue:@"0" forName:@"StartingIndex"];
	[browseAction setArgumentValue:@"0" forName:@"RequestedCount"];
	[browseAction setArgumentValue:@"" forName:@"SortCriteria"];
	
	if (![browseAction post])
		return nil;
    
    NSMutableArray* content = [[[NSMutableArray alloc] init] autorelease];
	NSString *resultStr = [browseAction argumentValueForName:@"Result"];    
    resultStr = [resultStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //NSLog(@"%@", resultStr);
    
    NSError* err;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"<container.*?>.*?</container>" options:(NSRegularExpressionCaseInsensitive & NSRegularExpressionDotMatchesLineSeparators) error:&err];
    
    NSArray* contentArray = [regex matchesInString:resultStr options:NSMatchingCompleted range:NSMakeRange(0, resultStr.length)];
    
    for (NSTextCheckingResult* contentNodeResult in contentArray) {
        NSString* contentNode = [resultStr substringWithRange:contentNodeResult.range];
        
        NSRegularExpression* regexId = [NSRegularExpression regularExpressionWithPattern:@"id=\".*?\"" options:(NSRegularExpressionDotMatchesLineSeparators) error:&err];
        
        NSArray* idArray = [regexId matchesInString:contentNode options:NSMatchingCompleted range:NSMakeRange(0, contentNode.length)];
        
        NSString *objId = @"";
        if (idArray.count > 0) {
            NSTextCheckingResult* idArrayResult = [idArray objectAtIndex:0];
            objId = [contentNode substringWithRange:idArrayResult.range];
            objId = [objId stringByReplacingOccurrencesOfString:@"id=" withString:@""];
            objId = [objId stringByReplacingOccurrencesOfString:@"\"" withString:@""];            
        }
        
        NSString *title = [self parseXmlParam:@"dc:title" paramContent:contentNode];
        
        NSLog(@"[%@] %@", objId, title); 
        NSString* titleString;
        
        if ([objId rangeOfString:@"$"].location != NSNotFound)
            titleString = title;   
        else
            titleString = [NSString stringWithFormat:@"%@:%@", deviceId.friendlyName, title];    

        UPNPFolder* folder = [UPNPFolder folderWithTitle:titleString deviceId:deviceId folderId:objId];
        [content addObject:folder];
        //[self PrintContentDirectory:browseAction objectId:objId];
    }
    
    NSRegularExpression* regexItems = [NSRegularExpression regularExpressionWithPattern:@"<item.*?>.*?</item>" options:(NSRegularExpressionCaseInsensitive & NSRegularExpressionDotMatchesLineSeparators) error:&err];
    
    NSArray* itemArray = [regexItems matchesInString:resultStr options:NSMatchingCompleted range:NSMakeRange(0, resultStr.length)];
    
    NSData* coverData = nil;
    NSString* prevAlbum = @"";
    for (NSTextCheckingResult* itemResult in itemArray) {
        NSString* item = [resultStr substringWithRange:itemResult.range];
        //NSLog(@"%@", [item stringWithUrlDecodeOfString]);
        
        NSString *url = [self parseXmlParamWithUrl:@"res" paramContent:item];
        url = [self parseXmlUrlParam:@"res" paramContent:url];
        url = [url stringWithUrlDecodeOfString];
        NSLog(@"%@", url);
        
        NSString *type = [self parseXmlParam:@"upnp:class" paramContent:item];
        NSString *title = [[self parseXmlParam:@"dc:title" paramContent:item] stringWithUrlDecodeOfString];
        NSString *album = [[self parseXmlParam:@"upnp:album" paramContent:item] stringWithUrlDecodeOfString];
        NSString *artist = [[self parseXmlParam:@"upnp:artist" paramContent:item] stringWithUrlDecodeOfString];
        NSString *genre = [self parseXmlParam:@"upnp:genre" paramContent:item];
        NSString *trackNo = [self parseXmlParam:@"upnp:originalTrackNumber" paramContent:item];
        NSString *cover = [self parseXmlParamWithUrl:@"upnp:albumArtURI" paramContent:item];
        
        if (cover != nil && ![album isEqualToString:prevAlbum]) {
            cover = [[self parseXmlUrlParam:@"upnp:albumArtURI" paramContent:cover] stringWithUrlDecodeOfString];            
            coverData = [NSData dataWithContentsOfURL:[NSURL URLWithString:cover]];
            NSLog(@"length original %i", coverData.length);
            if (coverData.length > 100000) {
                UIImage* img = [UIImage imageWithData:coverData];
                float scale = 400.0/img.size.width;
                //UIImage* imageFormatted = [UIImage imageWithCGImage:[img CGImage] scale:scale orientation:img.imageOrientation];
                coverData = UIImageJPEGRepresentation(img, scale);
                NSLog(@"length formatted %i", coverData.length);
            }
            
        }
        //NSString *year = [self parseXmlParam:@"date" paramContent:item];
        
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        NSNumber * trackNumber = [f numberFromString:trackNo];
        
        
        if ([type isEqualToString:@"object.item.audioItem.musicTrack"]) {
            NSLog(@"[%@] %@", title, url);
            Track* file = [Track trackWithTitle:title album:album artist:artist genre:genre url:url trackNo:trackNumber year:nil cover:coverData];        
            [content addObject:file];
        }
        
        prevAlbum = album;
        [f release];
    }
    
    return content;
}

-(NSArray*)PrintDmsInfo:(CGUpnpDevice*)dev objectId:(NSString*)objectId
{
	NSLog(@"%@", [dev friendlyName]);
    
	CGUpnpService *conDirService = [dev getServiceForType:@"urn:schemas-upnp-org:service:ContentDirectory:1"];
	if (!conDirService)
		return nil;
    
	/*CGUpnpStateVariable *searchCap = [conDirService getStateVariableForName:@"SearchCapabilities"];
     if (searchCap) {
     if ([searchCap query])
     NSLog(@"  SearchCapabilities = %@\n", [searchCap value]);
     }
     
     CGUpnpStateVariable *sorpCap = [conDirService getStateVariableForName:@"SortCapabilities"];
     if (sorpCap) {
     if ([sorpCap query])
     NSLog(@"  SortCapabilities = %@\n", [sorpCap value]);
     }*/
    
	CGUpnpAction *browseAction = [conDirService getActionForName:@"Browse"];
	if (!browseAction)
		return nil;
    
    return [self PrintContentDirectory:browseAction deviceId:dev objectId:objectId];
}

- (void)contentsOfObject:(UPNPFolder*)folder {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    if (!_content)
        _content = [[NSMutableArray alloc] init];
    else
        [_content removeAllObjects];        
                        
    if (folder == nil) {                            
        [ctrlPoint search];
                        
        NSArray *devArray = [ctrlPoint devices];
        
        if (devArray.count <= 0) {        
            NSLog(@"Media Server is not found !!\n");
        }
                        
        for (CGUpnpDevice *curDev in devArray) {        
            if ([curDev isDeviceType:@"urn:schemas-upnp-org:device:MediaServer:1"]) {            
                NSArray* curContent = [self PrintDmsInfo:curDev objectId:@"0"];                
                if (curContent) {                
                    [_content addObjectsFromArray:curContent];
                }                
            }
        }                
    }
    else {
        [_content addObjectsFromArray:[self PrintDmsInfo:folder.deviceId objectId:folder.folderId]];
    }

    [_delegate helper:self didEndBrowsingFolder:folder.deviceId withObjId:folder.folderId];
    
    [pool release];
}

- (void)contentsOfObjectAsync:(UPNPFolder*)folder {
    
    [self performSelectorInBackground:@selector(contentsOfObject:) withObject:folder];
}

- (id)init {
    self = [super init];
    if (self) {
        ctrlPoint = [[CGUpnpControlPoint alloc] init];
    }
    return self;
}

+ (UPNPHelper *)defaultHelper
{
    static UPNPHelper *defaultHelper;
    
    @synchronized(self)
    {
        if (!defaultHelper) {
            Reachability* hostReach = [Reachability reachabilityForLocalWiFi];
            if([hostReach currentReachabilityStatus] != NotReachable)
                defaultHelper = [[UPNPHelper alloc] init];       
            else
                defaultHelper = nil;
        }
                    
        return defaultHelper;
    }
}

@end

@implementation UPNPFolder
@synthesize title = _title, folderId = _folderId, deviceId = _deviceId;

- (void)dealloc {
    [_folderId release];
    [_deviceId release];
    [_title release];
    [super dealloc];
}

+ (UPNPFolder*)folderWithTitle:(NSString*)title deviceId:(CGUpnpDevice*)deviceId folderId:(NSString*)folderId {
    UPNPFolder* folder = [[[UPNPFolder alloc] init] autorelease];
    folder.title = title;
    folder.folderId = folderId;
    folder.deviceId = deviceId;
    return folder;
}

@end

@implementation TableUPNPFolderItem
@synthesize folder = _folder;

- (void)dealloc {
    TT_RELEASE_SAFELY(_folder);    
    [super dealloc];
}

+ (id)itemWithUPNPFolder:(UPNPFolder *)folder delegate:(id)delegate selector:(SEL)selector {
    TableUPNPFolderItem* item = [[[self alloc] init] autorelease];

    item.text = folder.title;
    item.delegate = delegate;
    item.selector = selector;
    item.folder = folder;
    return item;
}
@end