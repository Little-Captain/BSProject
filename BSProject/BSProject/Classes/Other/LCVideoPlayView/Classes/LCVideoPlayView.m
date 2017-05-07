//
//  LCVideoPlayView.m
//  LCVideoPlayer
//
//  Created by Liu-Mac on 2/10/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCVideoPlayView.h"
#import "NSBundle+LCVideoPlayer.h"
#import "LCFullVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>

@interface LCVideoPlayView () <CTVideoViewTimeDelegate, CTVideoViewPlayControlDelegate>

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

/** 播放控制栏 */
@property (weak, nonatomic) IBOutlet UIView *playCtrlBar;
/** 评论按钮 */
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
/** 弹幕按钮 */
@property (weak, nonatomic) IBOutlet UIButton *barrageBtn;
/** 播放控制栏的mask */
@property (weak, nonatomic) IBOutlet UIImageView *playMaskingImageV;
/** 播放或暂停按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
/** 全屏按钮 */
@property (weak, nonatomic) IBOutlet UIButton *fullScreenBtn;
/** 当前时间标签 */
@property (weak, nonatomic) IBOutlet UILabel *currentTime;
/** 总时间标签 */
@property (weak, nonatomic) IBOutlet UILabel *totalTime;


/** 进度控制滑条 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 底部进度条 */
@property (weak, nonatomic) IBOutlet UIProgressView *progressV;

/** 记录当前是否显示了工具栏 */
@property (nonatomic,assign) BOOL isShowingBarAndCtrlView;
/** 记录上一次的状态栏显示状态 */
@property (nonatomic, assign) BOOL isShowingBarAndCtrlViewOfLast;

/* 全屏控制器, 全屏时, 视图将被添加到这个控制器上 */
@property (nonatomic, strong) LCFullVC *fullVc;

/** 视图显示隐藏定时器 */
@property (nonatomic, weak) NSTimer *showTimer;
/** 视图显示的时间 */
@property (assign, nonatomic) NSTimeInterval showTime;

/** 标记是否正在滑动 */
@property (nonatomic, assign) BOOL isSliding;

@property (weak, nonatomic) IBOutlet UIButton *coverBtn;

@end

@implementation LCVideoPlayView

#pragma mark -
#pragma mark 懒加载

- (LCFullVC *)fullVc {
    
    if (!_fullVc) {
        _fullVc = [[LCFullVC alloc] init];
    }
    
    return _fullVc;
}

#pragma mark -
#pragma mark 类工厂方法

+ (instancetype)videoPlayView {
    
    // .bundle .framework 都是 bundle!!!
    return [[NSBundle videoPlayerFramework] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
}

#pragma mark -
#pragma mark 初始化设置

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setUpImages];

    // 将工具条的显示状态设置为NO
    self.isShowingBarAndCtrlViewOfLast = YES;
    self.isShowingBarAndCtrlView = NO;
    
    // 添加点击手势
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)]];
    
    [self setUpPlayer];
}

/** 设置播放相关属性 */
- (void)setUpPlayer {

    self.shouldReplayWhenFinish = NO;
    self.timeDelegate = self;
    self.playControlDelegate = self;
    [self setShouldObservePlayTime:YES withTimeGapToObserve:33.0f];
}

/** 设置图片 */
- (void)setUpImages {
    
    // 设置 share bar 的图片
    [self.backBtn setImage:[NSBundle imageOfUINavBarItemBack1] forState:UIControlStateNormal];
    [self.shareBtn setImage:[NSBundle imageOfUINavBarItemShare1] forState:UIControlStateNormal];
    UIImage *shareMaskImage = [NSBundle imageOfvideoMaskTop];
    self.shareMaskImageV.image = [shareMaskImage resizableImageWithCapInsets:UIEdgeInsetsMake(shareMaskImage.size.height * 0.5, shareMaskImage.size.width * 0.5, shareMaskImage.size.height * 0.5 - 1, shareMaskImage.size.width * 0.5 - 1)];
    
    // 设置中间播放按钮的图片 bannerVideoPlay
    [self.centerPlayBtn setImage:[NSBundle imageOfbannerVideoPlay] forState:UIControlStateNormal];
    
    // 设置 play ctrl bar 上的图片
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
    
    // 设置 cover 上的 按钮的 图片
    [self.coverBtn setImage:[NSBundle imageOfvideoReplay] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark cover button 控制

- (void)showCoverBtn {
    
    [self pause];
    self.coverBtn.hidden = NO;
    self.isSlideFastForwardDisabled = YES;
    self.isSlideToChangeVolumeDisabled = YES;
    self.progressSlider.userInteractionEnabled = NO;
    self.playOrPauseBtn.userInteractionEnabled = NO;
}

- (void)hideCoverBtn {
    
    self.coverBtn.hidden = YES;
    self.isSlideFastForwardDisabled = NO;
    self.isSlideToChangeVolumeDisabled = NO;
    self.progressSlider.userInteractionEnabled = YES;
    self.playOrPauseBtn.userInteractionEnabled = YES;
}

#pragma mark -
#pragma mark CTVideoViewTimeDelegate

- (void)videoView:(CTVideoView *)videoView didPlayToSecond:(CGFloat)second {
    
    if (second <= 0) return;
    
    NSInteger sec = (NSInteger)round(second);

    _currentTime.text = [NSString stringWithFormat:@"%02zd:%02zd", sec / 60, sec % 60];
    
    CGFloat duration = CMTimeGetSeconds(self.assetToPlay.duration);
    _progressV.progress = second / duration;
    
    if (!_isSliding) {
        _progressSlider.value = _progressV.progress;
    }
    
    if (second >= duration) {
        [self showCoverBtn];
    }
}

#pragma mark -
#pragma mark CTVideoViewPlayControlDelegate

- (void)videoViewShowPlayControlIndicator:(CTVideoView *)videoView {}

- (void)videoViewHidePlayControlIndicator:(CTVideoView *)videoView {}

- (void)videoView:(CTVideoView *)videoView playControlDidMoveToSecond:(CGFloat)second direction:(CTVideoViewPlayControlDirection)direction {
    
    _progressSlider.value = second / CMTimeGetSeconds(self.assetToPlay.duration);
}

#pragma mark - setter

- (void)setAssetToPlay:(AVAsset *)assetToPlay {
    
    [super setAssetToPlay:assetToPlay];
    
    _currentTime.text = @"00:00";
    _progressSlider.value = 0;
    _progressV.progress = 0;
    NSInteger sec = CMTimeGetSeconds(assetToPlay.duration);
    _totalTime.text = [NSString stringWithFormat:@"%02zd:%02zd", sec / 60, sec % 60];
}

#pragma mark - 是否显示 share bar 和 play ctrl bar

- (void)tapAction {

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
        self.playCtrlBar.alpha = 1;
        self.progressSlider.alpha = 1;
        self.progressV.alpha = 0;
    } completion:^(BOOL finished) {
        self.isShowingBarAndCtrlView = YES;
        self.isShowingBarAndCtrlViewOfLast = NO;
    }];
}

- (void)hiddenBarAndCtrlView {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shareBar.alpha = 0;
        self.playCtrlBar.alpha = 0;
        self.progressSlider.alpha = 0;
        self.progressV.alpha = 1;
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
    
    if (self.showTime >= 5.0) {
        
        [self tapAction];
        self.showTime = 0;
    }
}

#pragma mark -
#pragma mark 顶部工具条按钮

- (IBAction)backBtnClick {
    
    if (_fullScreenBtn.isSelected) {
        [self switchOrientation:_fullScreenBtn];
    }
    
    if ([_delegate respondsToSelector:@selector(clickBackButtonInVideoPlayView:)]) {
        [_delegate clickBackButtonInVideoPlayView:self];
    }
}

- (IBAction)shareBtnClick {
    
    if ([_delegate respondsToSelector:@selector(clickShareButtonInVideoPlayView:)]) {
        [_delegate clickShareButtonInVideoPlayView:self];
    }
}

#pragma mark - 
#pragma mark 播放控制

- (void)playnow {
    
    if (!self.isPlaying) {
        [self hideCoverBtn];
        _isSliding = NO;
        [self centerBtnClick:nil];
    }
}

- (void)suspendnow {
    
    if (self.isPlaying) {
        [self playOrPause:_playOrPauseBtn];
    }
}

/** 中间播放按钮的监听 */
- (IBAction)centerBtnClick:(UIButton *)sender {
    
    [self play];
    self.centerPlayBtn.hidden = YES;
    self.playOrPauseBtn.selected = YES;
    [self tapAction];
}

/** 播放暂停按钮的监听 */
- (IBAction)playOrPause:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        
        [self play];
        self.centerPlayBtn.hidden = YES;
    } else {
        
        [self pause];
        self.centerPlayBtn.hidden = NO;
    }
}

#pragma mark - 对滑块的处理

- (IBAction)slided {

    NSTimeInterval currentTime = CMTimeGetSeconds(self.assetToPlay.duration) * _progressSlider.value;
    [self moveToSecond:currentTime shouldPlay:YES];
    
    _isSliding = NO;
    [self addShowTimer];
}

- (IBAction)sliding {
    
    NSTimeInterval currentTime = CMTimeGetSeconds(self.assetToPlay.duration) * _progressSlider.value;
    _currentTime.text = [NSString stringWithFormat:@"%02zd:%02zd", (NSInteger)(currentTime) / 60, (NSInteger)(currentTime) % 60];
    [self moveToSecond:currentTime shouldPlay:NO];
}

- (IBAction)startSlide {
    
    _isSliding = YES;
    [self removeShowTimer];
}

#pragma mark -
#pragma mark 重新播放按钮的监听

- (IBAction)replayBtnClick {
    
    [self replay];
    [self hideCoverBtn];
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
