#import "Plugin.h"

@interface HTTPSource : NSObject <CogSource>
{
	long _byteCount;
    long _byteReaded;
	NSString* _filePath;
    NSFileHandle* _fileHandle;
	NSString *_mimeType;
    NSMutableURLRequest* request;
    //NSMutableData* cachedData;
    NSURLConnection* _urlConnection;
    long long bytesExpected;
    //BOOL canStop;
}



@end
