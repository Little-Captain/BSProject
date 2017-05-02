//
//  LCTopicCell.h
//  BSProject
//
//  Created by Liu-Mac on 12/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCTopicItem;

@interface LCTopicCell : UITableViewCell

/** item */
@property (nonatomic, strong) LCTopicItem *item;

/** share */
@property (nonatomic, copy) void(^sharedBlock)(LCTopicItem *item);

+ (instancetype)topicCell;

@end
