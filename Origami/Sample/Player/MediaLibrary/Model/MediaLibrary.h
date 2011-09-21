//
//  MediaLibrary.h
//  Sample
//
//  Created by Arthur Evstifeev on 27.08.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Track;
@protocol MediaLibraryDelegate;

@interface MediaLibrary : NSManagedObject {
    id<MediaLibraryDelegate> _delegate;
@private
}

@property(nonatomic, retain) id<MediaLibraryDelegate> delegate;

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSSet *tracks;
@end

@interface MediaLibrary (CoreDataGeneratedAccessors)

- (void)addTracksObject:(Track *)value;
- (void)removeTracksObject:(Track *)value;
- (void)addTracks:(NSSet *)values;
- (void)removeTracks:(NSSet *)values;

@end

@protocol MediaLibraryDelegate <NSObject>
@optional

-(void)libraryDidAddedTrack:(MediaLibrary*)library;
-(void)libraryDidAddedTracks:(MediaLibrary*)library;
-(void)libraryDidRemovedTrack:(MediaLibrary*)library;
-(void)libraryDidRemovedTracks:(MediaLibrary*)library;

@end