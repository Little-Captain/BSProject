//
//  LCCmtUserItem.h
//  BSProject
//
//  Created by Liu-Mac on 16/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//
//  评论的用户信息

#import <Foundation/Foundation.h>

@interface LCCmtUserItem : NSObject

/** 用户名 */
@property (nonatomic, strong) NSString *username;

/** 性别 */
@property (nonatomic, strong) NSString *sex;

/** 用户头像 */
@property (nonatomic, strong) NSString *profile_image;

@end
