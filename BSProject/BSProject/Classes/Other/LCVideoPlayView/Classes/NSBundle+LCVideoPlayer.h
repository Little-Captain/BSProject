//
//  NSBundle+LCVideoPlayer.h
//  LCProject
//
//  Created by Liu-Mac on 3/20/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSBundle (LCVideoPlayer)

+ (instancetype)videoPlayerFramework;
+ (instancetype)videoPlayerResourceBundle;

#pragma mark - 图片资源相关
+ (UIImage *)imageOfbannerVideoArrow;
+ (UIImage *)imageOfbannerVideoIcon;
+ (UIImage *)imageOfbannerVideoMask;
+ (UIImage *)imageOfbannerVideoPlay;
+ (UIImage *)imageOfDetailVideoClose;
+ (UIImage *)imageOfDetailVideoPlay;
+ (UIImage *)imageOfmaxthumb;
+ (UIImage *)imageOfminthumb;
+ (UIImage *)imageOfroundSlider;
+ (UIImage *)imageOfShopDetail360Video;
+ (UIImage *)imageOfUINavBarItemBack1;
+ (UIImage *)imageOfUINavBarItemShare1;
+ (UIImage *)imageOfvideoArrow1;
+ (UIImage *)imageOfvideoBarrage;
+ (UIImage *)imageOfvideoBarrageEx;
+ (UIImage *)imageOfvideoFullScreen;
+ (UIImage *)imageOfvideoMaskBottom;
+ (UIImage *)imageOfvideoMaskTop;
+ (UIImage *)imageOfvideoMore;
+ (UIImage *)imageOfvideoNotFullScreen;
+ (UIImage *)imageOfvideoPause;
+ (UIImage *)imageOfvideoPlay;
+ (UIImage *)imageOfvideoReplay;
+ (UIImage *)imageOfvideoSend;
+ (UIImage *)imageOfvideoSwitchOFF;
+ (UIImage *)imageOfvideoSwitchOn;

@end
