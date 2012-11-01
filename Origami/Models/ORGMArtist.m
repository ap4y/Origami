//
//  ORGMArtist.m
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

NSString * const artistErrorDomain = @"com.origami.errors.artist";

@implementation ORGMArtist
@dynamic title;
@dynamic albums;

+ (NSArray *)libraryArtists {
    NSFetchRequest *request = [[ORGMArtist all] orderBy:@"title", nil];
    [request setFetchBatchSize:20];
    
    return [ORGMArtist requestResult:request
                managedObjectContext:mainThreadContext()];
}

+ (NSArray *)topArtists {
    NSSortDescriptor *dateDiscriptor = [NSSortDescriptor sortDescriptorWithKey:@"updated_at"
                                                                     ascending:NO];
    NSFetchRequest *request = [[ORGMArtist all] orderByDescriptors:dateDiscriptor, nil];
    [request setFetchLimit:3];
    
    return [ORGMArtist requestResult:request
                managedObjectContext:mainThreadContext()];
}

- (BOOL)validateTitle:(id *)valueRef error:(NSError **)outError {
    NSString *title = *valueRef;
    if (!title || [title length] <= 0) {
        if (outError != NULL) {
            NSString *errorStr = NSLocalizedString(@"Invalid title", nil);
            NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey: errorStr };
            *outError = [[NSError alloc] initWithDomain:artistErrorDomain
                                                   code:0
                                               userInfo:userInfoDict];
        }
        return NO;
    }
    return YES;
}

@end
