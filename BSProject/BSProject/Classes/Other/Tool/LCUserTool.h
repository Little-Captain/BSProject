//
//  LCUserTool.h
//  BSProject
//
//  Created by Liu-Mac on 5/8/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LCUserInfoItem;

@interface LCUserTool : NSObject

+ (LCUserInfoItem *)getLogInUser;
+ (void)clearUserInfo;
+ (void)loginUseSinaWithVc:(UIViewController *)vc completion:(void(^)(BOOL isSuccess))completion;

@end
