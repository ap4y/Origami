//
//  ORGMAlbum.m
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

NSString * const albumErrorDomain = @"com.origami.errors.album";

@implementation ORGMAlbum
@dynamic title;
@dynamic tracks;
@dynamic artist;

+ (NSArray *)libraryAlbums {
    NSFetchRequest *request = [[ORGMAlbum all] orderBy:@"title", nil];
    [request setFetchBatchSize:20];
    
    return [ORGMAlbum requestResult:request
               managedObjectContext:mainThreadContext()];
}

+ (NSArray *)topAlbums {
    NSSortDescriptor *dateDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"updated_at"
                                                                     ascending:NO];
    NSFetchRequest *request = [[ORGMAlbum all] orderByDescriptors:dateDiscriptor, nil];
    [request setFetchLimit:3];
    
    return [ORGMAlbum requestResult:request
               managedObjectContext:mainThreadContext()];
}

- (BOOL)validateTitle:(id *)valueRef error:(NSError **)outError {
    NSString *title = *valueRef;
    if (!title || [title length] <= 0) {
        if (outError != NULL) {
            NSString *errorStr = NSLocalizedString(@"Invalid title", nil);
            NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey: errorStr };
            *outError = [[NSError alloc] initWithDomain:albumErrorDomain
                                                   code:0
                                               userInfo:userInfoDict];
        }
        return NO;
    }
    return YES;
}

@end
