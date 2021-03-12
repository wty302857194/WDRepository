//
//  WDMineVC.m
//  WDMap
//
//  Created by wbb on 2021/1/29.
//

#import "WDMineVC.h"
#import "WDMineTableViewCell.h"
#import "WDMineHeaderView.h"
#import "WDMineSettingVC.h"
#import "WDScenicViewController.h"
#import "WDMineMedalVC.h"


static  NSString * const MineCellId = @"WDMineTableViewCell";
@interface WDMineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) WDMineHeaderView *headerView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSDictionary * xunzhangDic;
@property (nonatomic, copy) NSDictionary * scenicDic;

@end

@implementation WDMineVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人中心";
    [self.view addSubview:self.tableView];
    [self addTableViewHeaderView];
    [self addBarButtonItem];
    
//    [self GetshoucangRequestData];
//    [self GetxunzhangRequestData];
    [self refershDataSource];
}
/// MARK : BarButtonItem
- (void)addBarButtonItem {
    UIButton *left_home = [UIButton buttonWithType:UIButtonTypeCustom];
    [left_home setBackgroundImage:[UIImage imageNamed:@"mine_settine"] forState:UIControlStateNormal];
    left_home.frame = CGRectMake(0, 0, 25, 25);
    [left_home addTarget:self action:@selector(leftHomeClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_home];
}
- (void)leftHomeClick {
    WDMineSettingVC *vc = [[WDMineSettingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
/// 刷新加载
- (void)refershDataSource {
    kWEAK_SELF;
    [WDRefershClass refreshWithHeader:self.tableView refreshingBlock:^{
        [weakSelf getuserRequestData];
        [weakSelf GetshoucangRequestData];
        [weakSelf GetxunzhangRequestData];
    }];
}


#pragma mark - netWork
- (void)getuserRequestData {
    NSDictionary *dic = @{
        @"token" : @"",
        @"uid" : [WDGlobal userID],
    };
    [TYNetworkTool getRequest:WDgetuserAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];

        if ([data[@"status"] integerValue] == 1) {
            self.headerView.dataDic = [NSDictionary dictionaryWithDictionary:data[@"data"]];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [self.tableView.mj_header endRefreshing];

        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/*
 action:Getshoucang
 openid：微信用户openid 可为空
 fenleiid：分类ID （传值0，则显示所有分类下的数据）
 pageSize：每页记录数
 pageIndex：当前页数
 uid：用户ID
 key：关键字（key为空则显示所有数据）
 */
- (void)GetshoucangRequestData {
    NSDictionary *dic = @{
        @"openid" : @"",
        @"fenleiid" : @"0",
        @"pageSize" : @"9999",
        @"uid" : [WDGlobal userID],
        @"key" : @""
    };
    [TYNetworkTool getRequest:WDGetshoucangAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];

        if ([data[@"status"] integerValue] == 1) {
            self.scenicDic = [NSDictionary dictionaryWithDictionary:data];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [self.tableView.mj_header endRefreshing];

        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/*
 Getxunzhang
 */
- (void)GetxunzhangRequestData {
    NSDictionary *dic = @{
        @"openid" : @"",
        @"uid" : [WDGlobal userID],
    };
    [TYNetworkTool getRequest:WDGetxunzhangAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];

        if ([data[@"status"] integerValue] == 1) {
            self.xunzhangDic = [NSDictionary dictionaryWithDictionary:data];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [self.tableView.mj_header endRefreshing];

        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDMineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MineCellId forIndexPath:indexPath];
    kWEAK_SELF;
    cell.moreBlock = ^{
        if (indexPath.row == 0) {
            WDScenicViewController *vc =[[WDScenicViewController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];

        }else if(indexPath.row == 1) {
            
            WDMineMedalVC *vc =[[WDMineMedalVC alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    if(indexPath.row == 0) {
        [cell cellForDataSource:self.scenicDic indexPath:indexPath.row];

    }else {
        [cell cellForDataSource:self.xunzhangDic indexPath:indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}
- (void)addTableViewHeaderView {
    WDMineHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"WDMineHeaderView" owner:nil options:nil].lastObject;
    headerView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_WIDTH*480/750.f);
    self.headerView = headerView;
    self.tableView.tableHeaderView = headerView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WDMineTableViewCell class]) bundle:nil] forCellReuseIdentifier:MineCellId];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
