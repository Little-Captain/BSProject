//
//  LCUserTool.m
//  BSProject
//
//  Created by Liu-Mac on 5/8/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCUserTool.h"
#import "LCUserInfoItem.h"
#import <UMSocialCore/UMSocialCore.h>

static LCUserInfoItem *_user;

@implementation LCUserTool

+ (LCUserInfoItem *)getLogInUser {
    
    if (!_user) {
        
        // 获取用户信息
        // 获取归档路径
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"user"];
        // 解档
        LCUserInfoItem *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        _user = user;
    }
    
    
    return _user;
}

+ (void)clearUserInfo {
    
    _user = nil;
    // 获取归档路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"user"];
    // 删除这个归档文件
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

+ (void)loginUseSinaWithVc:(UIViewController *)vc completion:(void(^)(BOOL isSuccess))completion {
    
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:vc completion:^(id result, NSError *error) {
        
        UMSocialUserInfoResponse *resp = result;
        
        if (resp.accessToken) {
            !completion ? : completion(YES);
        } else {
            !completion ? : completion(NO);
            return;
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
        _user = user;
        
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
