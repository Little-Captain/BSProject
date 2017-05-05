//
//  LCMainTabBarC.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCMainTabBarC.h"
#import "LCPublishView.h"
#import "LCMainNavigationC.h"

#import <RXCollection.h>

@interface LCMainTabBarC ()

@end

@implementation LCMainTabBarC

+ (void)initialize {
    // 要加这个判断, 不然如果是子类第一次被使用也会调用这个方法
    if (self == [LCMainTabBarC class]) {
        // 通过appearance统一设置UITabBarItem的文字属性
        // 凡是后面带有UI_APPEARANCE_SELECTOR的方法, 都可以通过appearance对象统一设置
        // normal 状态下的 title 属性
        NSDictionary *attrNormal = @{
                               NSFontAttributeName: [UIFont systemFontOfSize:12],
                               NSForegroundColorAttributeName: [UIColor lightGrayColor]
                               };
        // selected 状态下的 title 属性
        NSDictionary *attrSelected = @{
                                  NSForegroundColorAttributeName: [UIColor darkGrayColor]
                                  };
        // 对所有的 UITabBarItem 对象统一设置
        UITabBarItem *tabBarItem = [UITabBarItem appearance];
        [tabBarItem setTitleTextAttributes:attrNormal forState:UIControlStateNormal];
        [tabBarItem setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
    }
}

static LCMainTabBarC *_instance;
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [LCMainTabBarC new];
    });
    
    return _instance;
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
//    [LCTopWindow show];
}

/** 创建所有的子控制器 */
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
    
    // 将 NSDictionary 对象 映射为 UIViewController 对象
    self.viewControllers = [array rx_mapWithBlock:^UIViewController *(NSDictionary *each) {
        return [self setUpOneViewController:each];
    }];
}

/** 创建一个子控制器 */
- (UIViewController *)setUpOneViewController:(NSDictionary *)vcInfo {
    
    // 获取控制器的类名
    NSString *clsName = vcInfo[@"clsName"];
    if (!clsName) {
        // 获取失败, 返回一个默认的控制器
        return [[NSClassFromString(@"LCMainNavigationC") alloc] initWithRootViewController:[UIViewController new]];
    }
    
    // 获取设置控制器需要的其他字段
    NSString *title = vcInfo[@"title"];
    NSString *image = vcInfo[@"image"];
    NSString *selImage = vcInfo[@"selImage"];
    
    // 返回
    return ({
        // 创建控制器对象
        UIViewController *vc = [[NSClassFromString(clsName) alloc] init];
        if (vc == nil) {
            // 创建失败, 抛出异常
            [NSException exceptionWithName:clsName reason:nil userInfo:nil];
        }
        // 包装导航控制器, 并进行设置
        UINavigationController *nav = [[NSClassFromString(@"LCMainNavigationC") alloc] initWithRootViewController:vc];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
        nav.title = title;
        nav.tabBarItem.image = [UIImage imageNamed:image];
        nav.tabBarItem.selectedImage = [[UIImage imageNamed:selImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav;
    });
}

/** 创建中间的发布按钮 */
- (void)setUpComposeButton {
    
    // 添加到 tabbar 上
    [self.tabBar addSubview:({
        // 创建一个按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(publishBtnClick) forControlEvents:UIControlEventTouchUpInside];
        // 计算按钮的宽度
        CGFloat w = self.tabBar.bWidth / self.childViewControllers.count;
        // 设置按钮的 frame
        btn.frame = CGRectInset(self.tabBar.bounds, w * 2.0, 0);
        btn;
    })];
}

/** 发布按钮点击事件的监听 */
- (void)publishBtnClick {
    
    // 显示发布视图
    [LCPublishView show];
}

/** 当前控制器屏幕方向支持 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    // 让应用一般情况下只支持横屏
    return UIInterfaceOrientationMaskPortrait;
}

/** 当进入这个控制器时, 是否自动旋转到支持的屏幕方向 */
- (BOOL)shouldAutorotate {
    
    return YES;
}

@end
