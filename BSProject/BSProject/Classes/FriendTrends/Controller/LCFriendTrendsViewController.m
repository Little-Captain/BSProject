//
//  LCFriendTrendsViewController.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCFriendTrendsViewController.h"
#import "LCUserTool.h"

@interface LCFriendTrendsViewController ()

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *textL;

@end

@implementation LCFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpUI];
}

- (void)setUpUI {
    
    [self setUpNav];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if ([LCUserTool getLogInUser]) {
        
        _loginBtn.selected = YES;
        _loginBtn.userInteractionEnabled = NO;
        _textL.text = @"快快关注吧, 关注百思最in牛人\n好友动态让你过把瘾儿~\n欧耶~~~~~!";
    } else {
        _loginBtn.selected = NO;
        _loginBtn.userInteractionEnabled = YES;
        _textL.text = @"快快登录吧, 关注百思最in牛人\n好友动态让你过把瘾儿~\n欧耶~~~~~!";
    }
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
- (IBAction)loginOrRegist {
    
    [self presentViewController:[NSClassFromString(@"LCLoginOrRegistVC") new] animated:YES completion:nil];
}

@end
