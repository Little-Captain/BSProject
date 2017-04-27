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
#import <UIImageView+WebCache.h>

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

@end
