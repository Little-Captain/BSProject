//
//  LCMainTabBarC.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCMainTabBarC.h"

#import "LCPublishView.h"
#import "LCTopWindow.h"

#import "LCMainNavigationC.h"

@interface LCMainTabBarC ()

@end

@implementation LCMainTabBarC

+ (void)initialize
{
    // 要加这个判断, 不然如果是子类第一次被使用也会调用这个方法
    if (self == [LCMainTabBarC class]) {
        // 通过appearance统一设置UITabBarItem的文字属性
        // 凡是后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象统一设置
        NSDictionary *attr = @{
                               NSFontAttributeName: [UIFont systemFontOfSize:12],
                               NSForegroundColorAttributeName: [UIColor lightGrayColor]
                               };
        
        NSDictionary *attrSel = @{
                                  NSForegroundColorAttributeName: [UIColor darkGrayColor]
                                  };
        
        UITabBarItem *tabBarItem = [UITabBarItem appearance];
        
        [tabBarItem setTitleTextAttributes:attr forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:attrSel forState:UIControlStateSelected];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置tabBar的背景图片
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    
    // 设置所有的子控制器
    [self setUpChildViewControllers];
    // 设置中间的发布按钮
    [self setUpComposeButton];
    
    // 设置顶部的 window 用于控制点击顶部回滚效果
    [LCTopWindow show];
}

// 创建所有的子控制器
- (void)setUpChildViewControllers {
    
    // 通过 UI.json 确定界面的显示
    // 获取沙盒中的 UI.json 路径
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    // 获取 UI.json 文件的数据
    NSData *data = [NSData dataWithContentsOfFile:[path stringByAppendingPathComponent:@"UI.json"]];
    // 反序列化得到OC对象
    NSArray *array = nil;
    if (data) { // 获取数据成功
        array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    } else { // 获取数据失败, 使用 bundle 中的最原始数据
        path = [[NSBundle mainBundle] pathForResource:@"UI" ofType:@"json"];
        data = [NSData dataWithContentsOfFile:path];
        array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }
    
    NSMutableArray *controllers = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [controllers addObject:[self setUpOneViewController:dict]];
    }
    
    self.viewControllers = controllers.copy;
}

// 创建一个子控制器
- (UIViewController *)setUpOneViewController:(NSDictionary *)vcInfo {
    
    NSString *clsName = vcInfo[@"clsName"];
    
    if (!clsName) {
        return [[NSClassFromString(@"LCMainNavigationC") alloc] initWithRootViewController:[UIViewController new]];
    }
    
    NSString *title = vcInfo[@"title"];
    NSString *image = vcInfo[@"image"];
    NSString *selImage = vcInfo[@"selImage"];
    
    UIViewController *vc = [[NSClassFromString(clsName) alloc] init];
    
    if (vc == nil) {
        [NSException exceptionWithName:clsName reason:nil userInfo:nil];
    }
    
    UINavigationController *nav = [[NSClassFromString(@"LCMainNavigationC") alloc] initWithRootViewController:vc];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    nav.title = title;
    nav.tabBarItem.image = [UIImage imageNamed:image];
    nav.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];    
    
    return nav;
}

// 创建中间的发布按钮
- (void)setUpComposeButton {
    
    // 创建一个按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
    // 计算按钮的宽度
    CGFloat w = self.tabBar.bWidth / self.childViewControllers.count;
    // 设置按钮的 frame
    btn.frame = CGRectInset(self.tabBar.bounds, w * 2.0, 0);
    // 添加到 tabbar 上
    [self.tabBar addSubview:btn];
}

// 发布按钮点击事件的监听
- (void)publishBtnClick {
    
    [LCPublishView show];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    // 让应用一般情况下只支持横屏
    return UIInterfaceOrientationMaskPortrait;
}

@end
