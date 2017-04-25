//
//  UIView+Frame.m
//  ProjectProJect(LC)
//
//  Created by Liu-Mac on 03/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)fX {
    
    return self.frame.origin.x;
    
}

- (void)setFX:(CGFloat)fX {
    
    CGRect frame = self.frame;
    frame.origin.x = fX;
    self.frame = frame;
    
}

- (CGFloat)fY {
    
    return self.frame.origin.y;
    
}

- (void)setFY:(CGFloat)fY {
    
    CGRect frame = self.frame;
    frame.origin.y = fY;
    self.frame = frame;
    
}

- (CGFloat)fWidth {
    
    return self.frame.size.width;
    
}

- (void)setFWidth:(CGFloat)fWidth {
    
    CGRect frame = self.frame;
    frame.size.width = fWidth;
    self.frame = frame;
    
}

- (CGFloat)fHeight {
    
    return self.frame.size.height;
    
}

- (void)setFHeight:(CGFloat)fHeight {
    
    CGRect frame = self.frame;
    frame.size.height = fHeight;
    self.frame = frame;
    
}

- (CGPoint)fOrigin {
    
    return self.frame.origin;
    
}

- (void)setFOrigin:(CGPoint)fOrigin {
    
    CGRect frame = self.frame;
    frame.origin = fOrigin;
    self.frame = frame;
    
}

- (CGSize)fSize {
    
    return self.frame.size;
    
}

- (void)setFSize:(CGSize)fSize {
    
    CGRect frame = self.frame;
    frame.size = fSize;
    self.frame = frame;
    
}

@end
