//
//  ORGMTrack.m
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

NSString * const trackErrorDomain = @"com.origami.errors.track";

@implementation ORGMTrack
@dynamic title;
@dynamic track_num;
@dynamic track_path;
@dynamic album;
@dynamic genre;

+ (NSArray *)libraryTracks {
    NSFetchRequest *request = [[ORGMTrack all] orderBy:@"track_num", @"title", nil];
    [request setFetchBatchSize:20];
    
    return [ORGMTrack requestResult:request
               managedObjectContext:mainThreadContext()];
}

+ (NSArray *)topTracks {
    NSSortDescriptor *dateDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"updated_at"
                                                                     ascending:NO];
    NSFetchRequest *request = [[ORGMTrack all] orderByDescriptors:dateDiscriptor, nil];
    [request setFetchLimit:3];
    
    return [ORGMTrack requestResult:request
               managedObjectContext:mainThreadContext()];
}

- (BOOL)validateTitle:(id *)valueRef error:(NSError **)outError {
    NSString *title = *valueRef;
    if (!title || [title length] <= 0) {
        if (outError != NULL) {
            NSString *errorStr = NSLocalizedString(@"Invalid title", nil);
            NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey: errorStr };
            *outError = [[NSError alloc] initWithDomain:trackErrorDomain
                                                   code:0
                                               userInfo:userInfoDict];
        }
        return NO;
    }
    return YES;
}

- (BOOL)validateTrack_path:(id *)valueRef error:(NSError **)outError {
    NSString *path = *valueRef;
    if (!path || [path length] <= 0) {
        if (outError != NULL) {
            NSString *errorStr = NSLocalizedString(@"Invalid track path", nil);
            NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey: errorStr };
            *outError = [[NSError alloc] initWithDomain:trackErrorDomain
                                                   code:1
                                               userInfo:userInfoDict];
        }
        return NO;
    }
    return YES;
}

@end
