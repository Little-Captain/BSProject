//
//  LCVideoPlayView.h
//  LCVideoPlayer
//
//  Created by Liu-Mac on 2/10/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//  视频播放器的核心

#import <UIKit/UIKit.h>
#import <CTVideoViewCommonHeader.h>

@class LCVideoPlayView;

@protocol LCVideoPlayViewDelegate <NSObject>

@optional

- (void)clickBackButtonInVideoPlayView:(LCVideoPlayView *)videoPlayView;

- (void)clickShareButtonInVideoPlayView:(LCVideoPlayView *)videoPlayView;

@end

@interface LCVideoPlayView : CTVideoView

+ (instancetype)videoPlayView;

- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

- (void)playnow;
- (void)suspendnow;

/* 横屏控制器 */
@property (nonatomic, weak) UIViewController *containerViewController;
/** 横屏下的 frame */
@property (nonatomic, assign) CGRect originFrame;

/** 代理对象 */
@property (nonatomic, weak) id<LCVideoPlayViewDelegate> delegate;


@end
