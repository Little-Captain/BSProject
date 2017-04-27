//
//  LCTextField.m
//  BSProject
//
//  Created by Liu-Mac on 09/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCTextField.h"

@implementation LCTextField

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 设置光标和文字颜色一样
    self.tintColor = self.textColor;
    
    [self resignFirstResponder];
}

- (BOOL)resignFirstResponder {
    
    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    
    [self setValue:self.textColor forKeyPath:@"_placeholderLabel.textColor"];
    return [super becomeFirstResponder];
}

@end
