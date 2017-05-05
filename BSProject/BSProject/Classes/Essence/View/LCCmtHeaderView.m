//
//  LCCmtHeaderView.m
//  BSProject
//
//  Created by Liu-Mac on 18/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCCmtHeaderView.h"

@interface LCCmtHeaderView ()

/** label */
@property (nonatomic, weak) UILabel *label;

@end

@implementation LCCmtHeaderView


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UILabel *label = ({
            UILabel *label = [[UILabel alloc] init];
            label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            label.fX = EssenceCellMargin;
            label.fWidth = ScreenW - 2 * EssenceCellMargin;
            label.textColor = LCColor(67, 67, 67);
            label.font = [UIFont systemFontOfSize:14.0];
            label;
        });        
        [self.contentView addSubview:label];
        self.label = label;
        
        self.contentView.backgroundColor = BSGlobalColor;
    }
    
    return self;
    
}

- (void)setTitle:(NSString *)title {
    
    // copy属性,我们我们就调用copy方法
    _title = [title copy];
    
    self.label.text = title;
    
}

@end
