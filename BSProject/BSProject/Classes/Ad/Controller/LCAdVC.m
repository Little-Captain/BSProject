//
//  LCAdVC.m
//  BSProject
//
//  Created by Liu-Mac on 5/4/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCAdVC.h"
#import "LCAdItem.h"
#import "LCMainTabBarC.h"
#import "LCPushGuideView.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <YYWebImage.h>

@interface LCAdVC ()

@property (weak, nonatomic) IBOutlet UIButton *skipBtn;

/** ad 模型 */
@property (nonatomic, strong) LCAdItem *adItem;

/** timer */
@property (nonatomic, weak) NSTimer *timer;

@end

@implementation LCAdVC

#pragma mark -
#pragma mark setter

- (void)setAdItem:(LCAdItem *)adItem {
    
    _adItem = adItem;
    
    // 宽度为 0 直接返回
    if (!adItem.w) return;
    // 计算高度
    CGFloat h = adItem.h * ScreenW / adItem.w;
    [self.view insertSubview:({
        UIImageView* imageView = [NSClassFromString(@"YYAnimatedImageView") new];
        imageView.frame = CGRectMake(0, 0, ScreenW, h);
        imageView.userInteractionEnabled = YES;
        // 给 adImageView 增加一个点击手势
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAdImageV)];
        [imageView addGestureRecognizer:tap];
        [imageView yy_setImageWithURL:[NSURL URLWithString:adItem.w_picurl] options:kNilOptions];
        imageView;
    }) atIndex:0];    
    
    // 启动定时器
    [self.timer fire];
}

#pragma mark -
#pragma mark 懒加载
- (NSTimer *)timer {
    
    if (!_timer) {
        // 创建倒计时定时器
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
            static int second = 3;
            // 更新按钮的 title 显示
            NSString* title = [NSString stringWithFormat:@"跳过(%d)",second];
            [_skipBtn setTitle:title forState:UIControlStateNormal];
            // 到达 3s
            if ((second--) <= -1) {
                [self skipBtnClick];
            }
        }];
        // 将定时器加入 runloop 中
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        _timer = timer;
    }
    
    return _timer;
}

#pragma mark -

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadAdData];
}

#pragma mark -
#pragma mark 事件监听

- (IBAction)skipBtnClick {
    
    [self.timer invalidate];
    self.timer = nil;
    
    // 切换到主控制器
    KeyWindow.rootViewController = [LCMainTabBarC sharedInstance];
    
    // 显示引导页
    [LCPushGuideView show];
}

/** 点击了图片就跳转 */
-(void)tapAdImageV{
    
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_adItem.ori_curl]]) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_adItem.ori_curl]];
    }
}

#pragma mark -
#pragma mark 数据加载

- (void)loadAdData {
    
    // url 和 参数
    NSString *urlStr = @"http://mobads.baidu.com/cpro/ui/mads.php";
    NSDictionary *paramters = @{@"code2": @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"};
    
    [[LCHTTPSessionManager sharedInstance] request:LCHttpMethodGET urlStr:urlStr parameters:paramters completion:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            NSArray* adArray = result[@"ad"];
            if (adArray.count==0) return;
            // 取出第一个字典
            NSDictionary* adDict = adArray.firstObject;
            // 字典转模型
            self.adItem = [LCAdItem mj_objectWithKeyValues:adDict];
        } else {
            [self skipBtnClick];
            
            NSLog(@"%@", result);
            
            NSLog(@"广告加载失败");
        }
    }];
}

@end
