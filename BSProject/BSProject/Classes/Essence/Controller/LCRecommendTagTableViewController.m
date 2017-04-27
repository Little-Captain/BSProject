//
//  LCRecommendTagTableViewController.m
//  BSProject
//
//  Created by Liu-Mac on 08/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCRecommendTagTableViewController.h"

#import "LCRecTagItem.h"
#import "LCRecTagTableViewCell.h"

#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <AFNetworking.h>

@interface LCRecommendTagTableViewController ()

/** tagItems */
@property (nonatomic, strong) NSArray *tagItems;

@end

@implementation LCRecommendTagTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐订阅";
    
    [self setUpTableView];
    [self loadTagData];
}

- (void)setUpTableView {
    
    self.tableView.backgroundColor = BSGlobalColor;
    self.tableView.rowHeight = 70.0;
    // 补回cell下移的距离, 让其可以自由滚动
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 1, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRecTagTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"tagCell"];
    
}

- (void)loadTagData {
    
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *parameters = @{@"a": @"tags_list", @"c": @"subscribe"};
    [SVProgressHUD show];
    [[AFHTTPSessionManager manager] GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.tagItems = [LCRecTagItem mj_objectArrayWithKeyValuesArray:responseObject[@"rec_tags"]];
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tagItems.count;
}

#pragma mark - Table view delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCRecTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tagCell"];
    
    cell.item = self.tagItems[indexPath.row];
    
    return cell;    
}

@end
