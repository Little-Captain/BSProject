//
//  JFVideoPlayView.h
//  JFVideoPlayer
//
//  Created by Liu-Mac on 2/10/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//  视频播放器的核心

#import <UIKit/UIKit.h>

@class JFVideoPlayView;

@protocol JFVideoPlayViewDelegate <NSObject>

@optional
- (void)clickBackButtonInVideoPlayView:(JFVideoPlayView *)videoPlayView;
- (void)clickShareButtonInVideoPlayView:(JFVideoPlayView *)videoPlayView;

@end

@interface JFVideoPlayView : UIView

+ (instancetype)videoPlayView;

- (void)launchPlayer;
- (void)suspendPlayer;

/** 需要播放的视频资源地址 */
@property (nonatomic,copy) NSString *urlString;
/* 横屏包含在哪一个控制器中 */
@property (nonatomic, weak) UIViewController *containerViewController;

@property (nonatomic, weak) id<JFVideoPlayViewDelegate> delegate;

/** 原始frame */
@property (nonatomic, assign) CGRect originFrame;

/** bgImageUrl */
@property (nonatomic, strong) NSURL *bgImageUrl;

@end
