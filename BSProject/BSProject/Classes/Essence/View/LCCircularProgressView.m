//
//  LCCircularProgressView.m
//  BSProject
//
//  Created by Liu-Mac on 14/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCCircularProgressView.h"

@implementation LCCircularProgressView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.roundedCorners = 1;
    self.progressLabel.textColor = [UIColor whiteColor];
    
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    
    [super setProgress:progress animated:animated];
    
    self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%", fabs(progress * 100)];    
}

@end
