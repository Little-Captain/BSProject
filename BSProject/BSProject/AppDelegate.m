//
//  AppDelegate.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "LCMainTabBarC.h"
#import "LCPushGuideView.h"

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 根控制器
    LCMainTabBarC *tabBarC = [LCMainTabBarC new];
    tabBarC.delegate = self;
    
    // 设置窗口的根控制器
    self.window.rootViewController = tabBarC;
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    // 显示引导页
    [LCPushGuideView show];
    
    return YES;
}

#pragma mark - UITabBarControllerDelegate

// 当选中 tabBarController 的 子控制器 时调用
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    [NotificationCenter postNotificationName:UITabBarControllerDidSelectViewControllerNotification object:nil];
}

@end
