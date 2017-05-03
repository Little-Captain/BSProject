//
//  LCRecommendFTVC.m
//  BSProject
//
//  Created by Liu-Mac on 4/26/17.
//  Copyright © 2017 Liu-Mac. All rights reserved.
//

#import "LCRecommendFTVC.h"
#import "LCRecommendLeftItem.h"
#import "LCRecommendRightItem.h"

#import "LCLeftTableViewCell.h"
#import "LCRightTableViewCell.h"

#import <AFNetworking.h>
#import <SVProgressHUD.h>
#import <MJExtension.h>
#import <MJRefresh.h>

#define LeftSelectedItem (self.leftList[self.leftTableView.indexPathForSelectedRow.row])

@interface LCRecommendFTVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *leftTableView;
@property (weak, nonatomic) IBOutlet UITableView *rightTableView;

/** 左边列表数组 */
@property (nonatomic, strong) NSArray<LCRecommendLeftItem *> *leftList;

/**
 * 用于存放请求参数, 这个参数用于和网络请求回调block中捕获的block进行对比
 * 如果两者相等, 表示我们的请求是我们需要的, 解析数据并刷新显示
 * 这个基本原理见一下具体代码
 */
@property (nonatomic, strong) NSDictionary *params;

/** AFN回话管理者, 这个控制的请求都是用这一个回话管理者, 便于我们管理网络请求,
 比如取消所有的网络请求
 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation LCRecommendFTVC

- (void)dealloc {
    
    LogFun();
    // 控制器销毁时, 取消所有的网络请求
    [self.manager.operationQueue cancelAllOperations];
    
}

- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
}

static NSString * const leftCellId = @"cellLeft";
static NSString * const rightCellId = @"cellRight";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"推荐关注";
    
    self.view.backgroundColor = BSGlobalColor;
    
    [self setUpTableViewOutlook];
    [self setUpRefreshView];
    [self requestLeftTableViewData];
}

- (void)setUpTableViewOutlook {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.leftTableView registerNib:[UINib nibWithNibName:@"LCLeftTableViewCell" bundle:nil] forCellReuseIdentifier:leftCellId];
    [self.rightTableView registerNib:[UINib nibWithNibName:@"LCRightTableViewCell" bundle:nil] forCellReuseIdentifier:rightCellId];
    
    // 设置空view给footer, 让tableView的显示更好看
    self.leftTableView.tableFooterView = [[UIView alloc] init];
    self.rightTableView.tableFooterView = [[UIView alloc] init];
}

/** 设置右侧tableView的刷新控件 */
- (void)setUpRefreshView {
    
    self.rightTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.rightTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    self.rightTableView.mj_footer.hidden = YES;
    
}

- (void)loadNewUsers {
    
    LCRecommendLeftItem *item = LeftSelectedItem;
    
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *paramters = @{@"a": @"list", @"c": @"subscribe", @"category_id": @(item.ID), @"page": @1};
    
    // 将最新的parameters赋值给self.params
    self.params = paramters;
    
    // 存在问题啊!!!
    // 如果用户手速快, 或者网速慢. 在一个类别的用户数组正在刷新的情况下, 用户马上点击另一个类别
    // 这时新的类别的数据属性请求不能发送, 就不能显示新的数据了.
    // 主要原因就是header的状态还在刷新状态就切换到另一个类别, 这时开始刷新, 但是header发现
    // 自己就在刷新状态, 所以就不会再进入刷新了, 也就不会再调用这个loadNewUsers方法了
    [self.manager GET:urlStr parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 取回右侧列表模型
        // 取回所有请求到的user
        item.total = [responseObject[@"total"] integerValue];
        item.currentPage = 1;
        item.users = [LCRecommendRightItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 将self.params(存放的是最新的paramters)和当时发送网络请求是捕获的paramters
        // 进行对比, 如果相等表示我们的请求是最新的请求, 返回的数据是我们的需要显示的数据
        // 不相等, 我们直接丢弃返回的数据
        if (self.params != paramters) return;
        
        // 刷新右侧表格
        [self.rightTableView reloadData];
        [self.rightTableView.mj_header endRefreshing];
        
        [self checkFooterViewState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 这里不用dismiss, 因为如果SVProgressHUD存在, 它内部会就是用这个, 来显示新的
        // 而显示error会自动退出
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
        
        [self.rightTableView.mj_header endRefreshing];
        
    }];    
}

- (void)loadMoreUsers {
    
    LCRecommendLeftItem *item = LeftSelectedItem;
    if (item.users.count >= item.total) return;
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *paramters = @{@"a": @"list", @"c": @"subscribe", @"category_id": @(item.ID), @"page": @(++item.currentPage)};
    
    // 将最新的parameters赋值给self.params
    self.params = paramters;
    
    [self.manager GET:urlStr parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 取回所有请求到的user
        item.users = [item.users arrayByAddingObjectsFromArray:[LCRecommendRightItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
        // 将self.params(存放的是最新的paramters)和当时发送网络请求是捕获的paramters
        // 进行对比, 如果相等表示我们的请求是最新的请求, 返回的数据是我们的需要显示的数据
        // 不相等, 我们直接丢弃返回的数据
        if (self.params != paramters) return;
        
        // 刷新右侧表格
        [self.rightTableView reloadData];
        
        [self checkFooterViewState];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 这里不用dismiss, 因为如果SVProgressHUD存在, 它内部会就是用这个, 来显示新的
        // 而显示error会自动退出
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
        [self.rightTableView.mj_footer endRefreshing];
    }];
    
}

/** 请求左侧表格数据 */
- (void)requestLeftTableViewData {
    
    [SVProgressHUD show];
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *paramters = @{@"a": @"category", @"c": @"subscribe"};
    [self.manager GET:urlStr parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        
        [LCRecommendLeftItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"ID": @"id"};
        }];
        
        // 取出左侧列表模型数组
        self.leftList = [LCRecommendLeftItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.leftTableView reloadData];
        // 默认选中第一个行
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self.rightTableView.mj_header beginRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 这里不用dismiss, 因为如果SVProgressHUD存在, 它内部会就是用这个, 来显示新的
        // 而显示error会自动退出
        [SVProgressHUD showErrorWithStatus:@"网络请求失败"];
    }];
    
}

/** 实时检查footer的状态 */
- (void)checkFooterViewState {
    
    // 通过users返回右侧行数
    LCRecommendLeftItem *item = LeftSelectedItem;
    // 每次刷新表格都会来到这个询问表格的行数
    // 所以在这里设置刷新控件的隐藏或是显示
    // 没用任何用户数据就需要隐藏
    self.rightTableView.mj_footer.hidden = (!item.users.count);
    // 设置上拉刷新控件的状态, 这个状态是和模型数据息息相关的
    // 这里的细节控制的思路就是: 右边的tableView是大家共用的, 只有一个footer和一个
    // header, 他们状态不改变就会保留上次的不变. 所以在左边切换时, 就要通过实际的选中
    // 情况改变footer和header的状态.
    if (item.users.count >= item.total) {
        [self.rightTableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self.rightTableView.mj_footer setState:MJRefreshStateIdle];
    }
    
}

#pragma mark - UITableViewDataSource

// 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // 左边表格
    if (tableView == self.leftTableView) return self.leftList.count;
    
    // 检查状态并更新
    [self checkFooterViewState];
    
    // 返回用户数
    return [LeftSelectedItem users].count;
}

// 返回具体的cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        LCLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellId];
        
        LCRecommendLeftItem *item = self.leftList[indexPath.row];
        cell.textLabel.text = item.name;
        
        return cell;
    } else {
        LCRightTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rightCellId];
        LCRecommendLeftItem *lItem = LeftSelectedItem;
        // 取出右侧cell的模型
        LCRecommendRightItem *rItem = lItem.users[indexPath.row];
        cell.item = rItem;
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate

// 选中某一个cell时调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        
        // 以下操作为下载右侧数据, 并且解决了用户来回点击的重复下载问题
        // 取出当前左侧选中的列表的模型
        LCRecommendLeftItem *item = self.leftList[indexPath.row];
        // 判断模型中的users中是否有数据
        if (item.users.count) { // 有直接刷新, 不要在下载了
            [self.rightTableView reloadData];
        } else { // 没有就下载
            // 显示当前表格的数据, 不要显示上一个表格的残留数据
            [self.rightTableView reloadData];
            
            // 发送网络请求, 得到表格的第一页数据
            // 不直接发送网络请求, 我们让表格进入下拉刷新状态
            [self.rightTableView.mj_header beginRefreshing];
        }
        
    }
}

// 询问cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.leftTableView) {
        return 44.0;
    } else {
        return 70.0;
    }
}

@end
