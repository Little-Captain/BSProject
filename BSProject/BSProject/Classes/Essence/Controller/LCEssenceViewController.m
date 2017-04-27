//
//  LCEssenceViewController.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCEssenceViewController.h"

@interface LCEssenceViewController ()

@end

@implementation LCEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpNav];
}

- (void)setUpNav {
    
    // 设置导航条标题
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    // 设置左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(mainTagClick) image:@"MainTagSubIcon" hightImage:@"MainTagSubIconClick"];
}

- (void)mainTagClick {
    
    [self.navigationController pushViewController:[NSClassFromString(@"LCRecommendTagTableViewController") new] animated:YES];
}

@end
