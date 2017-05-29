//
//  AppDelegate.m
//  FunctionalReactivePixels
//
//  Created by William Peregoy on 29/04/2017.
//  Copyright © 2017 William Peregoy. All rights reserved.
//

#import "FRPAppDelegate.h"
#import "FRPGalleryViewController.h"


@interface FRPAppDelegate ()

@property (nonatomic, readwrite) PXAPIHelper *apiHelper;

@end


@implementation FRPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.apiHelper = [[PXAPIHelper alloc] initWithHost:nil consumerKey:@"4AIC83aylI052hE4IQRzvjua4b2tP7tUrK9sN36B" consumerSecret:@"VfIxaGJccL941OVRTcJbff8XjVtir2nOmkS9x1sW"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[FRPGalleryViewController new]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
