//
//  UIView+Bounds.m
//  02-粘连
//
//  Created by Liu-Mac on 04/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "UIView+Bounds.h"

@implementation UIView (Bounds)

- (CGFloat)bWidth {
    
    return self.bounds.size.width;
    
}

- (void)setBWidth:(CGFloat)bWidth {
    
    CGRect bounds = self.bounds;
    bounds.size.width = bWidth;
    self.bounds = bounds;
    
}

- (CGFloat)bHeight {
    
    return self.bounds.size.height;
    
}

- (void)setBHeight:(CGFloat)bHeight {
    
    CGRect bounds = self.bounds;
    bounds.size.height = bHeight;
    self.bounds = bounds;
    
}

- (CGSize)bSize {
    
    return self.bounds.size;
    
}

- (void)setBSize:(CGSize)bSize {
    
    CGRect bounds = self.bounds;
    bounds.size = bSize;
    self.bounds = bounds;
    
}

@end
