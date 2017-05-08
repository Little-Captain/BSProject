//
//  LCUserInfoVC.m
//  BSProject
//
//  Created by Liu-Mac on 5/8/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCUserInfoVC.h"
#import "LCUserInfoItem.h"
#import "LCUserTool.h"

#import <YYWebImage.h>
#import <SVProgressHUD.h>

@interface LCUserInfoVC ()

@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *genderL;

@end

@implementation LCUserInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    if (!_userInfo) return;
    
    [_iconV yy_setImageWithURL:[NSURL URLWithString:_userInfo.iconurl] placeholder:[UIImage imageNamed:@"setup-head-default"]];
    _nameL.text = _userInfo.name;
    _genderL.text = ([_userInfo.gender isEqualToString:@"m"]) ? @"男" : @"女";
}

- (IBAction)logoutBtnClick {
    
    [LCUserTool clearUserInfo];
    
    [SVProgressHUD showSuccessWithStatus:@"退出成功"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
