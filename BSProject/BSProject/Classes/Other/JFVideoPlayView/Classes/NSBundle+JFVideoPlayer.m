//
//  NSBundle+JFVideoPlayer.m
//  JFProject
//
//  Created by Liu-Mac on 3/20/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "NSBundle+JFVideoPlayer.h"

@implementation NSBundle (JFVideoPlayer)

+ (instancetype)videoPlayerFramework {
    
    static NSBundle *videoPlayerFramework = nil;
    if (videoPlayerFramework == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        videoPlayerFramework = [NSBundle bundleForClass:NSClassFromString(@"JFVideoPlayView")];
    }
    return videoPlayerFramework;
}

+ (instancetype)videoPlayerResourceBundle {
    
    static NSBundle *videoPlayerResourceBundle = nil;
    if (videoPlayerResourceBundle == nil) {
        videoPlayerResourceBundle = [NSBundle bundleWithPath:[[self videoPlayerFramework] pathForResource:@"JFVideoPlayView" ofType:@"bundle"]];
    }
    return videoPlayerResourceBundle;
}

+ (UIImage *)imageOfbannerVideoArrow {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"bannerVideoArrow@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfbannerVideoIcon {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"bannerVideoIcon@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfbannerVideoMask {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"bannerVideoMask@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfbannerVideoPlay {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"bannerVideoPlay@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfDetailVideoClose {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"DetailVideoClose@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfDetailVideoPlay {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"DetailVideoPlay@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfmaxthumb {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"maxthumb@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfminthumb {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"minthumb@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfroundSlider {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"roundSlider@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfShopDetail360Video {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"ShopDetail360Video@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfUINavBarItemBack1 {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"UINavBarItemBack1@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfUINavBarItemShare1 {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"UINavBarItemShare1@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoArrow1 {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoArrow1@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoBarrage {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoBarrage@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoBarrageEx {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoBarrageEx@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoFullScreen {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoFullScreen@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoMaskBottom {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoMaskBottom@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoMaskTop {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoMaskTop@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoMore {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoMore@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoNotFullScreen {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoNotFullScreen@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoPause {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoPause@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoPlay {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoPlay@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoReplay {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoReplay@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoSend {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoSend@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoSwitchOFF {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoSwitchOFF@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

+ (UIImage *)imageOfvideoSwitchOn {
    
    static UIImage *image = nil;
    if (image == nil) {
        image = [[UIImage imageWithContentsOfFile:[[self videoPlayerResourceBundle] pathForResource:@"videoSwitchOn@2x" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return image;
}

@end
