//
//  LCSqaureButton.m
//  BSProject
//
//  Created by Liu-Mac on 4/28/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCSqaureButton.h"
#import "LCSquareItem.h"

#import <YYWebImage.h>

@implementation LCSqaureButton

- (void)setup {
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self setup];
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.fY = self.fHeight * 0.15;
    self.imageView.fWidth = self.fWidth * 0.5;
    self.imageView.fHeight = self.imageView.fWidth;
    self.imageView.cX = self.fWidth * 0.5;
    
    // 调整文字
    self.titleLabel.fX = 0;
    self.titleLabel.fY = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.fWidth = self.fWidth;
    self.titleLabel.fHeight = self.fHeight - self.titleLabel.fY;
}

- (void)setSquare:(LCSquareItem *)square
{
    _square = square;
    
    [self setTitle:square.name forState:UIControlStateNormal];
    // 利用SDWebImage给按钮设置image
    [self yy_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal options:kNilOptions];
}

@end
