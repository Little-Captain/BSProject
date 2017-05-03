//
//  LCSettingVC.m
//  BSProject
//
//  Created by Liu-Mac on 2/17/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCSettingVC.h"
#import <YYCache.h>
#import <YYImageCache.h>
#import <SVProgressHUD.h>

@interface LCSettingVC ()

/** 缓存总大小 */
@property (nonatomic, assign) NSInteger totalCost;

@end

@implementation LCSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    [self getDiskCache];
}

- (void)getDiskCache {
    
    [[YYImageCache sharedCache].diskCache totalCostWithBlock:^(NSInteger totalCost) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.totalCost = totalCost;
        });
    }];
}

- (void)setTotalCost:(NSInteger)totalCost {
    
    _totalCost = totalCost;
    
    [self.tableView reloadData];
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

    cell.textLabel.text = [@"清理缓存" stringByAppendingFormat:@"(已使用%.2fM)", _totalCost / 1000.0 / 1000.0];
    // 这个 getSize 比较慢
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && indexPath.row == 0) { // 点击了清楚 cell
        [SVProgressHUD showWithStatus:@"正在清理"];
        [[YYImageCache sharedCache].diskCache removeAllObjectsWithBlock:^{
            [SVProgressHUD showSuccessWithStatus:@"缓存清理完成"];
            // 重新获取缓存大小
            [self getDiskCache];
        }];
    }
}

@end
