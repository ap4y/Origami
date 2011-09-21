#import "OrigamiAppDelegate.h"
#import "StyleSheet.h"

@implementation OrigamiAppDelegate
@synthesize window = _window;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [TTStyleSheet setGlobalStyleSheet:[[[StyleSheet alloc] init] autorelease]];
    
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeAll;
    navigator.window = self.window;
    TTURLMap* map = navigator.URLMap;
    [map from:@"tt://directory/(initWithUrl:)" toViewController:NSClassFromString(@"DirectoryNavigationController")];
    //[map from:@"tt://fileplay/(initWithUrl:)" toViewController:NSClassFromString(@"FilePlayerController")];
    [map from:@"tt://container/(initWithUrl:)" toViewController:NSClassFromString(@"ContainerController")];
    [map from:@"tt://library/" toSharedViewController :NSClassFromString(@"LibraryController")];
    [map from:@"tt://nowplaying/" toSharedViewController :NSClassFromString(@"NowPlayingViewController")];
        
    [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://library/"]];    
    [application beginReceivingRemoteControlEvents];
    
    //clear cache
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* dataPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"StreamCache"];
    
	if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        NSError* error = nil;
        if (![[NSFileManager defaultManager] removeItemAtPath:dataPath error:&error]) {
            NSLog(@"Unable to create cache directory: %@", error.localizedDescription);
        }        
	}
}

-(void)applicationWillTerminate:(UIApplication *)application {
    [application endReceivingRemoteControlEvents];
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
