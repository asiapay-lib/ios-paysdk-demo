//
//  AppDelegate.m
//  DemoApp-Objc
//
//  Created by Asiapay on 05/03/20.
//  Copyright © 2020 Asiapay. All rights reserved.
//

#import "AppDelegate.h"
//#import "IQKeyboardManager.h"
//@import IQKeyboardManagerSwift;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [IQKeyboardManager shared].enable = true;
//    [IQKeyboardManager sharedManager].enable = true;
    return YES;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    [[PaySDK shared] processOrderWithUrl:url];
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [[PaySDK shared] processOrderWithUrl:url];
    return YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [[PaySDK shared] processOrderWithUrl:url];
    return YES;
}


@end
