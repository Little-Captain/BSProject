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
#import <Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <UIImageView+YYWebImage.h>

@interface LCVoiceView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *playCountL;

@property (weak, nonatomic) IBOutlet UILabel *voiceLengthL;

@end

@implementation LCVoiceView

+ (instancetype)voiceView {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.imageV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pictureClick)];
    [self.imageV addGestureRecognizer:tap];
    
    [self setUpUI];
}

- (void)setUpUI {
    
    LCVoicePlayerView *voicePlayerView = ({
        LCVoicePlayerView *voicePlayerView = [LCVoicePlayerView viewFromXib];
        voicePlayerView.hidden = YES;
        voicePlayerView;
    });
    [self addSubview:voicePlayerView];
    __weak typeof(voicePlayerView) weakVoicePlayerView = voicePlayerView;
    [voicePlayerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakVoicePlayerView.superview);
        make.right.equalTo(weakVoicePlayerView.superview);
        make.bottom.equalTo(weakVoicePlayerView.superview);
        make.height.equalTo(@(65));
    }];
    self.voicePlayerView = voicePlayerView;
}

- (void)pictureClick {   
    
    [KeyWindow.rootViewController presentViewController:({
        LCPictureViewController *pictureVC = [[LCPictureViewController alloc] init];
        pictureVC.topicItem = self.item;
        pictureVC;
    }) animated:YES completion:nil];
    
}

- (void)setItem:(LCTopicItem *)item {
    
    _item = item;
    
    [self.imageV yy_setImageWithURL:[NSURL URLWithString:item.bigImage] placeholder:nil];
    self.playCountL.text = [NSString stringWithFormat:@"%zd次播放", item.playcount];
    self.voiceLengthL.text = [NSString stringWithFormat:@"%02zd:%02zd", item.voicetime / 60, item.voicetime % 60];
}
- (IBAction)playBtnClick:(UIButton *)sender {
    
    // 设置 播放状态
    self.item.isPlayVoice = YES;
    // 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:VoicePlayBtnClickNotification object:nil userInfo:@{@"info": self.item}];
}

@end
