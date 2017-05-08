//
//  LCAddTagVC.m
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

// viewDidLayoutSubviews 是控制器的 view 布局完成所有的子控件后调用的, 这里可以拿到 view 的准确 frame
// layoutSubviews 是视图布局子控件时调用的, 这里可以拿到视图的准确 frame

#import "LCAddTagVC.h"
#import "LCTagButton.h"
#import "LCTagTextField.h"

#import <SVProgressHUD.h>
#import <BlocksKit.h>

@interface LCAddTagVC () <UITextFieldDelegate>

/** 内容 */
@property (nonatomic, weak) UIView *contentView;
/** 文本输入框 */
@property (nonatomic, weak) LCTagTextField *textField;
/** 添加按钮 */
@property (nonatomic, weak) UIButton *addButton;
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray *tagButtons;

@end

@implementation LCAddTagVC

#pragma mark - 懒加载
- (NSMutableArray *)tagButtons {
    
    if (!_tagButtons) {
        
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (UIButton *)addButton {
    
    if (!_addButton) {
        
        UIButton *addButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.fWidth = self.contentView.fWidth;
            button.fHeight = 35;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
            button.titleLabel.font = LCTagFont;
            button.contentEdgeInsets = UIEdgeInsetsMake(0, LCTagMargin, 0, LCTagMargin);
            // 让按钮内部的文字和图片都左对齐
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.backgroundColor = LCTagBg;
            button;
        });
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupNav];
    [self setupContentView];
    [self setupTextFiled];
    [self setupTags];
}

- (void)setupTags {
    
    [self.tags bk_each:^(NSString *tag) {
        self.textField.text = tag;
        [self addButtonClick];
    }];
}

- (void)setupContentView {
    
    UIView *contentView = ({
        UIView *view = [[UIView alloc] init];
        view.fX = LCTagMargin;
        view.fWidth = self.view.fWidth - 2 * view.fX;
        view.fY = 64 + LCTagMargin;
        view.fHeight = ScreenH;
        view;
    });
    [self.view addSubview:contentView];
    self.contentView = contentView;
}

- (void)setupTextFiled {
    
    LCTagTextField *textField = ({
        LCTagTextField *textField = [[LCTagTextField alloc] init];
        textField.fWidth = self.contentView.fWidth;
        textField.delegate = self;
        [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        [textField becomeFirstResponder];
        __weak typeof(self) weakSelf = self;
        textField.deleteBlock = ^{
            if (weakSelf.textField.hasText) return;
            [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
        };
        textField;
    });
    [self.contentView addSubview:textField];
    self.textField = textField;
}

- (void)setupNav {
    
    self.view.backgroundColor = BSGlobalColor;
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
}

- (void)done {
    
    // 传递数据给上一个控制器
    // 传递 tags 给这个 block
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    !self.tagsBlock ? : self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 监听文字改变
/**
 * 监听文字改变
 */
- (void)textDidChange {
    
    // 更新文本框的frame
    [self updateTextFieldFrame];
    
    if (self.textField.hasText) { // 有文字
        // 显示"添加标签"的按钮
        self.addButton.hidden = NO;
        self.addButton.fY = CGRectGetMaxY(self.textField.frame) + LCTagMargin;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签: %@", self.textField.text] forState:UIControlStateNormal];
        
        // 获得最后一个字符
        NSString *text = self.textField.text;
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len - 1];
        if ([lastLetter isEqualToString:@","]
            || [lastLetter isEqualToString:@"，"]) {
            // 去除逗号
            self.textField.text = [text substringToIndex:len - 1];
            
            [self addButtonClick];
        }
    } else { // 没有文字
        // 隐藏"添加标签"的按钮
        self.addButton.hidden = YES;
    }
}

#pragma mark - 监听按钮点击
/**
 * 监听"添加标签"按钮点击
 */
- (void)addButtonClick {
    
    if (self.tagButtons.count == 5) {

        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showErrorWithStatus:@"最多添加5个标签"];
        return;
    }
    
    // 添加一个"标签按钮"
    LCTagButton *tagButton = ({
        LCTagButton *button = [LCTagButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:self.textField.text forState:UIControlStateNormal];
        button;
    });
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
    // 清空textField文字
    self.textField.text = nil;
    self.addButton.hidden = YES;
    
    // 更新标签按钮的frame
    [self updateTagButtonFrame];
    [self updateTextFieldFrame];
}

/**
 * 标签按钮的点击
 */
- (void)tagButtonClick:(LCTagButton *)tagButton {
    
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    // 重新更新所有标签按钮的frame
    [UIView animateWithDuration:0.25 animations:^{
        
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
}

#pragma mark - 子控件的frame处理
/**
 * 专门用来更新标签按钮的frame
 */
- (void)updateTagButtonFrame {
    
    // 更新标签按钮的frame
    for (int i = 0; i<self.tagButtons.count; i++) {
        
        LCTagButton *tagButton = self.tagButtons[i];
        
        if (i == 0) { // 最前面的标签按钮
            
            tagButton.fX = 0;
            tagButton.fY = 0;
        } else { // 其他标签按钮
            
            LCTagButton *lastTagButton = self.tagButtons[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + LCTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.contentView.fWidth - leftWidth;
            if (rightWidth >= tagButton.fWidth) { // 按钮显示在当前行
                
                tagButton.fY = lastTagButton.fY;
                tagButton.fX = leftWidth;
            } else { // 按钮显示在下一行
                
                tagButton.fX = 0;
                tagButton.fY = CGRectGetMaxY(lastTagButton.frame) + LCTagMargin;
            }
        }
    }
}

/**
 * 更新textField的frame
 */
- (void)updateTextFieldFrame {
    
    // 最后一个标签按钮
    LCTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + LCTagMargin;
    
    // 更新textField的frame
    if (self.contentView.fWidth - leftWidth >= [self textFieldTextWidth]) {
        self.textField.fY = lastTagButton.fY;
        self.textField.fX = leftWidth;
    } else {
        self.textField.fX = 0;
        self.textField.fY = CGRectGetMaxY(lastTagButton.frame) + LCTagMargin;
    }
    // 更新 添加按钮 的位置
    self.addButton.fY = CGRectGetMaxY(self.textField.frame) + LCTagMargin;
}

/**
 * textField的文字宽度
 */
- (CGFloat)textFieldTextWidth{
    
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}

#pragma mark - UITextFieldDelegate
/**
 * 监听键盘最右下角按钮的点击（return key， 比如“换行”、“完成”等等）
 */
- (BOOL)textFieldShouldReturn:(LCTagTextField *)textField {
    
    if (textField.hasText) {
        [self addButtonClick];
    }
    return YES;
}

@end
