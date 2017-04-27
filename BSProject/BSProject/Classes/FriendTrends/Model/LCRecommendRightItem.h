//
//  LCRecommendRightItem.h
//  BSProject
//
//  Created by Liu-Mac on 4/27/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCRecommendRightItem : NSObject

/*
 
 uid	string	推荐的用户id
 fans_count	string	所推荐用户的被关注量
 is_follow	int	是否是我关注的用户
 gender	int	性别,0为男，1为女
 screen_name	string	所推荐的用户昵称
 header	string	所推荐的用户的头像url
 introduction	string	用户描述
 tiezi_count	int	所发表的贴子数量
 
 */

/** 所推荐的用户昵称 */
@property (nonatomic, strong) NSString *screen_name;

/** 所推荐用户的被关注量 */
@property (nonatomic, assign) NSInteger fans_count;

/** 所推荐的用户的头像url */
@property (nonatomic, strong) NSString *header;

/** 是否是我关注的用户 */
@property (nonatomic, assign) NSInteger is_follow;

@end
