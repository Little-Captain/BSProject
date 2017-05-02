//
//  LCVoicePlayerView.m
//  BSProject
//
//  Created by Liu-Mac on 5/2/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCVoicePlayerView.h"
#import <Masonry.h>

@interface LCVoicePlayerView ()

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeL;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeL;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;

@end

@implementation LCVoicePlayerView {
    
    NSTimer *_timer;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [_progressSlider setThumbImage:[UIImage imageNamed:@"roundSlider"] forState:UIControlStateNormal];
    [_progressSlider setMaximumTrackImage:[UIImage imageNamed:@"maxthumb"] forState:UIControlStateNormal];
    [_progressSlider setMinimumTrackImage:[UIImage imageNamed:@"minthumb"] forState:UIControlStateNormal];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSLog(@"%zd", self.player.currentTime.value/self.player.currentTime.timescale);
    NSLog(@"%zd", self.player.currentItem.duration.value/self.player.currentItem.duration.timescale);
}

- (void)setPlayer:(AVPlayer *)player {
    
    _player = player;
    
    // 启动定时器更新时间和定时器显示
    [self addTimer];
}

- (void)setTotalTime:(NSInteger)totalTime {
    
    _totalTime = totalTime;
    
    // 设置总时间
    _totalTimeL.text = [NSString musicTimeFormater:totalTime];
}

#pragma mark -
#pragma mark 定时器相关

- (void)addTimer {
    
    _timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (!_player.currentTime.timescale || !_totalTime) {
            return;
        }
        // 更新播放时间
        NSInteger currentTime = _player.currentTime.value / _player.currentTime.timescale;
        _currentTimeL.text = [NSString musicTimeFormater:currentTime];
        // 更新滑块的位置
        _progressSlider.value = 1.0 * currentTime / _totalTime;
    }];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    // 启动定时器
    [_timer fire];
}

- (void)removeTimer {
    
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -
#pragma mark 事件监听

- (IBAction)playOrPauseClick:(UIButton *)sender {
    
    // 改变按钮状态
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        // 开始播放
        [_player play];
        // 添加定时器
        [self addTimer];
    } else {
        // 设置播放器按钮
        sender.selected = NO;
        // 暂停播放
        [_player pause];
        // 移除定时器
        [self removeTimer];
    }
}

// 滑块被点击
- (IBAction)touchDown {
    
    // 移除定时器
    [self removeTimer];
}

// 值改变事件
- (IBAction)valueChange {
    
    // 更新当前播放显示时间
    // 设置当前时间
    _currentTimeL.text = [NSString musicTimeFormater:_progressSlider.value * _totalTime];
}

// 手指弹开事件
- (IBAction)touchUpInside {
    
    // 更新播放器的播放时间
    [_player seekToTime:CMTimeMakeWithSeconds(_progressSlider.value * _totalTime, _player.currentTime.timescale) completionHandler:^(BOOL finished) {
        // 判断如果定时器没有值,则添加定时器
        if (!_timer && _playOrPauseBtn.isSelected) {
            [self addTimer];
        }
    }];
    
}

- (IBAction)tapClick:(UITapGestureRecognizer *)sender {
    
    [self removeTimer];
    
    // 获取点击比例
    CGPoint point = [sender locationInView:sender.view];
    float ratio = 1.0 * point.x / _progressSlider.bounds.size.width;
    
    // 设置播放器的播放时间
    [_player seekToTime:CMTimeMakeWithSeconds(ratio * _totalTime, _player.currentTime.timescale) completionHandler:^(BOOL finished) {
        // 判断如果定时器没有值,则添加定时器
        if (!_timer && _playOrPauseBtn.isSelected) {
            [self addTimer];
        }
    }];
    
    // 更新滑块的位置以及播放显示时间
    _progressSlider.value = ratio;
    _currentTimeL.text = [NSString musicTimeFormater:ratio * _totalTime];
}

@end
