//
//  ORGMAppDelegate.m
//  Origami
//
//  Created by ap4y on 8/16/12.
//
//

#import "ORGMAppDelegate.h"

#import "ORGMSideMenuViewController.h"
#import "ORGMLibraryViewController.h"
#import "ORGMCustomization.h"

@implementation ORGMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    UINavigationController *navController =
        [storyboard instantiateViewControllerWithIdentifier:@"navController"];
    
    ORGMSideMenuViewController *menuController =
        (ORGMSideMenuViewController *)self.window.rootViewController;
    [menuController setTopViewController:navController];
    
    [ORGMCustomization prepareTheme];
    
    [application beginReceivingRemoteControlEvents];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        [[ORGMPlayerController defaultPlayer] handleRemoteControlEvent:event];
    }
}

@end
