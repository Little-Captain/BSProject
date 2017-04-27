//
//  LCFriendTrendsViewController.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCFriendTrendsViewController.h"

@interface LCFriendTrendsViewController ()

@end

@implementation LCFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpNav];
}

- (void)setUpNav {
    
    // 设置导航条标题
    self.navigationItem.title = @"我的关注";
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(friendsRecommenClick) image:@"friendsRecommentIcon" hightImage:@"friendsRecommentIcon-click"];
}

- (void)friendsRecommenClick {
    
    [self.navigationController pushViewController:[NSClassFromString(@"LCRecommendFTVC") new] animated:YES];
}

@end
