//
//  AppDelegate.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "AppDelegate.h"

#import "LCPushGuideView.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 设置窗口的根控制器
    self.window.rootViewController = [NSClassFromString(@"LCMainTabBarC") new];
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    // 显示引导页
    [LCPushGuideView show];
    
    return YES;
}

@end
