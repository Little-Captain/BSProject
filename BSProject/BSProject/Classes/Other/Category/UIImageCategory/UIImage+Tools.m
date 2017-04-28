//
//  UIImage+Tools.m
//  Lottery(LC)
//
//  Created by Liu-Mac on 05/11/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "UIImage+Tools.h"

@implementation UIImage (Tools)

+ (instancetype)imageOfAlwaysOriginalWithImageNamed:(NSString *)name {

    return [[self imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}

+ (UIImage *)imageOfResizableWithName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    CGSize size = image.size;
    
    return  [image resizableImageWithCapInsets:UIEdgeInsetsMake(size.height/2, size.width/2, size.height/2 - 1, size.width/2 -1)];
}

+ (UIImage *)imageWithCornerRadius:(CGFloat)radius imageNamed:(NSString *)name {
    
    return [UIImage imageWithCornerRadius:radius image:[UIImage imageNamed:name]];
    
}

+ (UIImage *)imageWithCornerRadius:(CGFloat)radius image:(UIImage *)image {
    

    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    // 获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 得到当前上下文的rect
    CGRect contextRect = CGRectZero;
    contextRect.size = image.size;
    // 通过上下文rect和圆角半径绘制路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:contextRect cornerRadius:radius];
    // 设置为路径裁剪
    [path addClip];
    // 将路径加入图形上下文
    CGContextAddPath(context, path.CGPath);
    
    // 绘制原始图片
    [image drawInRect:contextRect];
    
    // 从图形上下文获取图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭图形上下文
    UIGraphicsEndImageContext();
    
    // 返回圆角图片
    return image;
    
}

// 压缩图片到指定大小
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size {
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
    CGFloat dataKBytes = data.length/1000.0;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataKBytes;
    while (dataKBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataKBytes = data.length / 1000.0;
        if (lastData == dataKBytes) {
            break;
        }else{
            lastData = dataKBytes;
        }
    }
    return data;
    
}

+ (UIImage *)imageWithSize:(CGSize)size image:(UIImage *)image {
    
    return [UIImage imageWithCGImage:CGImageCreateWithImageInRect(image.CGImage, CGRectMake(0, 0, size.width, size.height))];
    
}

- (UIImage *)circleImage {
    
    // NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    // 获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
