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

@implementation ORGMAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard"
                                                         bundle:nil];
    UINavigationController *navController =
        [storyboard instantiateViewControllerWithIdentifier:@"navController"];
    
    ORGMSideMenuViewController *menuController =
        (ORGMSideMenuViewController *)self.window.rootViewController;
    [menuController setTopViewController:navController];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
