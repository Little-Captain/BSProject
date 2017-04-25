//
//  LCMeViewController.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCMeViewController.h"

@interface LCMeViewController ()

@end

@implementation LCMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpNav];
}

- (void)setUpNav {
    
    // 设置导航条标题
    self.navigationItem.title = @"我的";
    
    // 设置右边按钮
    self.navigationItem.rightBarButtonItems = @[
                                                [UIBarButtonItem itemWithTarget:self action:@selector(settingBtnClick) image:@"mine-setting-icon" hightImage:@"mine-setting-icon-click"],
                                                [UIBarButtonItem itemWithTarget:self action:@selector(nightModBtnClick) image:@"mine-moon-icon" hightImage:@"mine-moon-icon-click"]
                                                ];
}

- (void)settingBtnClick {
    
    LogFun();
}

- (void)nightModBtnClick {
    
    LogFun();
    
}

@end
