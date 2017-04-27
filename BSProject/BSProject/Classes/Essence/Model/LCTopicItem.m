//
//  LCTopicItem.m
//  BSProject
//
//  Created by Liu-Mac on 12/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCTopicItem.h"

#import "LCCmtItem.h"
#import "LCCmtUserItem.h"

@implementation LCTopicItem {
    // cellHeight为readonly属性, 我们又实现了它的get方法
    // 所以Xcode不会为我们生成下划线成员变量
    // 所以我们需要自己生成
    CGFloat _cellHeight;
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{
             @"smallImage": @"image0",
             @"midImage": @"image1",
             @"bigImage": @"image2",
             @"ID": @"id",
             @"top_cmt": @"top_cmt[0]"
             };
    
}

// 将日期格式化返回
- (NSString *)create_time {
    
    // 创建的date
    NSDate *createDate = [NSDate dateWithString:_create_time dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    // 当前的date
    NSDate *currentDate = [NSDate date];
    
    // 日期格式化类, 很重要
    NSDateFormatter *dfmt = [[NSDateFormatter alloc] init];

    // 创建的date和当前的date的差值
    NSDateComponents *components = [NSDate compareDateFromDate:createDate toDate:currentDate];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isThisDay]) { // 今天
            if (components.hour) { // 一小时以上
                return [NSString stringWithFormat:@"%zd小时前", components.hour];
            } else { // 一小时以内
                if (components.minute) { // 一分钟以上
                    return [NSString stringWithFormat:@"%zd分钟前", components.minute];
                } else { // 一分钟以内
                    return @"刚刚";
                }
            }
        } else if ([createDate isYesterDay]) { // 昨天
            dfmt.dateFormat = @"昨天 HH:mm:ss";
            return [dfmt stringFromDate:createDate];
        } else { // 既不是今天也不是昨天
            dfmt.dateFormat = @"MM-dd HH:mm:ss";
            return [dfmt stringFromDate:createDate];
        }
    } else { // 不是今年
        return _create_time;
    }
    
}

- (CGFloat)cellHeight {
    
    if (!_cellHeight) {
        CGFloat textW = ScreenW - 2 * EssenceCellMargin - 2 * EssenceCellTextMargin;
        CGFloat textH = [self.text boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil].size.height;
        _cellHeight = EssenceCellTextY + textH + EssenceCellMargin; // Text的最下端
        if (self.type == LCTopicTypePicture) { // 图片帖子
            CGFloat picX = EssenceCellTextMargin;
            CGFloat picY = _cellHeight;
            CGFloat picW = textW;
            CGFloat picH = textW * self.height.doubleValue / self.width.doubleValue;
            if (picH > EssencePicMaxH) {
                picH = EssencePicRecommendH;
                self.bigPic = YES;
            }
            _picFrame = CGRectMake(picX, picY, picW, picH);
            _cellHeight +=  picH + EssenceCellMargin; // Picture的最下端
        } else if (self.type == LCTopicTypeVideo) { // 视频帖子
            CGFloat videoX = EssenceCellTextMargin;
            CGFloat videoY = _cellHeight;
            CGFloat videoW = textW;
            CGFloat videoH = textW * self.height.doubleValue / self.width.doubleValue;
            _videoFrame = CGRectMake(videoX, videoY, videoW, videoH);
            _cellHeight +=  videoH + EssenceCellMargin; // video的最下端
        } else if (self.type == LCTopicTypeVoice) { // 声音帖子
            CGFloat voiceX = EssenceCellTextMargin;
            CGFloat voiceY = _cellHeight;
            CGFloat voiceW = textW;
            CGFloat voiceH = textW * self.height.doubleValue / self.width.doubleValue;
            _voiceFrame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            _cellHeight +=  voiceH + EssenceCellMargin; // video的最下端
        }
        
        // 如果有评论我们就显示第一个最热的评论
        if (self.top_cmt) {
            LCCmtItem *cmtItem = self.top_cmt;
            NSString *cmtStr = [NSString stringWithFormat:@"%@: %@", cmtItem.user.username, cmtItem.content];
            CGFloat cmtH = [cmtStr boundingRectWithSize:CGSizeMake(textW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0]} context:nil].size.height;
            _cellHeight += CommentTitleH + cmtH + EssenceCellMargin;
        }
        
        _cellHeight += EssenceCellMargin + EssenceCellBarH; // 这里得到真正的cell高度
    }   
    
    return _cellHeight;
}

@end
