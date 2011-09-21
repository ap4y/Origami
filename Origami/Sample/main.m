//
//  main.m
//  Sample
//
//  Created by Arthur Evstifeev on 18.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

int main(int argc, char *argv[])
{
    NSString* appClass = @"CustomApp";
    NSString* delegateClass = nil;

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, appClass, delegateClass);
    [pool release];
    return retVal;
}
