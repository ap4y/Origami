//
//  Track.h
//  Sample
//
//  Created by Arthur Evstifeev on 27.08.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MediaLibrary;

@interface Track : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * album;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * genre;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * trackNo;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSData * cover;
@property (nonatomic, retain) MediaLibrary *library;

@end
