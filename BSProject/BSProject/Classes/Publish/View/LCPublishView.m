//
//  LCPublishView.m
//  BSProject
//
//  Created by Liu-Mac on 15/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCPublishView.h"

#import "LCVerticalBtn.h"
#import "LCMainNavigationC.h"

#import <POP.h>
#import <Masonry.h>

@implementation LCPublishView

// 静态全局窗口变量
// 用于全局显示Publish View
static UIWindow *window;

+ (void)show {

    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    LCPublishView *publishView = [self publishView];
    [window addSubview:publishView];
    [publishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(publishView.superview.mas_top);
        make.bottom.equalTo(publishView.superview.mas_bottom);
        make.left.equalTo(publishView.superview.mas_left);
        make.right.equalTo(publishView.superview.mas_right);
    }];
    window.hidden = NO;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setUp];

}

- (void)setUp {
    
    // 与用户交互的控制
    // 刚进入时, 不能交互
    // 动画完全完成时, 才能交互
    self.userInteractionEnabled = NO;
    
    NSArray *picNames = @[
                          @"publish-video",
                          @"publish-audio",
                          @"publish-picture",
                          @"publish-text",
                          @"publish-offline",
                          @"publish-review"
                          ];
    NSArray *titles = @[
                        @"视频",
                        @"音频",
                        @"图片",
                        @"段子",
                        @"离线",
                        @"点赞"
                        ];
    
    // 添加 slogan 控件
    [self addSubview:({
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
        CGFloat centerX = ScreenW * 0.51;
        CGFloat centerY = ScreenH * 0.2;
        imageV.center = CGPointMake(centerX, centerY - ScreenH);
        [imageV pop_addAnimation:({
            POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
            animation.springSpeed = 15;
            animation.springBounciness = 15;
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerY)];
            animation.beginTime = CACurrentMediaTime() + (picNames.count + 1) * 0.2;
            animation.completionBlock = ^(POPAnimation *anim, BOOL finished){
                self.userInteractionEnabled = YES; // 这时最后一个动画的控件, 当这个动画完成时, 我们就允许用户交互了
            };
            animation;
        }) forKey:nil];
        imageV;
    })];
    
    // 添加所有的按钮控件
    NSInteger row = 2; // 行
    NSInteger col = 3; // 列
    CGFloat btnW = 72.0;
    CGFloat btnH = 102.0;
    CGFloat edgeMargin = 15.0;
    CGFloat YStart = (ScreenH - btnH * 2) / row;
    CGFloat btnMargin = (ScreenW - btnW * col - edgeMargin * (col - 1)) / (col - 1);
    for (int i = 0; i < picNames.count; ++i) {
        [self addSubview:({
            LCVerticalBtn *button = [LCVerticalBtn buttonWithType:UIButtonTypeCustom];
            CGFloat btnX = edgeMargin + (btnW + btnMargin) * (i % col);
            CGFloat btnY = YStart + (i / col) * btnH;
            button.frame = CGRectMake(btnX, btnY - ScreenH, btnW, btnH);
            [button setImage:[UIImage imageNamed:picNames[i]] forState:UIControlStateNormal];
            [button setTitle:titles[i] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [button pop_addAnimation:({
                POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
                animation.springSpeed = 15;
                animation.springBounciness = 15;
                animation.toValue = [NSValue valueWithCGRect:CGRectMake(btnX, btnY, btnW, btnH)];
                animation.beginTime = CACurrentMediaTime() + (picNames.count - i) * 0.25;
                animation;
            }) forKey:nil];
            button;
        })];
    }
}

// 当用户点击了按钮我们要做两件事
// 1. 退出发布界面
// 2. 传送发布消息
- (void)btnClick:(UIButton *)btn {
    
    switch (btn.tag) {
        case 0:
            [self cancelWithCompletionBlock:^{
                NSLog(@"视频");
            }];
            break;
        case 1:
            [self cancelWithCompletionBlock:^{
                NSLog(@"音频");
            }];
            break;
        case 2:
            [self cancelWithCompletionBlock:^{
                NSLog(@"图片");
            }];
            break;
        case 3:
            [self cancelWithCompletionBlock:^{
                [KeyWindow.rootViewController presentViewController:[[LCMainNavigationC alloc] initWithRootViewController:[NSClassFromString(@"LCPublishWordVC") new]] animated:YES completion:nil];
            }];
            break;
        case 4:
            [self cancelWithCompletionBlock:^{
                NSLog(@"离线");
            }];
            break;
        case 5:
            [self cancelWithCompletionBlock:^{
                NSLog(@"点赞");
            }];
            break;
        default:
            break;
    }
    
}

+ (instancetype)publishView {

    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].firstObject;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self cancelWithCompletionBlock:nil];
    
}

- (void)cancelWithCompletionBlock:(void (^)(void))completionBlock {
    
    // 当用户取消了, 就不允许交互了
    self.userInteractionEnabled = NO;
    
    NSInteger count = self.subviews.count;
    for (int index = 2; index < count; ++index) {
        UIView *view = self.subviews[index];
        [view pop_addAnimation:({
            POPBasicAnimation *animation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
            animation.toValue = [NSValue valueWithCGRect:CGRectMake(view.fX, view.fY + ScreenH, view.fWidth, view.fHeight)];
            animation.beginTime = CACurrentMediaTime() + (count - index) * 0.2;
            if (index == 2) {
                animation.completionBlock = ^(POPAnimation *anim, BOOL finished){
                    (!completionBlock) ? : completionBlock();
                    window = nil;
                };
            }
            animation;
        }) forKey:nil];
    }
    
}
- (IBAction)cancel {
    
    [self cancelWithCompletionBlock:nil];
    
}

@end
