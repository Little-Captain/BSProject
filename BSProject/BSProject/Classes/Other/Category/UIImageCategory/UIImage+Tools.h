//
//  UIImage+Tools.h
//  Lottery(LC)
//
//  Created by Liu-Mac on 05/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tools)

// 返回原始的图片
+ (instancetype)imageOfAlwaysOriginalWithImageNamed:(NSString *)name;

// 返回可拉伸的图片
+ (UIImage *)imageOfResizableWithName:(NSString *)name;

// 返回一张圆角图片, 也可以用图层做, 但是这样会引其离屏渲染, 性能下降
+ (UIImage *)imageWithCornerRadius:(CGFloat)radius imageNamed:(NSString *)name;

// 返回一张圆角图片
+ (UIImage *)imageWithCornerRadius:(CGFloat)radius image:(UIImage *)image;

// 通过已有图片创建一张指定尺寸的图片
+ (UIImage *)imageWithSize:(CGSize)size image:(UIImage *)image;

// 生成圆形图片
- (UIImage *)circleImage;

@end
