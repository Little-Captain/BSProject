//
//  LCCmtDetailViewController.h
//  BSProject
//
//  Created by Liu-Mac on 17/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//  评论详情控制器

#import <UIKit/UIKit.h>

@class LCTopicItem;

@interface LCCmtDetailViewController : UIViewController

/** 模型 */
@property (nonatomic, strong) LCTopicItem *item;

@end
