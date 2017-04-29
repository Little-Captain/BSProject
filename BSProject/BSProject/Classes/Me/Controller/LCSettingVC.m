//
//  LCSettingVC.m
//  BSProject
//
//  Created by Liu-Mac on 2/17/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCSettingVC.h"
#import <SDImageCache.h>
#import <SVProgressHUD.h>

@interface LCSettingVC ()

@end

@implementation LCSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    // 这个 getSize 比较慢
    cell.textLabel.text = [@"清理缓存" stringByAppendingFormat:@"(已使用%.2fM)", [SDImageCache sharedImageCache].getSize / 1000.0 / 1000.0];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) { // 点击了清楚 cell
        [SVProgressHUD showWithStatus:@"正在清理"];
        // 区分: clear(清除) 和 clean(清理)
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [SVProgressHUD showSuccessWithStatus:@"缓存清理完成"];
            // 这个完成回调在主队列中执行
            [self.tableView reloadData];
        }];
    }
}

@end
