//
//  LCTopicCell.m
//  BSProject
//
//  Created by Liu-Mac on 12/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCTopicCell.h"
#import "LCTopicItem.h"

#import "LCCmtItem.h"
#import "LCCmtUserItem.h"

#import "LCEssencePicView.h"
#import "LCVoiceView.h"
#import "LCVideoView.h"
#import "LCVoicePlayerView.h"

#import <SVProgressHUD.h>
#import <Masonry.h>

@interface LCTopicCell ()

/** 头像 */
@property (weak, nonatomic) IBOutlet UIImageView *profile_imageV;
/** 名称 */
@property (weak, nonatomic) IBOutlet UILabel *nameL;
/** 发帖时间 */
@property (weak, nonatomic) IBOutlet UILabel *create_timeL;
/** 顶 */
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
/** 踩 */
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
/** 转发 */
@property (weak, nonatomic) IBOutlet UIButton *repostBtn;
/** 评论 */
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UIImageView *sina_vImageV;

@property (weak, nonatomic) IBOutlet UILabel *text_label;

/** 评论的Label */
@property (weak, nonatomic) IBOutlet UILabel *cmtL;

@property (weak, nonatomic) IBOutlet UIView *cmtContentV;


/** picImageV */
@property (nonatomic, weak) LCEssencePicView *picImageV;

/** voiceV */
@property (nonatomic, weak) LCVoiceView *voiceV;

/** videoV */
@property (nonatomic, weak) LCVideoView *videoV;


@end

@implementation LCTopicCell

+ (instancetype)topicCell {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    
}

- (LCEssencePicView *)picImageV {
    
    if (!_picImageV) {
        LCEssencePicView *picImageV = [LCEssencePicView essencePicView];
        [self.contentView addSubview:picImageV];
        _picImageV = picImageV;
    }
    
    return _picImageV;
    
}

- (LCVoiceView *)voiceV {
    
    if (!_voiceV) {
        LCVoiceView *voiceV = [LCVoiceView voiceView];
        [self.contentView addSubview:voiceV];
        _voiceV = voiceV;
    }
    
    return _voiceV;
    
}

- (LCVideoView *)videoV {
    
    if (!_videoV) {
        LCVideoView *videoV = [LCVideoView videoView];
        [self.contentView addSubview:videoV];
        _videoV = videoV;
    }
    
    return _videoV;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundView = ({
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageOfResizableWithName:@"mainCellBackground"];
        imageView;
    });
}

- (void)setItem:(LCTopicItem *)item {
    
    _item = item;
    
    self.sina_vImageV.hidden = !item.isSina_v;
    
    [self.profile_imageV setHeader:item.profile_image];
    self.nameL.text = item.name;
    self.create_timeL.text = item.create_time;
    self.text_label.text = item.text;
    
    [self.dingBtn setTitle:[self titleStandardWithCount:item.ding placeholder:@"顶"] forState:UIControlStateNormal];
    [self.caiBtn setTitle:[self titleStandardWithCount:item.cai placeholder:@"踩"] forState:UIControlStateNormal];
    [self.repostBtn setTitle:[self titleStandardWithCount:item.repost placeholder:@"转载"] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[self titleStandardWithCount:item.comment placeholder:@"评论"] forState:UIControlStateNormal];
    
    // 如果有评论我们就显示第一个最热的评论
    if (item.top_cmt) {
        self.cmtContentV.hidden = NO;
        LCCmtItem *cmtItem = item.top_cmt;
        self.cmtL.text = [NSString stringWithFormat:@"%@: %@", cmtItem.user.username, cmtItem.content];
    } else {
        self.cmtContentV.hidden = YES;
    }
    
    if (item.type == LCTopicTypePicture) {
        // 这样做事有问题的, 每次都添加
        // 一个图片cell只需要添加一次, 使用懒加载
        // 这里只设置picView的位置大小和数据
        self.picImageV.frame = item.picFrame;
        self.picImageV.topicItem = item;
        
        self.picImageV.hidden = NO;
        self.voiceV.hidden = YES;
        self.videoV.hidden = YES;
        
    } else if (item.type == LCTopicTypeVoice) {
        self.voiceV.frame = item.voiceFrame;
        self.voiceV.item = item;
        
        self.picImageV.hidden = YES;
        self.voiceV.hidden = NO;
        if (item.isPlayVoice) { // 正在播放
            // playBtn 隐藏
            self.voiceV.playBtn.hidden = YES;
            // 为 voicePlayerView 设置 模型
            self.voiceV.voicePlayerView.item = item;
            // voicePlayerView 显示
            self.voiceV.voicePlayerView.hidden = NO;
        } else { // 暂停
            // playBtn 显示
            self.voiceV.playBtn.hidden = NO;
            // 为 voicePlayerView 清空 模型
            self.voiceV.voicePlayerView.item = nil;
            // voicePlayerView 隐藏
            self.voiceV.voicePlayerView.hidden = YES;
        }
        self.videoV.hidden = YES;
        
    } else if (item.type == LCTopicTypeVideo) {
        self.videoV.frame = item.videoFrame;
        self.videoV.item = item;
        
        self.picImageV.hidden = YES;
        self.voiceV.hidden = YES;
        self.videoV.hidden = NO;
    } else {
        self.picImageV.hidden = YES;
        self.voiceV.hidden = YES;
        self.videoV.hidden = YES;
    }
    
}

- (NSString *)titleStandardWithCount:(NSInteger)count placeholder:(NSString *)placeholder {
    
    if (count >= 100000000) {
        placeholder = [NSString stringWithFormat:@"%.0f亿+", 1.0 * count / 100000000];
    } else if (count >= 10000000) {
        placeholder = [NSString stringWithFormat:@"%.0f千万+", 1.0 * count / 10000000];
    } else if (count >= 1000000) {
        placeholder = [NSString stringWithFormat:@"%.0f百万+", 1.0 * count / 1000000];
    } else if (count >= 100000) {
        placeholder = [NSString stringWithFormat:@"%.0f十万+", 1.0 * count / 100000];
    } else if (count >= 10000) {
        placeholder = [NSString stringWithFormat:@"%.0f万+", 1.0 * count / 10000];
    } else if (count > 0){
        placeholder = [NSString stringWithFormat:@"%zd", count];
    }
    return placeholder;
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x = EssenceCellMargin;
    frame.origin.y += EssenceCellMargin;
    // 这里不使用 -=, 使用固定值比较好
    frame.size.width = ScreenW - 2 * EssenceCellMargin;
    frame.size.height = self.item.cellHeight - EssenceCellMargin;
    
    [super setFrame:frame];
    
}

- (IBAction)followBtn {
    
    [KeyWindow.rootViewController presentViewController:({
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alter addAction:[UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showSuccessWithStatus:@"举报成功!"];
        }]];
        [alter addAction:[UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            !_sharedBlock ? : _sharedBlock(self.item);
        }]];
        [alter addAction:[UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVProgressHUD showSuccessWithStatus:@"收藏成功!"];
        }]];
        [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        alter;
    }) animated:YES completion:nil];
}

@end
