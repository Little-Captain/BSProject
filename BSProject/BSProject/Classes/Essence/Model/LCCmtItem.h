//
//  LCCmtItem.h
//  BSProject
//
//  Created by Liu-Mac on 16/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//
//  评论信息

#import <Foundation/Foundation.h>

@class LCCmtUserItem;

@interface LCCmtItem : NSObject

/** 评论内容 */
@property (nonatomic, strong) NSString *content;

/** 评论时间 */
@property (nonatomic, strong) NSString *ctime;

/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;

/** 音频url */
@property (nonatomic, strong) NSString *voiceuri;

/** 点赞数 */
@property (nonatomic, strong) NSString *like_count;

/** 评论者 */
@property (nonatomic, strong) LCCmtUserItem *user;

/** 评论的id */
@property (nonatomic, strong) NSString *ID;

@end
