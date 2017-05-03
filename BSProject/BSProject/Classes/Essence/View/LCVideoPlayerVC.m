//
//  LCVideoPlayerView.m
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCVideoPlayerVC.h"
#import "JFVideoPlayView.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface LCVideoPlayerVC () <JFVideoPlayViewDelegate>

/** videoPlayView */
@property (nonatomic, weak) JFVideoPlayView *videoPlayView;

@end

@implementation LCVideoPlayerVC

- (JFVideoPlayView *)videoPlayView {
    
    if (!_videoPlayView) {
        JFVideoPlayView *videoPlayView = [JFVideoPlayView videoPlayView];
        videoPlayView.delegate = self;
        [self.view addSubview:videoPlayView];
        _videoPlayView = videoPlayView;
    }
    
    return _videoPlayView;
} 

static UIWindow *_videoWindow;
+ (void)showWithVideoFrame:(CGRect)videoFrame url:(NSString *)url image:(NSString *)image {
    
    if (!_videoWindow) {
        
        _videoWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _videoWindow.windowLevel = UIWindowLevelAlert;
        LCVideoPlayerVC *videoVC = [self new];
        videoVC.videoPlayView.containerViewController = videoVC;
        _videoWindow.rootViewController = videoVC;
    }
    LCVideoPlayerVC *rootVC = (LCVideoPlayerVC *)_videoWindow.rootViewController;
    rootVC.videoPlayerViewFrame = videoFrame;
    [rootVC.videoPlayView.videoImageV sd_setImageWithURL:[NSURL URLWithString:image]];
    rootVC.urlStr = url;
    _videoWindow.hidden = NO;
}

+ (void)hidden {
    
    if (_videoWindow) {
        
        LCVideoPlayerVC *rootVC = (LCVideoPlayerVC *)_videoWindow.rootViewController;
        [rootVC.videoPlayView suspendPlayer];
        _videoWindow.hidden = YES;
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    [LCVideoPlayerVC hidden];
}

- (void)setVideoPlayerViewFrame:(CGRect)videoPlayerViewFrame {
    
    _videoPlayerViewFrame = videoPlayerViewFrame;
    _videoPlayView.originFrame = videoPlayerViewFrame;
    
    [self.videoPlayView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.videoPlayView.superview.mas_left).offset(videoPlayerViewFrame.origin.x);
        make.top.equalTo(self.videoPlayView.superview.mas_top).offset(videoPlayerViewFrame.origin.y);
        make.width.equalTo(@(videoPlayerViewFrame.size.width));
        make.height.equalTo(@(videoPlayerViewFrame.size.height));
    }];
}

- (void)setUrlStr:(NSString *)urlStr {
    
    _urlStr = urlStr;
    
    self.videoPlayView.urlString = urlStr;
}

#pragma mark - 屏幕方向支持

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    return YES;
}

#pragma mark -
#pragma mark JFVideoPlayViewDelegate

- (void)clickBackButtonInVideoPlayView:(JFVideoPlayView *)videoPlayView {
    
    NSLog(@"返回");
}
- (void)clickShareButtonInVideoPlayView:(JFVideoPlayView *)videoPlayView {
    
    NSLog(@"分享");
}

@end
