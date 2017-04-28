//
//  LCSqaureButton.h
//  BSProject
//
//  Created by Liu-Mac on 4/28/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LCSquareItem;

@interface LCSqaureButton : UIButton

/** 方块模型 */
@property (nonatomic, strong) LCSquareItem *square;

@end
