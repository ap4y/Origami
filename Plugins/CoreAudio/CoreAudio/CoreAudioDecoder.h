#include <AudioToolbox/ExtendedAudioFile.h>
#import "Plugin.h"


@interface CoreAudioDecoder : NSObject <CogDecoder>
{
    id<CogSource>           _source;
    AudioFileID             _mAudioFile;
	ExtAudioFileRef			_in;

	int bitrate;
	int bitsPerSample;
	int channels;
	float frequency;
	long totalFrames;
}


@end
