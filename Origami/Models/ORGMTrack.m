//
//  ORGMTrack.m
//  Origami
//
//  Created by ap4y on 10/29/12.
//
//

NSString * const errorDomain = @"com.origami.errors.track";

@implementation ORGMTrack
@dynamic title;
@dynamic track_num;
@dynamic track_path;
@dynamic album;
@dynamic genre;

- (BOOL)validateTitle:(id *)valueRef error:(NSError **)outError {
    NSString *title = *valueRef;
    if (!title || [title length] <= 0) {
        if (outError != NULL) {
            NSString *errorStr = NSLocalizedString(@"Invalid title", nil);
            NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey: errorStr };
            *outError = [[NSError alloc] initWithDomain:errorDomain
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
            *outError = [[NSError alloc] initWithDomain:errorDomain
                                                   code:1
                                               userInfo:userInfoDict];
        }
        return NO;
    }
    return YES;
}

@end
