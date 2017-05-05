//
//  LCAddTagToolbar.m
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCAddTagToolbar.h"
#import "LCAddTagVC.h"

@interface LCAddTagToolbar()

/** 顶部控件 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 添加按钮 */
@property (weak, nonatomic) UIButton *addButton;
/** 存放所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;

@end

@implementation LCAddTagToolbar

- (NSMutableArray *)tagLabels {
    
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 添加一个加号按钮
    UIButton *addButton = ({
        UIButton *button = [[UIButton alloc] init];
        [button addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
        button.fSize = button.currentImage.size;
        button.fX = LCTagMargin;
        button;
    });
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    [self createTagLabels:@[@"搞笑", @"嗅事"]];
}

- (void)addButtonClick {
    
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    // a (modal)--> b
    // a 的 presentedViewController == b
    // b 的 presentingViewController == a
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:({
        LCAddTagVC *vc = [[LCAddTagVC alloc] init];
        vc.tags = [self.tagLabels valueForKeyPath:@"text"];
        __weak typeof(self) weakSelf = self;
        [vc setTagsBlock:^(NSArray *tags) {
            [weakSelf createTagLabels:tags];
        }];
        vc;
    }) animated:YES];
}

/**
 * 创建标签
 */
- (void)createTagLabels:(NSArray *)tags {
    
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    for (int i = 0; i<tags.count; i++) {
        UILabel *tagLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = LCTagBg;
            label.textAlignment = NSTextAlignmentCenter;
            label.text = tags[i];
            label.font = LCTagFont;
            // 应该要先设置文字和字体后，再进行计算
            [label sizeToFit];
            label.fWidth += 2 * LCTagMargin;
            label.fHeight = LCTagH;
            label.textColor = [UIColor whiteColor];
            // 设置位置
            if (i == 0) { // 最前面的标签
                label.fX = 0;
                label.fY = 0;
            } else { // 其他标签                
                UILabel *previousLabel = self.tagLabels[i - 1];
                // 计算当前行左边的宽度
                CGFloat leftWidth = CGRectGetMaxX(previousLabel.frame) + LCTagMargin;
                // 计算当前行右边的宽度
                CGFloat rightWidth = self.topView.fWidth - leftWidth;
                if (rightWidth >= label.fWidth) { // 按钮显示在当前行
                    label.fY = previousLabel.fY;
                    label.fX = leftWidth;
                } else { // 按钮显示在下一行
                    label.fX = 0;
                    label.fY = CGRectGetMaxY(previousLabel.frame) + LCTagMargin;
                }
            }
            label;
        });
        [self.topView addSubview:tagLabel];
        [self.tagLabels addObject:tagLabel];
    }

    // 最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + LCTagMargin;
    
    // 更新textField的frame
    if (self.topView.fWidth - leftWidth >= self.addButton.fWidth) {
        self.addButton.fY = lastTagLabel.fY;
        self.addButton.fX = leftWidth;
    } else {
        self.addButton.fX = 0;
        self.addButton.fY = CGRectGetMaxY(lastTagLabel.frame) + LCTagMargin;
    }
    
    // 设置 self 的高度
    CGFloat oldHeight = self.fHeight;
    self.fHeight = CGRectGetMaxY(self.addButton.frame) + LCToolBarBottomH;
    self.fY -= self.fHeight - oldHeight;
}

@end
