//
//  FileSource.m
//  FileSource
//
//  Created by Vincent Spader on 3/1/07.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "FileSource.h"


@implementation FileSource

- (void)setURL:(NSURL *)url
{
	[url retain];
	[_url release];
	_url = url;
}

- (BOOL)open:(NSURL *)url
{
	[self setURL:url];
	
	_fd = fopen([[url path] UTF8String], "r");
	
	return (_fd != NULL);
}

- (BOOL)seekable
{
	return YES;
}

- (BOOL)seek:(long)position whence:(int)whence
{
	return (fseek(_fd, position, whence) == 0);
}

- (long)tell {
    return ftell(_fd);
}
- (long)size
{
    long curpos = ftell(_fd);
    fseek (_fd, 0, SEEK_END);
    long size = ftell(_fd);
    fseek(_fd, curpos, SEEK_SET);
	return size;
}

- (int)read:(void *)buffer amount:(int)amount
{
	return fread(buffer, 1, amount, _fd);
}

- (void)close
{
	if (_fd) 
	{
		fclose(_fd);
		_fd = NULL;
	}
}

- (NSURL *)url
{
	return _url;
}

- (NSString *)mimeType
{
	return nil;
}

+ (NSArray *)schemes
{
	return [NSArray arrayWithObject:@"file"];
}

- (void)dealloc {
	[self close];
	[self setURL:nil];
	
	[super dealloc];
}

@end
