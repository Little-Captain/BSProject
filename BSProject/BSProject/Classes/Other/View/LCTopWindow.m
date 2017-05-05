//
//  LCTopWindow.m
//  BSProject
//
//  Created by Liu-Mac on 18/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCTopWindow.h"

#import "UIView+LCExtension.h"

#define TopWindowH 20

@implementation LCTopWindow

static UIWindow *window_;

+ (void)setUpWindow {
    
    window_ = ({
        UIWindow *window = [[UIWindow alloc] init];
        window_.frame = CGRectMake(0, 20, ScreenW, TopWindowH);
        window_.backgroundColor = [UIColor clearColor];
        window_.windowLevel = UIWindowLevelAlert;
        window_.rootViewController = [[UIViewController alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTopWindow)];
        [window_ addGestureRecognizer:tap];
        window;
    });
}

+ (void)show {
    
    [self setUpWindow];
    
    window_.hidden = NO;
}

+ (void)hidden {
    
    window_.hidden = YES;
}

+ (void)tableViewMoveToUp:(UIView *)superView {
    
    for (UIScrollView *scrollView in superView.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]] && scrollView.isShowingOnKeyWindow) {
            CGPoint offset = scrollView.contentOffset;
            offset.y = -scrollView.contentInset.top;
            [scrollView setContentOffset:offset animated:YES];
        }
        // 递归设置offset
        [self tableViewMoveToUp:scrollView];
    }    
}

+ (void)tapTopWindow {
    
    [self tableViewMoveToUp:KeyWindow];
}

@end
