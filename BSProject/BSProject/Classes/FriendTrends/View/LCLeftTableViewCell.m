//
//  LCLeftTableViewCell.m
//  BSProject
//
//  Created by Liu-Mac on 4/26/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCLeftTableViewCell.h"

@interface LCLeftTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *selectedIndect;

@end

@implementation LCLeftTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置背景颜色
    self.backgroundColor = BSGlobalColor;
    // 设置指示view的背景颜色
    self.selectedIndect.backgroundColor = LCColor(219, 21, 26);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.selectedIndect.hidden = !selected;
    // 调整文字颜色
    self.textLabel.textColor = self.selectedIndect.hidden ? LCColor(78, 78, 78) : LCColor(219, 21, 26);
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    self.textLabel.fY = 2;
    self.textLabel.fHeight = self.contentView.fHeight - 4;
    
}

@end
