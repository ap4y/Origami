//
//  ORGMGenre.m
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

NSString * const genreErrorDomain = @"com.origami.errors.genre";

@implementation ORGMGenre
@dynamic title;
@dynamic tracks;

- (BOOL)validateTitle:(id *)valueRef error:(NSError **)outError {
    NSString *title = *valueRef;
    if (!title || [title length] <= 0) {
        if (outError != NULL) {
            NSString *errorStr = NSLocalizedString(@"Invalid title", nil);
            NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey: errorStr };
            *outError = [[NSError alloc] initWithDomain:genreErrorDomain
                                                   code:0
                                               userInfo:userInfoDict];
        }
        return NO;
    }
    return YES;
}

@end
