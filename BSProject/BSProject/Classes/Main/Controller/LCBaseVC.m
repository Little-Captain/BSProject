//
//  LCBaseVC.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCBaseVC.h"
#import "LCTopicTableViewController.h"

// titleBtn 选中的文字颜色
#define TitleSelColor (LCColor(225, 60, 27))
// titleBtn 默认的文字颜色
#define TitleDeSelColor (LCColor(150, 150, 150))

@interface LCBaseVC () <UIScrollViewDelegate>

/** 所有title按钮的容器view */
@property (nonatomic, weak) UIView *titlesView;

/** 指示view, 指示当前选中的按钮 */
@property (nonatomic, weak) UIView *indicateView;

/** 当前选中的按钮 */
@property (nonatomic, weak) UIButton *currentSelBtn;

/** 用于容纳所有的子控制器的view */
@property (nonatomic, weak) UIScrollView *contentView;

@end

@implementation LCBaseVC

// 懒加载titlesView
- (UIView *)titlesView {
    
    if (!_titlesView) {
        UIView *titlesView = [[UIView alloc] init];
        _titlesView = titlesView;
        titlesView.fWidth = self.view.fWidth; // 宽度为整个屏幕宽度
        titlesView.fHeight = EssenceTitleViewH; // 高度设置为35.0
        titlesView.fX = 0; // x
        titlesView.fY = EssenceTitleViewY; // y设置为20.0 + 44.0
        titlesView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7]; // 背景颜色
        [self.view addSubview:titlesView];
    }
    
    return _titlesView;
    
}

// 懒加载indicateView
- (UIView *)indicateView {
    
    if (!_indicateView) {
        UIView *indicateView = [[UIView alloc] init];
        _indicateView = indicateView;
        indicateView.backgroundColor = TitleSelColor; // 设置指示器颜色为红色
        indicateView.fHeight = 2.0; // 高度
        indicateView.fY = self.titlesView.fHeight - indicateView.fHeight; // y
        [self.titlesView addSubview:indicateView];
    }
    
    return _indicateView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置scrollView不要自动调整内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 这只view的背景颜色
    self.view.backgroundColor = BSGlobalColor;
    
    // 添加所有的子控制器
    [self addAllVces];
    
    [self setUpNav]; // 初始化导航条
    
    [self setUpTitlesView]; // 初始化titlesView及其内容
    
    [self setUpContentView]; // 设置显示内容的contentview, 其实是一个scrollView
    
    [self scrollViewDidScroll:self.contentView]; // 手动调用滑动, 让其改变titlesView的btn的状态
    [self scrollViewDidEndDecelerating:self.contentView]; // 手动调用滑动减速完成, 让其添加第一个控制器的view
    
}

- (void)addAllVces {
    
    // 子控制器控制器类型字符串数组
    NSArray *titles = @[
                        @"全部",
                        @"视频",
                        @"图片",
                        @"声音",
                        @"段子"
                        ];
    
    LCTopicType types[5] = {
        LCTopicTypeAll,
        LCTopicTypeVideo,
        LCTopicTypePicture,
        LCTopicTypeVoice,
        LCTopicTypeWord
    };
    
    NSString *category = nil;
    
    if ([self isMemberOfClass:NSClassFromString(@"LCEssenceViewController")]) {
        category = @"list";
    }
    if ([self isMemberOfClass:NSClassFromString(@"LCNewViewController")]) {
        category = @"newlist";
    }
    
    // 添加子控制器
    NSInteger index = 0;
    for (NSString *title in titles) {
        LCTopicTableViewController *vc = [[LCTopicTableViewController alloc] init];
        vc.title = title;
        vc.category = category;
        vc.type = types[index++];
        [self addChildViewController:vc];
    }
    
}

- (void)setUpNav {
    
    // 设置导航条标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(mainTagClick) image:@"MainTagSubIcon" hightImage:@"MainTagSubIconClick"];
    
}

- (void)setUpTitlesView {
    
    // 每个按钮的宽度和高度
    NSInteger count = self.childViewControllers.count;
    CGFloat btnW = self.titlesView.fWidth / count;
    CGFloat btnH = self.titlesView.fHeight;
    
    // 遍历创建和设置按钮的属性
    for (NSInteger i = 0; i < count; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = i; // 绑定一个tag便于后面使用
        btn.frame = CGRectMake(btnW * i, 0, btnW, btnH); // 设置frame
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal]; // 指定按钮标题
        [btn setTitleColor:TitleDeSelColor forState:UIControlStateNormal]; // 指定按钮未选中的颜色
        [btn setTitleColor:TitleSelColor forState:UIControlStateDisabled]; // 指定按钮选中后的颜色
        [btn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchUpInside]; // 指定点击按钮后的动作
        [btn.titleLabel sizeToFit]; // 让按钮内的titleLabel自适应尺寸
        [self.titlesView addSubview:btn];
    }
    
}

- (void)setUpContentView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 创建contentView
    UIScrollView *contentView = [[UIScrollView alloc] init];
    
    contentView.delegate = self;
    
    contentView.frame = self.view.bounds;
    
    // 设置内容size
    contentView.contentSize = CGSizeMake(contentView.fWidth * self.childViewControllers.count, 0);
    
    contentView.pagingEnabled = YES;
    
    self.contentView = contentView;
    
    [self.view insertSubview:contentView atIndex:0];
    
}

// 点击按钮后调用, 这个方法中启动动画移动contentView
- (void)titleBtnClick:(UIButton *)btn {
    
    // 这里不要用直接设置这个contentOffset, 因为这样没有动画
    // self.contentView.contentOffset = CGPointMake(offsetX, 0);
    // 这样有动画, 动画完成就可以调用scrollViewDidEndScrollingAnimation方法处理
    // 滚动完成要做什么了
    CGFloat offsetX = self.contentView.fWidth * btn.tag;
    [self.contentView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    
}

// 这个方法负责改变, 按钮的状态
- (void)changeBtnStatusWithIndex:(NSInteger)index {
    
    // 得到应该选中的btn
    UIButton *shouldSelBtn = nil;
    for (UIButton *btn in self.titlesView.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.tag == index) {
            shouldSelBtn = btn;
            break;
        }
    }
    // 如果为空直接返回
    if (!shouldSelBtn) {
        return;
    }
    
    // 选中后, 把前一个btn状态设置为可选中
    self.currentSelBtn.enabled = YES;
    // 更新当前选中的btn
    self.currentSelBtn = shouldSelBtn;
    // 并把当前选中的btn设置为不可选中状态
    self.currentSelBtn.enabled = NO;
    
    // 动画设置指示器的宽度和位置
    [UIView animateWithDuration:0.25 animations:^{
        self.indicateView.fWidth = shouldSelBtn.titleLabel.fWidth;
        self.indicateView.cX = shouldSelBtn.cX;
    }];
    
}

- (void)mainTagClick {
    
    [self.navigationController pushViewController:[NSClassFromString(@"LCRecommendTagTableViewController") new] animated:YES];
    
}

#pragma mark - UIScrollViewDelegate

// 只要scrollView滚动了, 就会调用, 实时设置按钮的状态
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 滚动过程中就实时改变按钮的状态
    CGFloat offSet = self.contentView.contentOffset.x / self.contentView.fWidth;
    [self changeBtnStatusWithIndex:round(offSet)];
    
}

// 减速完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
}

// 动画完毕
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    // 得到当前的index
    NSInteger index = self.contentView.contentOffset.x / self.contentView.fWidth;
    
    // 添加子控制器的view到当前contentView上
    UIViewController *vc = self.childViewControllers[index];
    if ([vc isViewLoaded]) {
        return;
    }
    UITableView *view = (UITableView *)vc.view;
    // 这时view的位置和大小
    view.fX = self.contentView.fWidth * index;
    view.fY = 0; // 这个默认是20
    view.fHeight = self.contentView.fHeight; // 这个默认比屏幕高度小20
    view.fWidth = self.contentView.fWidth;
    
    [self.contentView addSubview:view];
    
}

@end
