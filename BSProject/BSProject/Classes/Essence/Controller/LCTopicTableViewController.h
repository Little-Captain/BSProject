//
//  LCTopicTableViewController.h
//  BSProject
//
//  Created by Liu-Mac on 13/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//  topic 控制器

#import <UIKit/UIKit.h>

@interface LCTopicTableViewController : UITableViewController

/** topic 类型 */
@property (nonatomic, assign) LCTopicType type;
/** 类别: 精华还是新帖 */
@property (nonatomic, strong) NSString *category;

@end
