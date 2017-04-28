//
//  LCMeFooterView.m
//  BSProject
//
//  Created by Liu-Mac on 4/28/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCMeFooterView.h"

#import "LCSquareItem.h"
#import "LCSqaureButton.h"
#import "LCWebViewController.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <RXCollection.h>

@implementation LCMeFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSArray *squares = [LCSquareItem mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            
            // 这个算法用于过滤重复项
            NSMutableArray<NSString *> *names = [NSMutableArray array];
            squares = [squares rx_filterWithBlock:^BOOL(LCSquareItem *each) {
                if ([names containsObject:each.name]) {
                    return NO;
                } else {
                    [names addObject:each.name];
                    return YES;
                }
            }];
            
            // 创建方块
            [self createSquares:squares];
            // 执行 block 回调
            if (_createCompletedBlock) {
                _createCompletedBlock(self);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
            // 执行 block 回调
            if (_createCompletedBlock) {
                _createCompletedBlock(nil);
            }
        }];
    }
    return self;
}

- (void)createSquares:(NSArray *)squares {
    
    // 一行 4 列
    int maxCols = 4;
    // 宽度和高度
    CGFloat buttonW = ScreenW / maxCols;
    CGFloat buttonH = buttonW;
    for (int i = 0; i<squares.count; ++i) {
        // 创建按钮
        LCSqaureButton *button = [LCSqaureButton buttonWithType:UIButtonTypeCustom];
        // 监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        button.square = squares[i];
        [self addSubview:button];
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        button.fX      = col * buttonW;
        button.fY      = row * buttonH;
        button.fWidth  = buttonW;
        button.fHeight = buttonH;
    }
    // 总页数 == (总个数 - 1) / 每页最大数 + 1
    // 总行数 == (总个数 - 1) / 每页最大数 + 1
    NSUInteger rows = (squares.count + maxCols - 1) / maxCols;    
    // 计算footer的高度
    self.fHeight = rows * buttonH;
}

#pragma mark - 监听 button 的点击
- (void)buttonClick:(LCSqaureButton *)button {
    
    // 如果不是网址, 就直接返回
    if (![button.square.url hasPrefix:@"http"]) return;
    
    LCWebViewController *web = [[LCWebViewController alloc] init];
    web.url = button.square.url;
    web.title = button.square.name;
    
    // 取出当前的导航控制器
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVc.selectedViewController;
    [nav pushViewController:web animated:YES];
}

@end
