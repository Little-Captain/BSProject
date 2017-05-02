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

#import <AFNetworking.h>
#import <MJExtension.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import <RXCollection.h>

#import "LCShareTool.h"

@interface LCTopicTableViewController ()

/** topics */
@property (nonatomic, strong) NSArray *topics;

/** maxtime */
@property (nonatomic, strong) NSString *currentMaxtime;

/** 上一次选中的 tabBar index */
@property (nonatomic, assign) NSUInteger lastSelectedIndex;

@end

@implementation LCTopicTableViewController

static NSString * const ID = @"topic";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NotificationCenter addObserver:self selector:@selector(tabBarControllerDidSelectViewController) name:UITabBarControllerDidSelectViewControllerNotification object:nil];
    
    [self setUpTableView];
    
    [self setUpRefreshView];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 监听 voice play button 的点击事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:VoicePlayBtnClickNotification object:nil];
}

- (void)notification:(NSNotification *)noti {
    
    LCTopicItem *item = noti.userInfo[@"info"];
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

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tabBarControllerDidSelectViewController {
    
    // 如果是连续选中2次, 直接刷新
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    // 记录最新的选中索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}

- (void)setUpTableView {
    
    // 设置contentInset, 让tableView的内容不被导航条和tabBar挡住
    CGFloat top = EssenceTitleViewY + EssenceTitleViewH;
    CGFloat bottom = self.tabBarController.tabBar.fHeight;
    // 这里加了EssenceCellMargin, 是为了显示完全
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom + EssenceCellMargin, 0);
    // 这一句话一定要加, 不然滚动条会被挡住
    // 这里不用加EssenceCellMargin, 这样滚动条显示也正常了
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(top, 0, bottom, 0);;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = BSGlobalColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([LCTopicCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
}

- (void)setUpRefreshView {
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    
}

- (void)loadNewUsers {
    
    [self.tableView.mj_footer endRefreshing];
    
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

- (void)loadMoreUsers {
    
    [self.tableView.mj_header endRefreshing];
    
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
    return item.cellHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LCCmtDetailViewController *cmtVc = [[LCCmtDetailViewController alloc] init];
    
    cmtVc.item = self.topics[indexPath.row];
    
    [self.navigationController pushViewController:cmtVc animated:YES];
    
}

- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType url:(NSString *)url {
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = url;
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
}

@end
