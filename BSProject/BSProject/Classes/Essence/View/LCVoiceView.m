//
//  LCVoiceView.m
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCVoiceView.h"
#import "LCTopicItem.h"
#import "LCPictureViewController.h"
#import "LCVoicePlayerView.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>

@interface LCVoiceView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *playCountL;

@property (weak, nonatomic) IBOutlet UILabel *voiceLengthL;

/** player */
@property (nonatomic, strong) AVPlayer *player;


@end

@implementation LCVoiceView

- (AVPlayer *)player {
    
    if (!_player) {
        AVAsset *asset = [AVAsset assetWithURL:[NSURL URLWithString:self.item.voiceuri]];
        AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
        _player = [AVPlayer playerWithPlayerItem:item];
        [_player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        NSLog(@"%zd", asset.duration.value);
        NSLog(@"%zd", asset.duration.timescale);
    }
    
    return _player;
}

+ (instancetype)voiceView {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClick)];
    [self.imageV addGestureRecognizer:tap];
}

- (void)pictureClick {
    
    LCPictureViewController *pictureVC = [[LCPictureViewController alloc] init];
    pictureVC.topicItem = self.item;
    [KeyWindow.rootViewController presentViewController:pictureVC animated:YES completion:nil];
    
}

- (void)setItem:(LCTopicItem *)item {
    
    _item = item;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:item.bigImage]];
    self.playCountL.text = [NSString stringWithFormat:@"%zd次播放", item.playcount];
    self.voiceLengthL.text = [NSString stringWithFormat:@"%02zd:%02zd", item.voicetime / 60, item.voicetime % 60];
}
- (IBAction)playBtnClick:(UIButton *)sender {
    
    [self.player play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if ([change[NSKeyValueChangeNewKey] integerValue] == AVPlayerStatusReadyToPlay) {
        NSLog(@"准备播放");
        LCVoicePlayerView *voicePlayerView = [LCVoicePlayerView viewFromXib];
        voicePlayerView.player = self.player;
        voicePlayerView.totalTime = self.item.voicetime;
        [self addSubview:voicePlayerView];
    
        [voicePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(voicePlayerView.superview);
            make.left.equalTo(voicePlayerView.superview);
            make.bottom.equalTo(voicePlayerView.superview);
            make.height.equalTo(@(65));
        }];
    }
}

@end
