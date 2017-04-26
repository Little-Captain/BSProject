//
//  LCMainNavigationC.m
//  BSProject
//
//  Created by Liu-Mac on 4/26/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCMainNavigationC.h"

@interface LCMainNavigationC ()

@end

@implementation LCMainNavigationC

// 一次性设置放入这个方法中
+ (void)initialize
{
    if (self == [LCMainNavigationC class]) {
        UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[LCMainNavigationC class]]];
        [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 如果childViewControllers的个数大于0, 代表根控制器已经push了
    if (self.childViewControllers.count > 0) { // 非根控制器
        // 这里定制左边的按钮, 让其成为返回按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        [btn setTitle:@"返回" forState:UIControlStateNormal];
        [btn setTitle:@"返回" forState:UIControlStateHighlighted];
        // 调整content的内容边距, 这样可以让btn看上去左移了
        // 这样调整后的按钮外部的内容是可以点击的
        // 调整为-11的原因是, 开始我们的按钮距离左边的距离是16, 这样可以让按钮看上去距离左边为5
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, -11, 0, 0);
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        // 这样定制了左边按钮在控制器的view加载之前, 我们可以在控制器的loadView中进行重新定制左边按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        // 隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    // 这句话放在后面和放在前面是有区别的
    // 前面: 在子控制器中不可再次定制返回按钮
    // 后面: 在子控制器中可以再次定制返回按钮
    [super pushViewController:viewController animated:animated];
}

- (void)back {
    
    [self popViewControllerAnimated:YES];
    
}

@end
