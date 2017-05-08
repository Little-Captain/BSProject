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
#import <YYModel.h>
#import <LCNetworking.h>

@interface LCRecommendTagTableViewController ()

/** 模型数组 */
@property (nonatomic, strong) NSArray *tagItems;

@end

@implementation LCRecommendTagTableViewController

#pragma mark -

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"推荐订阅";
    
    [self setUpTableView];
    [self loadTagData];
}

/** 设置 TableView */
- (void)setUpTableView {
    
    // 设置背景颜色
    self.tableView.backgroundColor = BSGlobalColor;
    // 设置 cell 行高
    self.tableView.rowHeight = 70.0;
    // 补回cell下移的距离, 让其可以自由滚动
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 1, 0);
    // 不需要系统自带的分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置 table 的 footer view, 让表格比较好看
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 注册 自定义 xib cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCRecTagTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"tagCell"];
}

/** 加载网络数据 */
- (void)loadTagData {
    
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *parameters = @{@"a": @"tags_list", @"c": @"subscribe"};
    [SVProgressHUD show];

    __weak typeof(self) weakSelf = self;
    [[LCHTTPSessionManager sharedInstance] request:LCHttpMethodGET urlStr:urlStr parameters:parameters completion:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            // 字典数组转模型数组
            weakSelf.tagItems = [NSArray yy_modelArrayWithClass:[LCRecTagItem class] json:result[@"rec_tags"]];
            // 刷新表格
            [weakSelf.tableView reloadData];
            [SVProgressHUD dismiss];
        } else {
            [SVProgressHUD showErrorWithStatus:@"数据加载失败"];
        }
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
