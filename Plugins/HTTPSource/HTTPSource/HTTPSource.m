#import "HTTPSource.h"

@implementation HTTPSource

static long bytesOffset;

- (void)prepareCache:(NSString*)fileName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"StreamCache"];
    
	if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        NSError* error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:dataPath
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error]) {
            NSLog(@"Unable to create cache directory: %@", error.localizedDescription);    
            return;
        }
	}
    
    _filePath = [[dataPath stringByAppendingPathComponent:fileName] retain];  
    NSLog(@"filePath %@", _filePath);
    
    /*if ([[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
        NSError* error = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:_filePath error:&error]) {
            NSLog(@"Unable to remove cache file");
            return;
        }         
    }*/
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:_filePath]) {
        if (![[NSFileManager defaultManager] createFileAtPath:_filePath contents:nil attributes:nil]) {
            NSLog(@"Unable to create cache file");    
            return;
        }
    }
    
    _fileHandle = [[NSFileHandle fileHandleForUpdatingAtPath:_filePath] retain];    
}

- (BOOL)open:(NSURL *)url
{
    request = [[NSMutableURLRequest requestWithURL:url] retain];    
    NSLog(@"Is%@ main thread", ([NSThread isMainThread] ? @"" : @" NOT"));

    if ([NSThread isMainThread])
        _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    else 
        [self performSelector:@selector(mainThreadRequest) onThread:[NSThread mainThread] withObject:nil waitUntilDone:NO];    
    
    //cachedData = [[NSMutableData alloc] init]; 
    bytesExpected = 0;
    _byteReaded = 0;
    _byteCount = 0;
    _mimeType = @"";            
    
    //NSLog(@"%x.%@", [[url absoluteString] hash], url.pathExtension);
    [self prepareCache:[NSString stringWithFormat:@"%x.%@", [[url absoluteString] hash], url.pathExtension]];
    
    while(bytesExpected == 0) {
        [[NSRunLoop mainRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
	return YES;
}

- (void)mainThreadRequest {
    NSLog(@"Is%@ main thread", ([NSThread isMainThread] ? @"" : @" NOT"));
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];   
}

- (NSString *)mimeType
{
	return _mimeType;
}

- (BOOL)seekable
{
	return YES;
}

- (BOOL)seek:(long)position whence:(int)whence
{
    /*if (!_fileHandle) {
        return NO;
    }
    
    @try {
        [_fileHandle seekToFileOffset:position];
        return YES;
    }
    @catch (NSException *exception) {
        return NO;
    }*/
    //NSLog(@"wish position %ld", position);
    _byteReaded = position;
	return YES;
}

- (long)size {
    return (long)bytesExpected;
}

- (long)tell
{
    return _byteReaded;
	//return _byteCount;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {        
    _mimeType = response.MIMEType;
    bytesExpected = response.expectedContentLength; 
    NSLog(@"Request arrived");
    
    if ([_fileHandle seekToEndOfFile] == bytesExpected) {
        [_urlConnection cancel];
        _byteCount = (long)bytesExpected;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (data && _fileHandle) {        
       @try {
            @synchronized(_fileHandle) {
                [_fileHandle seekToEndOfFile];
                
                if (_fileHandle.offsetInFile <= _byteCount + bytesOffset) {                    
                    [_fileHandle seekToFileOffset: _byteCount + bytesOffset];                    
                    [_fileHandle writeData:data];
                    //NSLog(@"current cache size %ld", _byteCount);
                }
                
                _byteCount += data.length;                
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Cant append data");
        }
        //[cachedData appendData:data];
        //NSLog(@"Appending data");
    }
    else
        NSLog(@"Cant append data");   
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {   
    //canStop = YES;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

- (int)read:(void *)buffer amount:(int)amount
{
    if (!_fileHandle)
        return 0;

    if (_byteReaded + amount > bytesExpected)
        return 0;
        
    //NSLog(@"trying to read. status have %ld want %ld", _byteCount, _byteReaded + amount);
    while(_byteCount < _byteReaded + amount) {
        [[NSRunLoop mainRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
            
    @try {
        NSData* data = [NSData data];
        int result = 0;
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        @synchronized(_fileHandle) {
            [_fileHandle seekToFileOffset:_byteReaded];
            data = [_fileHandle readDataOfLength:amount];
        }
        
        [data getBytes:buffer length:data.length];
        _byteReaded += data.length;
        //NSLog(@"data length: %i", data.length);
        result = data.length;
        [pool release];
        return result;
    }
    @catch (NSException *exception) {
        return 0;
    }
    /*if (!cachedData)
        return 0;
 
    NSLog(@"trying to read. status have %i want %ld", cachedData.length, _byteCount + amount);
    while(cachedData.length < _byteCount + amount) {
        if (canStop) {
            NSLog(@"Ended normally");
            return 0;
        }        

        NSLog(@"waiting for data to arrive in %@ loop", [NSRunLoop mainRunLoop] == [NSRunLoop currentRunLoop] ? @"main" : @"other");        
        [[NSRunLoop mainRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }
    
    int totalRead = 0;
   
    if (buffer != NULL) {        
        NSLog(@"Reading %ld of %lld", _byteCount + amount, bytesExpected);
        [cachedData getBytes:(uint8_t *)buffer range:NSMakeRange(_byteCount, amount)];                        
        totalRead += amount;            
        _byteCount += totalRead;    
    }
    //else
    //   [_urlConnection cancel];
    
	return totalRead;*/
}

- (void)close
{
    NSLog(@"Should close");    
    [_urlConnection cancel];    
    /*NSError* error = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:_filePath error:&error]) {
        NSLog(@"Unable to remove cache file %@", error.localizedDescription);
    }*/    
}

- (void)dealloc
{
    //[self close];	    
    [_fileHandle closeFile];
    _fileHandle = nil;
    [_filePath release];
    [_fileHandle release];
    [_urlConnection release];
    _urlConnection = nil;
    //[cachedData release];
    [request release];	

	[super dealloc];
}

- (NSURL *)url
{
	return [request URL];
}

+ (NSArray *)schemes
{
	return [NSArray arrayWithObject:@"http"];
}

@end
