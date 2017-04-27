//
//  LCCmtDetailViewController.m
//  BSProject
//
//  Created by Liu-Mac on 17/12/2016.
//  Copyright © 2016 Liu-Mac. All rights reserved.
//

#import "LCCmtDetailViewController.h"

#import "LCCmtHeaderView.h"
#import "LCTopicCell.h"
#import "LCTopicItem.h"

#import "LCCmtCell.h"

#import "LCCmtItem.h"

#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <MJExtension.h>

#define TableViewHeaderH 20.0

@interface LCCmtDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cmtBarBottomConstraint;

@property (weak, nonatomic) IBOutlet UIView *barView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 最新评论 */
@property (nonatomic, strong) NSArray *laststCmt;

/** 最热评论 */
@property (nonatomic, strong) NSArray *hotCmt;

/** loadMordID */
@property (nonatomic, strong) NSString *loadMordID;

/** 缓存所有的帖子的评论数据 */
@property (nonatomic, strong) LCCmtItem *save_top_cmt;

/** 评论总数 */
@property (nonatomic, assign) NSInteger total;

/** afn 任务管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;

@end

@implementation LCCmtDetailViewController

- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    
    return _manager;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpBasic];
    
    [self setUpTableView];
    
    [self setUpHeader];
    
    [self setUpRefresher];
}

- (void)setUpRefresher {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.tableView.mj_footer.hidden = YES;
    
}

- (void)loadNewData {
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *paramters = @{@"a": @"dataList", @"c": @"comment", @"data_id": self.item.ID, @"hot": @"1"};
    
    [self.manager GET:urlStr parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.total = [responseObject[@"total"] integerValue];
        
        self.laststCmt = [LCCmtItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        self.hotCmt = [LCCmtItem mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        self.loadMordID = [self.laststCmt.lastObject ID];
        
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
        if (self.laststCmt.count >= self.total) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            self.tableView.mj_footer.hidden = NO;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
    
}

- (void)loadMoreData {
    
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *paramters = @{@"a": @"dataList", @"c": @"comment", @"data_id": self.item.ID, @"hot": @"1", @"lastcid": self.loadMordID};
    
    [self.manager GET:urlStr parameters:paramters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.total = [responseObject[@"total"] integerValue];
        
        self.laststCmt = [self.laststCmt arrayByAddingObjectsFromArray:[LCCmtItem mj_objectArrayWithKeyValuesArray:responseObject[@"data"]]];
        self.hotCmt = [LCCmtItem mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        self.loadMordID = [self.laststCmt.lastObject ID];
        
        [self.tableView reloadData];
        
        if (self.laststCmt.count >= self.total) {
            self.tableView.mj_footer.hidden = YES;
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

- (void)setUpBasic {
    
    self.title = @"评论";
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(followBtn) image:@"comment_nav_item_share_icon" hightImage:@"comment_nav_item_share_icon_click"];
    
}

- (void)followBtn {
    
    UIAlertController *alter = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"举报成功!"];
    }];
    
    UIAlertAction *follow = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVProgressHUD showSuccessWithStatus:@"收藏成功!"];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    
    [alter addAction:report];
    [alter addAction:follow];
    [alter addAction:cancel];
    
    [KeyWindow.rootViewController presentViewController:alter animated:YES completion:nil];
}

- (void)setUpTableView {
    
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);

    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);

    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.backgroundColor = BSGlobalColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCmtCell class]) bundle:nil] forCellReuseIdentifier:@"cmtcell"];
    
    [self.tableView registerClass:[LCCmtHeaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)setUpHeader {
    
    // 如果有最热评论数据
    if (self.item.top_cmt) {
        // 缓存数据
        self.save_top_cmt = self.item.top_cmt;
        // 清空评论数据
        self.item.top_cmt = nil;
        // 设置cellHeight为0, 以便后面再计算cell高度
        [self.item setValue:@(0) forKey:@"cellHeight"];
    }
    
    // 为header包装一层view
    UIView *header = [[UIView alloc] init];
    
    header.backgroundColor = BSGlobalColor;
    header.fSize = CGSizeMake(ScreenW, self.item.cellHeight + EssenceCellMargin);
    
    LCTopicCell *cell = [LCTopicCell topicCell];
    cell.item = self.item;
    cell.fSize = CGSizeMake(ScreenW, self.item.cellHeight);
    [header addSubview:cell];
    
    self.tableView.tableHeaderView = header;
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
    // 获取返回的键盘的最终frame
    // CGRectValue!!!
    CGRect frame = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    self.cmtBarBottomConstraint.constant = ScreenH - frame.origin.y;
    
    [self.view layoutIfNeeded];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 如果缓存了最热评论
    if (self.save_top_cmt) {
        // 恢复数据
        self.item.top_cmt = self.save_top_cmt;
        // 设置cellHeight为0, 以便后面再计算cell高度
        [self.item setValue:@(0) forKey:@"cellHeight"];
    }
    
    // 取消所有的任务
    
    [self.manager invalidateSessionCancelingTasks:YES];
    
}

# pragma mark - table view delegate

# pragma mark - table view source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.hotCmt.count) {
        if (section == 0) {
            return self.hotCmt.count;
        }
        if (section == 1) {
            return self.laststCmt.count;
        }
    }
    
    if (self.laststCmt.count) {
        return self.laststCmt.count;
    }
    
    return 0;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.hotCmt.count) {
        return 2;
    }
    
    if (self.laststCmt.count) {
        return 1;
    }
    
    return 0;
    
}

- (LCCmtItem *)itemWithIndexPath:(NSIndexPath *)indexPath {
    
    if (self.hotCmt.count) {
        if (indexPath.section == 0) {
            return self.hotCmt[indexPath.row];
        }
        if (indexPath.section == 1) {
            return self.laststCmt[indexPath.row];
        }
    }
    
    if (self.laststCmt.count) {
        return self.laststCmt[indexPath.row];
    }
    
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCCmtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cmtcell"];
    
    cell.item = [self itemWithIndexPath:indexPath];
    
    return  cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return TableViewHeaderH;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    LCCmtHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
    
    if (section == 0) {
        headerView.title = self.hotCmt.count ? @"最热评论" : @"最新评论";
    } else {
        headerView.title = @"最新评论";
    }
    
    return headerView;
}

# pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    
}

@end
