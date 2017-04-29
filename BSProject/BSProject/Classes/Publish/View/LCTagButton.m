//
//  LCTagButton.m
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCTagButton.h"

@implementation LCTagButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = LCTagBg;
        self.titleLabel.font = LCTagFont;
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.fWidth += 3 * LCTagMargin;
    self.fHeight = LCTagH;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.titleLabel.fX < self.imageView.fX) return;
    
    self.titleLabel.fX = LCTagMargin;
    self.imageView.fX = CGRectGetMaxX(self.titleLabel.frame) + LCTagMargin;
}

@end
