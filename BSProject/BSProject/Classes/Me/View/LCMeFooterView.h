//
//  LCMeFooterView.h
//  BSProject
//
//  Created by Liu-Mac on 4/28/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCMeFooterView : UIView

/** 创建完成执行的 block */
@property (nonatomic, copy) void(^createCompletedBlock)(LCMeFooterView *footerView);

@end
