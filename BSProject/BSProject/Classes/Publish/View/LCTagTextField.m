//
//  LCTagTextField.m
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCTagTextField.h"

@implementation LCTagTextField

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.placeholder = @"多个标签用逗号或者换行隔开";
        // 设置了占位文字内容以后, 才能设置占位文字的颜色
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.fHeight = LCTagH;
    }
    return self;
}

- (void)deleteBackward {
    
    !_deleteBlock ? : _deleteBlock();
    
    [super deleteBackward];
}

@end
