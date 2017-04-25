//
//  UIBarButtonItem+LCExtension.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "UIBarButtonItem+LCExtension.h"

@implementation UIBarButtonItem (LCExtension)

+ (instancetype)itemWithTarget:(id)target action:(SEL)sel image:(NSString *)image hightImage:(NSString *)hightImage {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:hightImage] forState:UIControlStateHighlighted];
    btn.fSize = btn.currentBackgroundImage.size;
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc] initWithCustomView:btn];
}

@end
