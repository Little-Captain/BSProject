//
//  LCVoicePlayerView.m
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCVoicePlayerView.h"
#import "LCTopicItem.h"
#import "LCVoicePlayerTool.h"
#import <AVFoundation/AVFoundation.h>
#import <Masonry.h>

@interface LCVoicePlayerView ()

/** 进度滑块 */
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
/** 当前时间的 label */
@property (weak, nonatomic) IBOutlet UILabel *currentTimeL;
/** 总时间的 label */
@property (weak, nonatomic) IBOutlet UILabel *totalTimeL;
/** 播放或暂停的按钮 */
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;

@end

@implementation LCVoicePlayerView {
    
    // 定时器, 用于更新时间的显示和进度的显示
    NSTimer *_timer;
}

#pragma mark -
#pragma mark 重写系统方法
- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 设置滑块的显示风格
    [_progressSlider setThumbImage:[UIImage imageNamed:@"roundSlider"] forState:UIControlStateNormal];
    [_progressSlider setMaximumTrackImage:[UIImage imageNamed:@"maxthumb"] forState:UIControlStateNormal];
    [_progressSlider setMinimumTrackImage:[UIImage imageNamed:@"minthumb"] forState:UIControlStateNormal];
    
    // 监听耳机的插拔事件
    // 通知的回调的调用线程 : 回调函数在通知的发送线程中调用
    // 通知在那个线程发送, 回调函数就在那个线程中调用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
}

/** AVAudioSessionRouteChangeNotification 的发送线程 就是 回调函数 的 调用线程 */
- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    
    NSDictionary *interuptionDict = notification.userInfo;
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            NSLog(@"AVAudioSessionRouteChangeReasonNewDeviceAvailable");
            NSLog(@"耳机插入");
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
            NSLog(@"AVAudioSessionRouteChangeReasonOldDeviceUnavailable");
            NSLog(@"耳机拔出，停止播放操作");
            if (_playOrPauseBtn.selected && !(self.hidden)) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self playOrPauseClick:_playOrPauseBtn];
                });
            }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}

#pragma mark -
#pragma mark 监听属性的设置

- (void)setItem:(LCTopicItem *)item {
    
    _item = item;
    
    if (!item) { return; }
    
    _currentTimeL.text = @"00:00";
    // 设置总时间
    _totalTimeL.text = [NSString musicTimeFormater:item.voicetime];
    // 替换播放的资源
    [LCVoicePlayerTool sharedInstance].urlStr = item.voiceuri;
    // 启动定时器
    [self addTimer];
}

#pragma mark -
#pragma mark 定时器相关

/** 添加定时器 */
- (void)addTimer {
    
    _timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (![LCVoicePlayerTool sharedInstance].currentTime.timescale || !_item.voicetime) {
            return;
        }
        // 更新播放时间
        NSInteger currentTime = (NSInteger)([LCVoicePlayerTool sharedInstance].currentTime.value / [LCVoicePlayerTool sharedInstance].currentTime.timescale);
        _currentTimeL.text = [NSString musicTimeFormater:currentTime];
        // 更新滑块的位置
        _progressSlider.value = 1.0 * currentTime / _item.voicetime;
    }];
    // 加入 runloop
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    // 启动定时器
    [_timer fire];
}

/** 移除定时器 */
- (void)removeTimer {
    
    // 定时器失效
    [_timer invalidate];
    // 置空定时器
    _timer = nil;
}

#pragma mark -
#pragma mark 事件监听

/** 播放或暂停点击 */
- (IBAction)playOrPauseClick:(UIButton *)sender {
    
    // 改变按钮状态
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        // 开始播放
        [[LCVoicePlayerTool sharedInstance].player play];
        // 添加定时器
        [self addTimer];
    } else {
        // 设置播放器按钮
        sender.selected = NO;
        // 暂停播放
        [[LCVoicePlayerTool sharedInstance].player pause];
        // 移除定时器
        [self removeTimer];
    }
}

/** 滑块被点击 */
- (IBAction)touchDown {
    
    // 移除定时器
    [self removeTimer];
}

/** 滑块值改变事件 */
- (IBAction)valueChange {
    
    // 更新当前播放显示时间
    // 设置当前时间
    _currentTimeL.text = [NSString musicTimeFormater:_progressSlider.value * _item.voicetime];
}

/** 手指弹开事件 */
- (IBAction)touchUpInside {
    
    // 更新播放器的播放时间
    [[LCVoicePlayerTool sharedInstance].player seekToTime:CMTimeMakeWithSeconds(_progressSlider.value * _item.voicetime, [LCVoicePlayerTool sharedInstance].currentTime.timescale) completionHandler:^(BOOL finished) {
        // 判断如果定时器没有值且当前出在播放状态, 则添加定时器
        if (!_timer && _playOrPauseBtn.isSelected) {
            [self addTimer];
        }
    }];
    
}

/** 监听用户的点击滑块手势 */
- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    // 移除定时器
    [self removeTimer];
    
    // 获取点击比例
    CGPoint point = [sender locationInView:sender.view];
    float ratio = 1.0 * point.x / _progressSlider.bounds.size.width;
    
    // 设置播放器的播放时间
    [[LCVoicePlayerTool sharedInstance].player seekToTime:CMTimeMakeWithSeconds(ratio * _item.voicetime, [LCVoicePlayerTool sharedInstance].currentTime.timescale) completionHandler:^(BOOL finished) {
        // 判断如果定时器没有值且当前出在播放状态, 则添加定时器
        if (!_timer && _playOrPauseBtn.isSelected) {
            [self addTimer];
        }
    }];
    
    // 更新滑块的位置以及播放显示时间
    _progressSlider.value = ratio;
    _currentTimeL.text = [NSString musicTimeFormater:ratio * _item.voicetime];
}

- (void)setHidden:(BOOL)hidden {
    
    [super setHidden:hidden];
    
    if (!hidden) {
        _currentTimeL.text = @"00:00";
        _progressSlider.value = 0.0;
    }
}

@end
