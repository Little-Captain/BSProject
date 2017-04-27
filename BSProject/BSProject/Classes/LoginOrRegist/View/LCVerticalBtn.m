//
//  BSVerticalBtn.m
//  BSProject
//
//  Created by Liu-Mac on 08/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCVerticalBtn.h"

@implementation LCVerticalBtn

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setUp];
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setUp];
    }
    
    return self;
    
}

- (void)setUp {
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    // 布局imageView的位置
    self.imageView.fX = 0;
    self.imageView.fY = 0;
    self.imageView.fWidth = self.fWidth;
    self.imageView.fHeight = self.imageView.fWidth;
    
    // 布局label的位置
    self.titleLabel.fX = 0;
    self.titleLabel.fY = self.imageView.fHeight;
    self.titleLabel.fWidth = self.fWidth;
    self.titleLabel.fHeight = self.fHeight - self.imageView.fHeight;
    
}

@end
