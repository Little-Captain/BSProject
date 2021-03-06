//
//  LCEssencePicView.m
//  BSProject
//
//  Created by Liu-Mac on 14/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCEssencePicView.h"
#import "LCTopicItem.h"
#import "LCPictureViewController.h"
#import "LCCircularProgressView.h"
#import <UIImageView+YYWebImage.h>

@interface LCEssencePicView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UIImageView *gifImageV;

@property (weak, nonatomic) IBOutlet UIButton *seeBigBtn;

@property (weak, nonatomic) IBOutlet LCCircularProgressView *progressView;


@end

@implementation LCEssencePicView

+ (instancetype)essencePicView {
    
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
    
    [KeyWindow.rootViewController presentViewController:({
        LCPictureViewController *pictureVC = [[LCPictureViewController alloc] init];
        pictureVC.topicItem = self.topicItem;
        pictureVC;
    }) animated:YES completion:nil];
}

- (void)setTopicItem:(LCTopicItem *)topicItem {
    
    _topicItem = topicItem;
    
    [self.progressView setProgress:topicItem.picProgress animated:NO];
    self.progressView.hidden = (topicItem.picProgress >= 1.0) ? YES : NO;
    
    // 通过扩展名判断是不是gif图片
    BOOL isGif = [topicItem.bigImage.pathExtension.lowercaseString isEqualToString:@"gif"];
    self.gifImageV.hidden = !isGif;
    
    self.seeBigBtn.hidden = !topicItem.isBigPic;
    
    if (topicItem.isBigPic) {
        self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    } else {
        self.imageV.contentMode = UIViewContentModeScaleToFill;
    }
    
    [self.imageV yy_setImageWithURL:[NSURL URLWithString:topicItem.bigImage] placeholder:nil options:kNilOptions progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        topicItem.picProgress = 1.0 * receivedSize / expectedSize;
        [self.progressView setProgress:topicItem.picProgress animated:NO];
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        self.progressView.hidden = YES;
        if (!topicItem.isBigPic) {
            return;
        }        
        CGFloat width = self.imageV.fWidth;
        CGFloat height = EssencePicRecommendH;
        // 开启图形上下文
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height), NO, 0);
        // 将图片画到图形上下文中
        // oW * oH
        // dW * dH
        CGFloat drawH = image.size.height * width / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, drawH)];
        
        self.imageV.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }];
}

@end
