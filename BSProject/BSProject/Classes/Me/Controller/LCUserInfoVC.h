//
//  LCUserInfoVC.h
//  BSProject
//
//  Created by Liu-Mac on 5/8/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCUserInfoItem;

@interface LCUserInfoVC : UITableViewController

/** 用户信息 */
@property (nonatomic, strong) LCUserInfoItem *userInfo;

@end
