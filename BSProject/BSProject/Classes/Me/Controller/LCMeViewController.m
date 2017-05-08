//
//  LCMeViewController.m
//  BSProject
//
//  Created by Liu-Mac on 4/25/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCMeViewController.h"
#import "LCMeFooterView.h"
#import "LCSettingVC.h"
#import "LCUserInfoItem.h"

#import <YYWebImage.h>

@interface LCMeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headIconImageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;

@end

@implementation LCMeViewController

- (instancetype)init {
    
    return [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:nil].instantiateInitialViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpNav];
    
    [self setUpTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 获取用户信息
    // 获取归档路径
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"user"];
    // 解档
    LCUserInfoItem *user = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    [_headIconImageV yy_setImageWithURL:[NSURL URLWithString:user.iconurl] placeholder:[UIImage imageNamed:@"setup-head-default"]];
    _nameL.text = user.name ? user.name : @"登录/注册";
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

- (void)setUpTableView {
    
    // 设置背景色
    self.tableView.backgroundColor = BSGlobalColor;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 调整 tableView 的 header 和 footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = EssenceCellMargin;
    
    // 调整 tableView 的 内边距 inset
    // 这个 35 是系统默认的第一组的顶部内边距
    self.tableView.contentInset = UIEdgeInsetsMake(EssenceCellMargin - 35, 0, 0, 0);
    
    // 设置footerView
    // 用为 LCMeFooterView 内部的 按钮是异步创建的, 所以要等到创建完后才能设置 tableFooterView, 不然得不到正确的 frame
    // 其实是正确的 height
    [[LCMeFooterView new] setCreateCompletedBlock:^(LCMeFooterView *footerView){
        self.tableView.tableFooterView = footerView;
    }];
}

- (void)settingBtnClick {
    
    [self.navigationController pushViewController:[[LCSettingVC alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
}

- (void)nightModBtnClick {
    
    LogFun();    
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self presentViewController:[NSClassFromString(@"LCLoginOrRegistVC") new] animated:YES completion:nil];
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        NSLog(@"离线下载");
    }
}

#pragma mark - UITableViewDataSource



@end
