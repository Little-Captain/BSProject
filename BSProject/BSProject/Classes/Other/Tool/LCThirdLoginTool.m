//
//  LCThirdLoginTool.m
//  BSProject
//
//  Created by Liu-Mac on 5/8/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCThirdLoginTool.h"
#import "LCUserInfoItem.h"

#import <SVProgressHUD.h>

@implementation LCThirdLoginTool

+ (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType vc:(UIViewController *)vc {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:vc completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        if (resp.accessToken) {
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
        }
        
        // 创建 user 模型
        LCUserInfoItem *user = [LCUserInfoItem new];
        user.uid = resp.uid;
        user.openid = resp.openid;
        user.accessToken = resp.accessToken;
        user.refreshToken = resp.refreshToken;
        user.expiration = resp.expiration;
        user.name = resp.name;
        user.iconurl = resp.iconurl;
        user.gender = resp.gender;
        
        // 归档
        // 生成归档路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"user"];
        // 归档, 会调用对象的 encodeWithCoder 方法
        if([NSKeyedArchiver archiveRootObject:user toFile:path]) {
            NSLog(@"归档成功");
        } else {
            NSLog(@"归档失败");
        }        
    }];
}


@end
