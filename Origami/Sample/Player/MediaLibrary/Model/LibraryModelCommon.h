//
//  LibraryModelCommon.h
//  Sample
//
//  Created by Arthur Evstifeev on 24.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MediaLibrary.h"
#import "Track.h"
#import "AudioMetadataReader.h"

@interface LibraryModelCommon : NSObject

+ (NSManagedObjectModel *)managedObjectModel;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSManagedObjectContext *)managedObjectContext;
@end

@interface MediaLibrary (Additional)

+ (MediaLibrary *)defaultLibrary;
- (void)addTrack:(Track *)track;
- (void)addTracks:(NSArray *)tracks;
- (NSArray*)tracksData;
- (void)removeTrack:(Track *)track;
- (void)removeTracksFromAlbum:(NSString *)album;
@end

@interface Track (Additional)

-(id)initWithTitle:(NSString*)title album:(NSString*)album artist:(NSString*)artist genre:(NSString*)genre url:(NSString*)url trackNo:(NSNumber*)trackNo year:(NSNumber*)year cover:(NSData*)cover;

+(Track*)trackWithTitle:(NSString*)title album:(NSString*)album artist:(NSString*)artist genre:(NSString*)genre url:(NSString*)url trackNo:(NSNumber*)trackNo year:(NSNumber*)year cover:(NSData*)cover;

@end

@interface AudioMetadataReader (Additional)

+(Track*)trackmetadataForURL:(NSURL *)url;

@end