//
//  LCFullVC.m
//  LCVideoPlayer
//
//  Created by Liu-Mac on 2/10/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCFullVC.h"

@interface LCFullVC ()

@end

@implementation LCFullVC

#pragma mark - 仅允许竖屏
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - 允许自动旋转
- (BOOL)shouldAutorotate {
    // 不返回 YES, 当进入这个控制器时, 不会自动旋转屏幕
    return YES;
}

@end
