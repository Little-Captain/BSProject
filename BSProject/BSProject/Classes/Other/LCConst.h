//
//  LCConst.h
//  01-第一个综合项目
//
//  Created by Liu-Mac on 12/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    LCTopicTypeWord = 29,
    LCTopicTypeAll = 1,
    LCTopicTypeVideo = 41,
    LCTopicTypeVoice = 31,
    LCTopicTypePicture = 10
} LCTopicType;

/** 精华标题的Y和H */
UIKIT_EXTERN CGFloat const EssenceTitleViewY;
UIKIT_EXTERN CGFloat const EssenceTitleViewH;

/** 精华部分cell的边距*/
UIKIT_EXTERN CGFloat const EssenceCellMargin;
UIKIT_EXTERN CGFloat const EssenceCellTextY;
UIKIT_EXTERN CGFloat const EssenceCellBarH;
UIKIT_EXTERN CGFloat const EssenceCellTextMargin;

/** 图片的高度控制 */
UIKIT_EXTERN CGFloat const EssencePicMaxH;
UIKIT_EXTERN CGFloat const EssencePicRecommendH;

/** 评论标题的高度 */
UIKIT_EXTERN CGFloat const CommentTitleH;

/** 评论bar的高度 */
UIKIT_EXTERN CGFloat const CommentBarH;

/** 用户是男性的字符 */
UIKIT_EXTERN NSString * const ManSex;

/** TabBarController 的 ViewController 被选中的通知 */
UIKIT_EXTERN NSString * const UITabBarControllerDidSelectViewControllerNotification;

/** 标签-间距 */
UIKIT_EXTERN CGFloat const LCTagMargin;
/** 标签-高度 */
UIKIT_EXTERN CGFloat const LCTagH;
/** toolbar bottom height */
UIKIT_EXTERN CGFloat const LCToolBarBottomH;
