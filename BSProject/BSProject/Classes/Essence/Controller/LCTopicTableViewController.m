//
//  LCTopicTableViewController.m
//  BSProject
//
//  Created by Liu-Mac on 10/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCTopicTableViewController.h"

#import "LCCmtDetailViewController.h"
#import "LCTopicItem.h"
#import "LCTopicCell.h"
#import "LCShareTool.h"

#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <RXCollection.h>

@interface LCTopicTableViewController ()

/** topics 模型数组 */
@property (nonatomic, strong) NSArray *topics;

/** maxtime */
@property (nonatomic, strong) NSString *currentMaxtime;

/** 上一次选中的 tabBar index */
@property (nonatomic, assign) NSUInteger lastSelectedIndex;

@end

@implementation LCTopicTableViewController

static NSString * const ID = @"topic";

#pragma mark - 

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 设置 table view
    [self setUpTableView];
    // 设置 刷新控件
    [self setUpRefreshView];
    // 开始下拉刷新
    [self.tableView.mj_header beginRefreshing];
    
    // 监听 tabbar 点击通知
    [NotificationCenter addObserver:self selector:@selector(tabBarControllerDidSelectViewController) name:UITabBarControllerDidSelectViewControllerNotification object:nil];
    // 监听 voice play button 的点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voicePlayBtnClick:) name:VoicePlayBtnClickNotification object:nil];
}

- (void)dealloc {
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark 通知事件响应

- (void)tabBarControllerDidSelectViewController {
    
    // 如果是连续选中2次, 直接刷新
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    // 记录最新的选中索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}

- (void)voicePlayBtnClick:(NSNotification *)notification {
    
    LCTopicItem *item = notification.userInfo[@"info"];
    // 遍历将所有的其他 item 的 isPlayVoice 属性设置 NO
    self.topics = [self.topics rx_mapWithBlock:^LCTopicItem *(LCTopicItem *each) {
        if (![each isEqual:item]) {
            each.isPlayVoice = NO;
        }
        return each;
    }];
    // 刷新表格
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UI 设置

/** 设置 TableView */
- (void)setUpTableView {
    
    // 设置contentInset, 让tableView的内容不被导航条和tabBar挡住
    CGFloat top = EssenceTitleViewY + EssenceTitleViewH;
    CGFloat bottom = self.tabBarController.tabBar.fHeight;
    // 这里加了EssenceCellMargin, 是为了显示完全
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom + EssenceCellMargin, 0);
    // 这一句话一定要加, 不然滚动条会被挡住
    // 这里不用加EssenceCellMargin, 这样滚动条显示也正常了
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0, bottom, 0);;
    // 设置 cell 分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置 背景颜色
    self.tableView.backgroundColor = BSGlobalColor;
    
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTopicCell class]) bundle:nil] forCellReuseIdentifier:ID];
}

/** 设置 刷新控件 */
- (void)setUpRefreshView {
    
    // 头部刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    // 尾部加载控件
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark -
#pragma mark 数据加载

/** 加载最新的帖子 */
- (void)loadNewTopics {
    
    // 结束当前正在进行的上拉刷新
    [self.tableView.mj_footer endRefreshing];
    
    // url 和 参数
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *paramters = @{@"a": self.category, @"c": @"data", @"type": @(self.type)};
    
    [[AFHTTPSessionManager manager] GET:urlStr parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.currentMaxtime = responseObject[@"info"][@"maxtime"];
        
        self.topics = [LCTopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

/** 加载更多的帖子 */
- (void)loadMoreTopics {
    
    // 结束当前正在进行的下拉刷新
    [self.tableView.mj_header endRefreshing];
    
    // url 和 参数
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *paramters = @{@"a": self.category, @"c": @"data", @"type": @(self.type), @"maxtime": self.currentMaxtime};
    
    [[AFHTTPSessionManager manager] GET:urlStr parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.currentMaxtime = responseObject[@"info"][@"maxtime"];
        
        self.topics = [self.topics arrayByAddingObjectsFromArray:[LCTopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]]];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.topics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    LCTopicItem *item = self.topics[indexPath.row];
    cell.item = item;
    [cell setSharedBlock:^(LCTopicItem *item){
        [LCShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina item:item vc:self];
    }];
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCTopicItem *item = self.topics[indexPath.row];
    // 返回缓存的行高
    return item.cellHeight;
}

/** 选中 cell 进入 评论控制器 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCCmtDetailViewController *cmtVc = [[LCCmtDetailViewController alloc] init];
    
    cmtVc.item = self.topics[indexPath.row];
    
    [self.navigationController pushViewController:cmtVc animated:YES];
}

@end
