//
//  AppDelegate.m
//  Marcel Voss
//
//  Created by Marcel Voß on 21.04.16.
//  Copyright © 2016 Marcel Voß. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:hasRunBefore]) {
        
        [defaults setBool:NO forKey:shownImageViewerBefore];
        
        [defaults setBool:YES forKey:hasRunBefore];
        [defaults synchronize];
    }
    
    MainViewController *mainVC = [[MainViewController alloc] init];
    self.window.rootViewController = mainVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    // TODO: Finish URL schemes
    if ([url.absoluteString isEqualToString:@"marcelvoss://about"]) {
        //UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        //UIViewController *vc = window.rootViewController;
        
        
        
        
    } else if ([url.absoluteString isEqualToString:@"marcelvoss://education"]) {
        
    } else if ([url.absoluteString isEqualToString:@"marcelvoss://projects"]) {
        
    } else if ([url.absoluteString isEqualToString:@"marcelvoss://skills"]) {
        
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
