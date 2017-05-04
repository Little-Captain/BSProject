//
//  LCPictureViewController.h
//  BSProject
//
//  Created by Liu-Mac on 14/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//  图片显示控制器

#import <UIKit/UIKit.h>

@class LCTopicItem;

@interface LCPictureViewController : UIViewController

/** 帖子模型 */
@property (nonatomic, strong) LCTopicItem *topicItem;

@end
