//
//  LCTagTextField.h
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCTagTextField : UITextField

/** 按了删除键后的回调 */
@property (nonatomic, copy) void (^deleteBlock)();

@end
