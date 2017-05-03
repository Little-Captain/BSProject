//
//  JFVideoPlayView.m
//  JFVideoPlayer
//
//  Created by Liu-Mac on 2/10/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "JFVideoPlayView.h"
#import "JFFullVC.h"
#import "NSBundle+JFVideoPlayer.h"
#import "Masonry.h"
#import <AVFoundation/AVFoundation.h>

@interface JFVideoPlayView ()

/** 分享栏 */
@property (weak, nonatomic) IBOutlet UIView *shareBar;
/** 返回按钮 */
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
/** 分享按钮 */
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
/** 分享栏的mask */
@property (weak, nonatomic) IBOutlet UIImageView *shareMaskImageV;

/** 中心的播放按钮 */
@property (weak, nonatomic) IBOutlet UIButton *centerPlayBtn;
/** 播放控制视图 */
@property (weak, nonatomic) IBOutlet UIView *playCtrlV;
/** 播放控制栏的mask */
@property (weak, nonatomic) IBOutlet UIImageView *playMaskingImageV;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *barrageBtn;
/** 播放或暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
/** 全屏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;
/** 当前时间标签 */
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
/** 总时间标签 */
@property (weak, nonatomic) IBOutlet UILabel *totalTime;
/** 进度条 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 底部进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;

/** 播放器 */
@property (nonatomic, strong) AVPlayer *player;
/** 播放器的Layer */
@property (nonatomic,strong) AVPlayerLayer *playerLayer;
/** playItem */
@property (nonatomic,strong) AVPlayerItem *playerItem;
/** 记录当前是否显示了工具栏 */
@property (nonatomic,assign) BOOL isShowingBarAndCtrlView;
/** 记录上一次的状态栏显示状态 */
@property (nonatomic, assign) BOOL isShowingBarAndCtrlViewOfLast;
/* 全屏控制器 */
@property (nonatomic, strong) JFFullVC *fullVc;
/* 定时器 */
@property (nonatomic, weak) NSTimer *progressTimer;
/** 视图显示隐藏定时器 */
@property (nonatomic, weak) NSTimer *showTimer;
/* 视图显示的时间 */
@property (assign, nonatomic) NSTimeInterval showTime;

@end

@implementation JFVideoPlayView

- (JFFullVC *)fullVc {
    
    if (!_fullVc) {
        _fullVc = [[JFFullVC alloc] init];
    }
    
    return _fullVc;
    
}

+ (instancetype)videoPlayView {
    
    // .bundle .framework 都是 bundle!!!
    JFVideoPlayView *videoPlayView = [[NSBundle videoPlayerFramework] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    
    return videoPlayView;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 初始化Player
    self.player = [[AVPlayer alloc] init];
    // 初始化PlayerLayer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    // 将PlayerLayer添加到图片的layer层
    [self.videoImageV.layer addSublayer:self.playerLayer];
    // 设置控制栏和分享栏的透明度, 默认不显示
//    self.shareBar.alpha = 0;
//    self.playCtrlV.alpha = 0;
    // 将工具条的显示状态设置为NO
    self.isShowingBarAndCtrlViewOfLast = YES;
    self.isShowingBarAndCtrlView = NO;
    
    // 设置share bar 的图片
    [self.backBtn setImage:[NSBundle imageOfUINavBarItemBack1] forState:UIControlStateNormal];
    [self.shareBtn setImage:[NSBundle imageOfUINavBarItemShare1] forState:UIControlStateNormal];
    UIImage *shareMaskImage = [NSBundle imageOfvideoMaskTop];
    self.shareMaskImageV.image = [shareMaskImage resizableImageWithCapInsets:UIEdgeInsetsMake(shareMaskImage.size.height * 0.5, shareMaskImage.size.width * 0.5, shareMaskImage.size.height * 0.5 - 1, shareMaskImage.size.width * 0.5 - 1)];
    // 设置中间播放按钮的图片 bannerVideoPlay
    [self.centerPlayBtn setImage:[NSBundle imageOfbannerVideoPlay] forState:UIControlStateNormal];
    // 设置 play ctrl view 上的图片
    UIImage *ctrlMaskImage = [NSBundle imageOfbannerVideoMask];
    self.playMaskingImageV.image = [ctrlMaskImage resizableImageWithCapInsets:UIEdgeInsetsMake(ctrlMaskImage.size.height * 0.5, ctrlMaskImage.size.width * 0.5, ctrlMaskImage.size.height * 0.5 - 1, ctrlMaskImage.size.width * 0.5 - 1)];
    [self.commitBtn setImage:[NSBundle imageOfvideoSend] forState:UIControlStateNormal];
    [self.barrageBtn setImage:[NSBundle imageOfvideoBarrage] forState:UIControlStateNormal];
    [self.playOrPauseBtn setImage:[NSBundle imageOfvideoPlay] forState:UIControlStateNormal];
    [self.playOrPauseBtn setImage:[NSBundle imageOfvideoPause] forState:UIControlStateSelected];
    [self.fullScreenBtn setImage:[NSBundle imageOfvideoFullScreen] forState:UIControlStateNormal];
    [self.fullScreenBtn setImage:[NSBundle imageOfvideoNotFullScreen] forState:UIControlStateSelected];
    // 设置 slider 上的图片
    [self.progressSlider setThumbImage:[NSBundle imageOfroundSlider] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[NSBundle imageOfmaxthumb] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[NSBundle imageOfminthumb] forState:UIControlStateNormal];
    
    // 设置按钮的状态(设置为播放状态)
    self.playOrPauseBtn.selected = YES;
}

#pragma mark - 重新布局

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 设置playerLayer的frame
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 启动播放器

- (void)launchPlayer {
    
    [self centerBtnClick:self.centerPlayBtn];
}

#pragma mark - 挂起控制器

- (void)suspendPlayer {
    
    self.playOrPauseBtn.selected = YES;
    [self playOrPause:self.playOrPauseBtn];
}

#pragma mark - 设置播放的视频

- (void)setUrlString:(NSString *)urlString {
    
    if ([urlString isEqualToString:_urlString]) {
        [self launchPlayer];
        return;
    }
    
    // 1.保存视频资源字符串
    _urlString = urlString;
    // 2.创建PlayerItem
    NSURL *url = [NSURL URLWithString:urlString];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    self.playerItem = item;
    // 3.切换到当前的playerItem
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    [self launchPlayer];
}

#pragma mark - 返回按钮点击

- (IBAction)backBtnClick {
    
    if (self.fullScreenBtn.isSelected) {
        [self switchOrientation:self.fullScreenBtn];
    }
    if ([self.delegate respondsToSelector:@selector(clickBackButtonInVideoPlayView:)]) {
        [self.delegate clickBackButtonInVideoPlayView:self];
    }
}
- (IBAction)shareBtnClick {
    
    if ([self.delegate respondsToSelector:@selector(clickShareButtonInVideoPlayView:)]) {
        [self.delegate clickShareButtonInVideoPlayView:self];
    }
}

#pragma mark - 是否显示 share bar 和 play ctrl view

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {

    if (self.isShowingBarAndCtrlViewOfLast == self.isShowingBarAndCtrlView) {
        return;
    }
    self.isShowingBarAndCtrlViewOfLast = self.isShowingBarAndCtrlView;
    
    if (!self.isShowingBarAndCtrlView) { // 没显示
        [self showBarAndCtrlView];
        [self addShowTimer];
    } else {
        [self hiddenBarAndCtrlView];
        [self removeShowTimer];
    }
}

- (void)showBarAndCtrlView {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shareBar.alpha = 1;
        self.playCtrlV.alpha = 1;
    } completion:^(BOOL finished) {
        self.isShowingBarAndCtrlView = YES;
        self.isShowingBarAndCtrlViewOfLast = NO;
    }];
}

- (void)hiddenBarAndCtrlView {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shareBar.alpha = 0;
        self.playCtrlV.alpha = 0;
    } completion:^(BOOL finished) {
        self.isShowingBarAndCtrlView = NO;
        self.isShowingBarAndCtrlViewOfLast = YES;
    }];
}

#pragma mark - 视图显示隐藏控制的定时器

- (void)addShowTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateShowTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.showTimer = timer;
}

- (void)removeShowTimer {
    
    [self.showTimer invalidate];
    self.showTimer = nil;
}

- (void)updateShowTime {
    
    self.showTime += 1;
    
    if (self.showTime >= 10.0) {
        
        [self tapAction:nil];
        self.showTime = 0;
    }
}

#pragma mark - 中间播放按钮的监听

- (IBAction)centerBtnClick:(UIButton *)sender {
    
    [self.player play];
    self.centerPlayBtn.hidden = YES;
    self.playOrPauseBtn.selected = YES;
    [self addProgressTimer];
    [self tapAction:nil];
}


#pragma mark -  暂停按钮的监听

- (IBAction)playOrPause:(UIButton *)sender {

    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [self.player play];
        self.centerPlayBtn.hidden = YES;
        [self addProgressTimer];
    } else {
        
        [self.player pause];
        self.centerPlayBtn.hidden = NO;
        [self removeProgressTimer];
    }
}

#pragma mark - 定时器操作
- (void)addProgressTimer {
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.progressTimer = timer;
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)updateProgressInfo
{
    // 1.更新时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    self.currentTime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)(currentTime) / 60, (NSInteger)(currentTime) % 60];
    NSTimeInterval maxTime = CMTimeGetSeconds(self.player.currentItem.duration);
    if (maxTime >= 0 && maxTime <= 6000) {
        self.totalTime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)(maxTime) / 60, (NSInteger)(maxTime) % 60];
    } else {
        self.totalTime.text = [NSString stringWithFormat:@"%02zd:%02zd", 0, 0];
    }
    // 2.更新滑块
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    self.progressV.progress = self.progressSlider.value;
}

#pragma mark - 对滑块的处理
- (IBAction)slided {
    [self addProgressTimer];
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (IBAction)startSlide {
    [self removeProgressTimer];
}

- (IBAction)sliding {
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    self.currentTime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)(currentTime) / 60, (NSInteger)(currentTime) % 60];
    if (duration >= 0 && duration <= 6000) {
        self.totalTime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)(duration) / 60, (NSInteger)(duration) % 60];
    } else {
        self.totalTime.text = [NSString stringWithFormat:@"%02zd:%02zd", 0, 0];
    }
}

#pragma mark - 切换屏幕的方向

- (IBAction)switchOrientation:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [self videoplayViewSwitchOrientation:sender.selected];
}

- (void)videoplayViewSwitchOrientation:(BOOL)isFull {
    
    if (isFull) { // 从非全屏切换到全屏
        // 解决约束警告
        // 删除 self 相关的所有原始布局约束
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {}];
        // 需要更新布局
        [self setNeedsLayout];
        // 更新布局
        [self layoutIfNeeded];
        // 全屏控制器是modal出来的!!!
        [self.containerViewController presentViewController:self.fullVc animated:NO completion:^{
            
            [self.fullVc.view addSubview:self];
            
            // 重新设置布局约束
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.superview.mas_left);
                make.right.equalTo(self.superview.mas_right);
                make.top.equalTo(self.superview.mas_top);
                make.bottom.equalTo(self.superview.mas_bottom);
            }];
            [self setNeedsLayout];
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                [self layoutIfNeeded];
            } completion:nil];
        }];
    } else { // 从全屏切换到非全屏
        
        [self.fullVc dismissViewControllerAnimated:NO completion:^{
            
            [self.containerViewController.view addSubview:self];
            
            [self mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.superview.mas_left).offset(self.originFrame.origin.x);
                make.top.equalTo(self.superview.mas_top).offset(self.originFrame.origin.y);
                make.width.equalTo(@(self.originFrame.size.width));
                make.height.equalTo(@(self.originFrame.size.height));
            }];
            [self setNeedsLayout];
            [UIView animateWithDuration:0.15 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                [self layoutIfNeeded];
            } completion:nil];
        }];
    }
}

@end
