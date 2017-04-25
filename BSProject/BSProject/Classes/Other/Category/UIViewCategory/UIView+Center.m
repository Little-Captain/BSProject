//
//  UIView+Center.m
//  02-粘连
//
//  Created by Liu-Mac on 04/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "UIView+Center.h"

@implementation UIView (Center)

- (CGFloat)cX {
    
    return self.center.x;
    
}

- (void)setCX:(CGFloat)cX {
    
    CGPoint center = self.center;
    center.x = cX;
    self.center = center;
    
}

- (CGFloat)cY {
    
    return self.center.y;
    
}

- (void)setCY:(CGFloat)cY {
    
    CGPoint center = self.center;
    center.y = cY;
    self.center = center;
    
}

@end
