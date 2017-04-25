//
//  UIBarButtonItem+LCExtension.h
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (LCExtension)

+ (instancetype)itemWithTarget:(id)target action:(SEL)sel image:(NSString *)image hightImage:(NSString *)hightImage;

@end
