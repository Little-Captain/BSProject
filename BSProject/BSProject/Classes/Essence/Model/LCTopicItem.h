//
//  LCTopicItem.h
//  BSProject
//
//  Created by Liu-Mac on 12/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCCmtItem;

@interface LCTopicItem : NSObject

/*
 
 用户信息相关
 
 */

/** 名称 */
@property (nonatomic, strong) NSString *name;

/** 头像 */
@property (nonatomic, strong) NSString *profile_image;

/** 发帖时间 */
@property (nonatomic, strong) NSString *create_time;

/** 文字内容 */
@property (nonatomic, strong) NSString *text;

/** 顶的数量 */
@property (nonatomic, assign) NSInteger ding;

/** 踩的数量 */
@property (nonatomic, assign) NSInteger cai;

/** 转发的数量 */
@property (nonatomic, assign) NSInteger repost;

/** 评论的数量 */
@property (nonatomic, assign) NSInteger comment;

/** sina_v */
@property (nonatomic, assign, getter=isSina_v) BOOL sina_v;

/** id */
@property (nonatomic, strong) NSString *ID;

/*
 
 图片相关
 
 */

/** 图片宽度 */
@property (nonatomic, strong) NSString *width;

/** 图片高度 */
@property (nonatomic, strong) NSString *height;

/** smallImage */
@property (nonatomic, strong) NSString *smallImage;

/** midImage */
@property (nonatomic, strong) NSString *midImage;

/** bigImage */
@property (nonatomic, strong) NSString *bigImage;

/*
 
 音视频相关
 
 */

/** 音频长度 */
@property (nonatomic, assign) NSInteger voicetime;

/** 视频长度 */
@property (nonatomic, assign) NSInteger videotime;

/** 播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/** 音频地址 */
@property (nonatomic, strong) NSString *voiceuri;

/*
 
 评论相关
 
 */

/** 评论数组 */
@property (nonatomic, strong) LCCmtItem *top_cmt;

/*
 
 其他辅助信息
 
 */

/** 帖子类型 */
@property (nonatomic, assign) LCTopicType type;

/** 用于存储cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

// 图片帖子相关辅助信息

/** 用于存储图片控件的frame */
@property (nonatomic, assign, readonly) CGRect picFrame;

/** 是否是大图片 */
@property (nonatomic, assign, getter=isBigPic) BOOL bigPic;

/** 图片下载进度 */
@property (nonatomic, assign) CGFloat picProgress;

// 声音帖子相关辅助信息

/** 用于存储声音控件的frame */
@property (nonatomic, assign, readonly) CGRect voiceFrame;
/** 用于标识是否在播放声音 */
@property (nonatomic, assign) BOOL isPlayVoice;

// 视频帖子相关辅助信息

/** 用于存储视频控件的frame */
@property (nonatomic, assign, readonly) CGRect videoFrame;

@end
