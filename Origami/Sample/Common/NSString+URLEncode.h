//
//  NSString+URLEncode.h
//  Sample
//
//  Created by Arthur Evstifeev on 24.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSString_URLEncode)

-(id)stringWithUrlEncodeOfString;
-(id)stringWithUrlDecodeOfString;
+(id)stringWithSpecialEncodeOfString:(NSString *)string;
+(id)stringWithSpecialDencodeOfString:(NSString *)string;

@end
