//
//  LCPlaceholderTextView.h
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LCPlaceholderTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
