//
//  LCCmtCell.h
//  BSProject
//
//  Created by Liu-Mac on 18/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCCmtItem;

@interface LCCmtCell : UITableViewCell

/** 评论模型 */
@property (nonatomic, strong) LCCmtItem *item;

@end
