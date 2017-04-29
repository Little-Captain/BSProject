//
//  LCPlaceholderTextView.m
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//  自定义的 TextView, 为 TextView 提供了占位文字

/*
 UITextField 默认的情况
 1.只能显示一行文字
 2.有占位文字
 
 UITextView 默认的情况
 1.能显示任意行文字
 2.没有占位文字
 
 需求:
 1.能显示任意行文字
 2.有占位文字
 
 本方案:
 1.继承自UITextView
 2.在UITextView能显示任意行文字的基础上,增加"有占位文字"的功能
 */

#import "LCPlaceholderTextView.h"

@interface LCPlaceholderTextView ()

/** place holder label */
@property (nonatomic, weak) UILabel *placeholderLabel;

@end

@implementation LCPlaceholderTextView

- (UILabel *)placeholderLabel {
    
    if (!_placeholderLabel) {
        UILabel *placeholderLabel = [UILabel new];
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.fX = 4;
        placeholderLabel.fY = 7;
        [self addSubview:placeholderLabel];
        _placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        // 垂直方向上设置弹簧效果
        self.alwaysBounceVertical = YES;
        
        // 设置默认字体
        self.font = [UIFont systemFontOfSize:15];
        
        // 默认的占位文字颜色
        self.placeholderColor = [UIColor grayColor];
        
        // 监听文字改变
        [NotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    
    [NotificationCenter removeObserver:self];
}

/** 监听文字改变 */
- (void)textDidChange {
    
    self.placeholderLabel.hidden = self.hasText;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 为 placeholderLabel 提供宽度
    self.placeholderLabel.fWidth = self.fWidth - 2 * self.placeholderLabel.fX;
    // 设置 sizeToFit
    [self.placeholderLabel sizeToFit];
}

#pragma mark - 监听相关 setter 方法

/** 监听占位文字颜色的改变 */
- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}

/** 监听占位文字内容的改变 */
- (void)setPlaceholder:(NSString *)placeholder{
    
    _placeholder = [placeholder copy];
    
    self.placeholderLabel.text = placeholder;
    
    [self setNeedsLayout];
}

/** 监听 TextView 字体的改变 */
- (void)setFont:(UIFont *)font {
    
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    
    [self setNeedsLayout];
}

/** 监听 TextView plain内容的改变 */
- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    [self textDidChange];
}

/** 监听 TextView attribute内容的改变 */
- (void)setAttributedText:(NSAttributedString *)attributedText {
    
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

// setNeedsDisplay 方法 : 会在恰当的时刻自动调用 drawRect: 方法
// setNeedsLayout 方法  : 会在恰当的时刻调用 layoutSubviews 方法

@end
