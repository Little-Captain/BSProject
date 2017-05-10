//
//  AppDelegate.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "LCMainTabBarC.h"

#import <UMSocialCore/UMSocialCore.h>
#import <Bugly/Bugly.h>
#import <AVFoundation/AVFoundation.h>
#import <SVProgressHUD.h>

@interface AppDelegate () <UITabBarControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 友盟分享
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:NO];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"590839e05312dd1f970016bf"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    // Bugly
    // 读取 Info.plist 中的配置
    [Bugly startWithAppId:nil];
    
    // 设置默认扬声器发声, 如果插上耳机, 就使用耳机发声
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                     withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                                           error:nil];
    
    // SVProgressHUD 的统一配置
    [SVProgressHUD setMinimumDismissTimeInterval:0.5];
    
    // 配置 LCMainTabBarC 对象 的 代理
    [LCMainTabBarC sharedInstance].delegate = self;
    
    self.window = ({
        // 创建窗口
        UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        // 设置窗口的根控制器
        window.rootViewController = [NSClassFromString(@"LCAdVC") new];
        window;
    });
    
    // 显示窗口
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)confitUShareSettings {
    
    /*
     * 打开图片水印
     */
    [UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms {
    
    /* 设置微信的appKey和appSecret */
    // 分享到微信回话
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxaafae70c2f9a09aa" appSecret:@"a4d82019c8c65897d94e65536f901e2a" redirectURL:@"http://mobile.umeng.com/social"];
    // 分享到微信朋友圈
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatTimeLine appKey:@"wxaafae70c2f9a09aa" appSecret:@"a4d82019c8c65897d94e65536f901e2a" redirectURL:@"http://mobile.umeng.com/social"];
    // 分享到微信收藏
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatFavorite appKey:@"wxaafae70c2f9a09aa" appSecret:@"a4d82019c8c65897d94e65536f901e2a" redirectURL:@"http://mobile.umeng.com/social"];
    
    /* 设置新浪的appKey和appSecret */
    // 新浪分享
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"2139382427"  appSecret:@"507fccf0efde8a900cc86700abc13827" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}

// 支持所有iOS系统
// 分享后回调处理
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (result) {
        // 这里我们处理分享成功的回调
    } else {
        // 其他如支付等SDK的回调
    }
    
    return result;
}

#pragma mark - UITabBarControllerDelegate

// 当选中 tabBarController 的 子控制器 时调用
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    [NotificationCenter postNotificationName:UITabBarControllerDidSelectViewControllerNotification object:nil];
}

@end
