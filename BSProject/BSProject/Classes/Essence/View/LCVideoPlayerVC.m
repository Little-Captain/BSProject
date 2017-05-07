//
//  LCVideoPlayerView.m
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCVideoPlayerVC.h"
#import "LCVideoPlayView.h"
//#import "LCTopWindow.h"

#import <Masonry.h>
#import <UIImageView+YYWebImage.h>

@interface LCVideoPlayerVC () <LCVideoPlayViewDelegate>

/** videoPlayView */
@property (nonatomic, weak) LCVideoPlayView *videoPlayView;

@end

@implementation LCVideoPlayerVC

- (LCVideoPlayView *)videoPlayView {
    
    if (!_videoPlayView) {
        LCVideoPlayView *videoPlayView = [LCVideoPlayView videoPlayView];
        videoPlayView.delegate = self;
        [self.view insertSubview:videoPlayView atIndex:0];
        _videoPlayView = videoPlayView;
    }
    
    return _videoPlayView;
} 

static UIWindow *_videoWindow;
+ (void)showWithVideoFrame:(CGRect)videoFrame url:(NSString *)url image:(NSString *)image {
    
    if (!_videoWindow) {
        
        _videoWindow = ({
            UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            window.windowLevel = UIWindowLevelAlert;
            window.rootViewController = ({
                LCVideoPlayerVC *videoVC = [self new];
                videoVC.videoPlayView.containerViewController = videoVC;
                videoVC;
            });
            window;
        });
    }
    LCVideoPlayerVC *rootVC = (LCVideoPlayerVC *)_videoWindow.rootViewController;
    rootVC.videoPlayerViewFrame = videoFrame;
    rootVC.urlStr = url;
    _videoWindow.hidden = NO;
    
//    [LCTopWindow hidden];
}

+ (void)hidden {
    
    if (_videoWindow) {
        
        LCVideoPlayerVC *rootVC = (LCVideoPlayerVC *)_videoWindow.rootViewController;
        [rootVC.videoPlayView suspendnow];
        _videoWindow.hidden = YES;
//        [LCTopWindow show];
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.7];
    
    [self setUpUI];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
}

- (void)setUpUI {
    
    [self.view addSubview:({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        button.frame = CGRectMake(10, 20, [button currentImage].size.width * 2, [button currentImage].size.height * 2);
        button;
    })];
}

- (void)closeBtnClick {
    
    [self tapAction];
}

- (void)tapAction {
    
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
    
    if (!urlStr) return;
    
    if (_urlStr == urlStr) {
        [self.videoPlayView playnow];
        return;
    }
    
    _urlStr = urlStr;
    
    self.videoPlayView.assetToPlay = [AVAsset assetWithURL:[NSURL URLWithString:urlStr]];
    
    [self.videoPlayView playnow];
}

#pragma mark - 屏幕方向支持

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

#pragma mark -
#pragma mark JFVideoPlayViewDelegate
- (void)clickShareButtonInVideoPlayView:(LCVideoPlayView *)videoPlayView {
    
    NSLog(@"分享");
}

@end
