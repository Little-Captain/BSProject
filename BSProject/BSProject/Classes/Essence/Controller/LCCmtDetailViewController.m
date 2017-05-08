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
#import "LCShareTool.h"

#import <SVProgressHUD.h>
#import <MJRefresh.h>
#import <AFNetworking.h>
#import <YYModel.h>

#define TableViewHeaderH (20.0)

@interface LCCmtDetailViewController () <UITableViewDelegate, UITableViewDataSource>

/** 评论输入框底部的约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cmtBarBottomConstraint;

/** 评论输入框 view */
@property (weak, nonatomic) IBOutlet UIView *barView;

/** 评论显示表格 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** headerCell */
@property (nonatomic, weak) LCTopicCell *headerCell;

/** 最新评论模型数组 */
@property (nonatomic, strong) NSArray *laststCmt;

/** 最热评论模型数组 */
@property (nonatomic, strong) NSArray *hotCmt;

/** loadMordID */
@property (nonatomic, strong) NSString *loadMordID;

/** 缓存最热评论数据, 用于返回时恢复模型数据 */
@property (nonatomic, strong) LCCmtItem *save_top_cmt;

/** 评论总数 */
@property (nonatomic, assign) NSInteger total;

/** afn 任务管理者 */
@property (nonatomic, weak) LCHTTPSessionManager *manager;

@end

@implementation LCCmtDetailViewController

#pragma mark -
#pragma mark 懒加载

- (LCHTTPSessionManager *)manager {
    
    if (!_manager) {
        _manager = [LCHTTPSessionManager sharedInstance];
    }
    
    return _manager;
}

#pragma mark -

- (void)dealloc {
    
    LogFun();
    
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    // 如果缓存了最热评论
    if (self.save_top_cmt) {
        // 恢复数据
        self.item.top_cmt = self.save_top_cmt;
        // 设置 cellHeight 为0, 以便后面再计算 cell 高度
        [self.item setValue:@(0) forKey:@"cellHeight"];
    }
    
    // 因为 UIMenuController 是共享的, 所以退出时, 要清空 menuItems
    [UIMenuController sharedMenuController].menuItems = nil;
    
    // 取消所有的任务
    [self.manager.operationQueue cancelAllOperations];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpBasic];
    [self setUpTableView];
    [self setUpHeader];
    [self setUpRefresher];
    
    // 监听 voice play button 的点击通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(voicePlayBtnClick:) name:VoicePlayBtnClickNotification object:nil];
    // 监听 键盘frame 改变通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)setUpBasic {
    
    self.title = @"评论";
}

- (void)setUpTableView {
    
    // 获取 navigationBar 的最大 Y
    CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    // 设置 TableView 的内边距
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
    // 设置 滚动条 的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // iOS 8.0+ 的 Cell 自动计算高度设置, 两个属性缺一不可
    // 设置估算高度
    self.tableView.estimatedRowHeight = 200;
    // 设置自动尺寸
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // 设置背景颜色
    self.tableView.backgroundColor = BSGlobalColor;
    
    // 注册 cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCCmtCell class]) bundle:nil] forCellReuseIdentifier:@"cmtcell"];
    // 注册 headerView
    [self.tableView registerClass:[LCCmtHeaderView class] forHeaderFooterViewReuseIdentifier:@"headerView"];
    // 取消系统自带分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

/** 设置 TableView 的 header */
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
    
    // 设置 table view 的 header
    self.tableView.tableHeaderView = ({
        // 为header包装一层view
        UIView *header = [[UIView alloc] init];
        
        header.backgroundColor = BSGlobalColor;
        header.fSize = CGSizeMake(ScreenW, self.item.cellHeight + EssenceCellMargin);
        
        // 将 cell 加入 header
        [header addSubview:({
            LCTopicCell *cell = [LCTopicCell topicCell];
            cell.item = self.item;
            cell.fSize = CGSizeMake(ScreenW, self.item.cellHeight);
            __weak typeof(self) weakSelf = self;
            [cell setSharedBlock:^(LCTopicItem *item){
                [LCShareTool shareWebPageToPlatformType:UMSocialPlatformType_Sina item:item vc:weakSelf];
            }];
            self.headerCell = cell;
            cell;
        })];
        header;
    });
}

/** 设置刷新控件 */
- (void)setUpRefresher {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    self.tableView.mj_footer.hidden = YES;
}

#pragma mark -
#pragma mark 事件响应

/** 监听 音频播放按钮 的点击 */
- (void)voicePlayBtnClick:(NSNotification *)notification {
    
    // 将最新的 item 赋值给
    self.headerCell.item = notification.userInfo[@"info"];
}

/** 监听键盘 frame 的改变 */
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
    // 获取返回的键盘的最终frame
    // CGRectValue!!!
    CGRect frame = [note.userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    // 改变约束
    self.cmtBarBottomConstraint.constant = ScreenH - frame.origin.y;
    // 重新布局
    [self.view layoutIfNeeded];
}

#pragma mark -
#pragma mark 加载数据

/** 加载最新数据 */
- (void)loadNewData {
    
    // 取消以前的所有网络任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // url 和 参数
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *paramters = @{@"a": @"dataList", @"c": @"comment", @"data_id": self.item.ID, @"hot": @"1"};
    
    __weak typeof(self) weakSelf = self;
    [self.manager request:LCHttpMethodGET urlStr:urlStr parameters:paramters completion:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            // 实测: 当没有任何评论的时候, 服务器返回的数据解析后是一个空的数组!!!
            if ([result isKindOfClass:[NSArray class]]) {
                [weakSelf.tableView.mj_header endRefreshing]; // 结束刷新, 然后返回
                return;
            }
            
            weakSelf.total = [result[@"total"] integerValue];
            weakSelf.laststCmt = [NSArray yy_modelArrayWithClass:[LCCmtItem class] json:result[@"data"]];
            weakSelf.hotCmt = [NSArray yy_modelArrayWithClass:[LCCmtItem class] json:result[@"hot"]];
            
            weakSelf.loadMordID = [weakSelf.laststCmt.lastObject ID];
            
            [weakSelf.tableView reloadData];
            
            [weakSelf.tableView.mj_header endRefreshing];
            
            if (weakSelf.laststCmt.count >= weakSelf.total) {
                weakSelf.tableView.mj_footer.hidden = YES;
            } else {
                weakSelf.tableView.mj_footer.hidden = NO;
            }
        } else {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
}

/** 加载更多数据 */
- (void)loadMoreData {
    
    // 取消以前的所有网络任务
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // url 和 参数
    NSString *urlStr = @"http://api.budejie.com/api/api_open.php";
    NSDictionary *paramters = @{@"a": @"dataList", @"c": @"comment", @"data_id": self.item.ID, @"hot": @"1", @"lastcid": self.loadMordID};
    
    __weak typeof(self) weakSelf = self;
    [self.manager request:LCHttpMethodGET urlStr:urlStr parameters:paramters completion:^(id result, BOOL isSuccess) {
        if (isSuccess) {
            weakSelf.total = [result[@"total"] integerValue];
            
            weakSelf.laststCmt = [self.laststCmt arrayByAddingObjectsFromArray:[NSArray yy_modelArrayWithClass:[LCCmtItem class] json:result[@"data"]]];
            weakSelf.hotCmt = [NSArray yy_modelArrayWithClass:[LCCmtItem class] json:result[@"hot"]];
            
            weakSelf.loadMordID = [self.laststCmt.lastObject ID];
            
            [weakSelf.tableView reloadData];
            
            if (weakSelf.laststCmt.count >= weakSelf.total) {
                weakSelf.tableView.mj_footer.hidden = YES;
            } else {
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        } else {
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 定位 comment 的位置

- (NSArray *)commentsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return self.hotCmt.count ? self.hotCmt : self.laststCmt;
    }
    return self.laststCmt;
}

- (LCCmtItem *)commentInIndexPath:(NSIndexPath *)indexPath {
    
    return [self commentsInSection:indexPath.section][indexPath.row];
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
    
    
    
    return  ({
        LCCmtCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cmtcell"];
        cell.item = [self itemWithIndexPath:indexPath];
        cell;
    });
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return TableViewHeaderH;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return ({
        LCCmtHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"headerView"];
        
        if (section == 0) {
            headerView.title = self.hotCmt.count ? @"最热评论" : @"最新评论";
        } else {
            headerView.title = @"最新评论";
        }
        headerView;
    });
}

# pragma mark - scroll view delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.view endEditing:YES];
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if (menu.isMenuVisible) { // 正在显示的时候点击了 cell, 隐藏 menu, 然后直接返回
        [menu setMenuVisible:NO animated:YES];
        return;
    }
    
    LCCmtCell *cell = (LCCmtCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    // menu 的显示和第一响应者关联
    [cell becomeFirstResponder];
    
    // 点击 item 默认会调用控制器的方法
    UIMenuItem *ding = [[UIMenuItem alloc] initWithTitle:@"顶" action:@selector(ding:)];
    UIMenuItem *replay = [[UIMenuItem alloc] initWithTitle:@"回复" action:@selector(replay:)];
    UIMenuItem *report = [[UIMenuItem alloc] initWithTitle:@"举报" action:@selector(report:)];
    menu.menuItems = @[ding, replay, report];
    //    [menu setTargetRect:self.frame inView:self.superview];
    // 设置显示位置, 让 menu 放在 cell 中间
    [menu setTargetRect:CGRectMake(0, cell.fHeight * 0.5, cell.fWidth, cell.fHeight * 0.5) inView:cell];
    // 设置菜单显示
    [menu setMenuVisible:YES animated:YES];
}

#pragma mark - 实现 UIMenuController 的 action 方法

- (void)ding:(UIMenuController *)menu {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"顶 - %@", [self commentInIndexPath:indexPath].content);
}

- (void)replay:(UIMenuController *)menu {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"回复 - %@", [self commentInIndexPath:indexPath].content);
}

- (void)report:(UIMenuController *)menu {
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    NSLog(@"举报 - %@", [self commentInIndexPath:indexPath].content);
}

@end
