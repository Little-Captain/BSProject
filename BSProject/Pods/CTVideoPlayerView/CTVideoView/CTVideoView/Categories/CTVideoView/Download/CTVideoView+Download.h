//
//  CTVideoView+Download.h
//  CTVideoView
//
//  Created by casa on 16/5/23.
//  Copyright © 2016年 casa. All rights reserved.
//

#import "CTVideoView.h"

@protocol CTVideoPlayerDownloadingViewProtocol;

@interface CTVideoView (Download)

- (void)initDownload;
- (void)deallocDownload;

@property (nonatomic, assign, readonly) BOOL shouldDownloadWhenNotWifi; // set bool value of kCTVideoViewShouldDownloadWhenNotWifi in NSUserDefaults to modify this property, default is NO

@property (nonatomic, weak) id<CTVideoViewDownloadDelegate> downloadDelegate;
@property (nonatomic, strong) UIView<CTVideoPlayerDownloadingViewProtocol> *downloadingView;

- (void)startDownloadTask;
- (void)DeleteAndCancelDownloadTask;
- (void)pauseDownloadTask;

@end

@protocol CTVideoPlayerDownloadingViewProtocol <NSObject>

@optional
- (void)videoViewStartDownload:(CTVideoView *)videoView;
- (void)videoViewFinishDownload:(CTVideoView *)videoView;
- (void)videoViewFailedDownload:(CTVideoView *)videoView;
- (void)videoViewPauseDownload:(CTVideoView *)videoView;
- (void)videoView:(CTVideoView *)videoView progress:(CGFloat)progress;

@end