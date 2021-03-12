//
//  WDDynamicDetailVC.m
//  WDMap
//
//  Created by wbb on 2021/2/2.
//

#import "WDDynamicDetailVC.h"
#import "WDDynamicDetailCell.h"
#import "WDSearchHistoryView.h"
#import "WDDynamicDetailBookCell.h"
#import "WDDynamicModel.h"
#import "WDWebViewController.h"

@interface WDDynamicDetailVC () <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) WDSearchHistoryView *searchView;
@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) UILabel * moveLineLab;
@property (nonatomic, strong) UIView * typeView;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArr;
@property (nonatomic, strong) WDDynamicModel * model;
@property (nonatomic, copy) NSString * paixu;
@property (nonatomic, assign) NSInteger pageIndex;
/// 是否加载
@property (nonatomic, assign) BOOL isFresh;
/// 搜索关键字
@property (nonatomic, copy) NSString * key;

@end

@implementation WDDynamicDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.paixu = @"最新";
    self.pageIndex = 0;
    self.key = @"";
    
    [self.view addSubview:self.searchView];
    [self.view addSubview:self.tableView];

    [self refershDataSource];
}
/// 刷新加载
- (void)refershDataSource {
    kWEAK_SELF;
    [WDRefershClass refreshWithHeader:self.tableView refreshingBlock:^{
        [weakSelf headerRefreshRequest];
    }];
    [WDRefershClass refreshWithFooter:self.tableView refreshingBlock:^{
        weakSelf.pageIndex ++;
        weakSelf.isFresh = YES;
        [weakSelf requestData];
    }];
}
- (void)headerRefreshRequest {
    self.pageIndex = 0;
    self.isFresh = NO;
    [self requestData];
}

/// 初始化接口
- (void)setDynamicType:(DynamicType)dynamicType {
    _dynamicType = dynamicType;
    if (dynamicType == DynamicTypeBook) {
        [self addBookLab];
    }else {
        [self addChosseTypeUI];
    }
    
}
- (void)requestData {
    switch (self.dynamicType) {
        case DynamicTypeWenxue:
        {
            self.navigationItem.title = @"文学动态";
            [self getwenxuedongtaiRequestData];
        }
            break;
        case DynamicTypeJinqi:
        {
            self.navigationItem.title = @"近期活动";
            [self getjinqihuodongRequestData];
        }
            break;
        case DynamicTypeBook:
        {
            self.navigationItem.title = @"在线书籍";
            [self getshujituijianRequestData];
        }
            break;
        default:
            break;
    }
}

- (void)addBookLab {
    UIView *typeView = [[UIView alloc] init];
    [self.view addSubview:typeView];
    self.typeView = typeView;
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.searchView.mas_bottom).offset(20);
        make.height.offset(50);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = hexColor(898989);
    titleLab.text = @"全部书籍";
    [typeView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.equalTo(typeView.mas_centerY);
    }];
}
- (void)addChosseTypeUI {
    UIView *typeView = [[UIView alloc] init];
    [self.view addSubview:typeView];
    self.typeView = typeView;
    [typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.searchView.mas_bottom).offset(20);
        make.height.offset(50);
    }];
    
    UIButton *newBtn = [UIButton buttonWithTitle:@"最新" titleColor:[UIColor blackColor] font:[UIFont systemFontOfSize:18] target:self action:@selector(typeClick:)];
    newBtn.tag = 10;
    self.selectBtn = newBtn;
    [typeView addSubview:newBtn];
    [newBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.centerY.equalTo(typeView.mas_centerY);
        make.width.offset(40);
        make.height.offset(30);
    }];
    
    UIButton *hotBtn = [UIButton buttonWithTitle:@"最热" titleColor:[UIColor lightGrayColor] font:[UIFont systemFontOfSize:16] target:self action:@selector(typeClick:)];
    hotBtn.tag = 11;
    [typeView addSubview:hotBtn];
    [hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(newBtn.mas_right).offset(10);
        make.centerY.equalTo(typeView.mas_centerY);
        make.width.offset(40);
        make.height.offset(30);
    }];
    UILabel *lineLab = [[UILabel alloc] init];
    lineLab.backgroundColor = hexColor(f1f0e8);
    [typeView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.bottom.offset(-0.75);
        make.height.offset(0.5);
    }];
    
    UILabel *moveLineLab = [[UILabel alloc] init];
//    moveLineLab.backgroundColor = self.dynamicType == DynamicTypeWenxue ? hexColor(3d6ef0) : hexColor(e64870);
    
    moveLineLab.backgroundColor = hexColor(ffeb00);
    [moveLineLab setCornerRadius:1];
    [typeView addSubview:moveLineLab];
    self.moveLineLab = moveLineLab;
    [moveLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(newBtn.mas_centerX);
        make.bottom.offset(0);
        make.height.offset(2);
        make.width.offset(30);
    }];
}

- (void)typeClick:(UIButton *)btn {
    if (self.selectBtn == btn) {
        return;
    }
    
    self.paixu = btn.titleLabel.text;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.selectBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.selectBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [UIView animateWithDuration:0.1 animations:^{
        self.moveLineLab.center = CGPointMake(btn.centerX, self.moveLineLab.centerY);
    }];
    self.selectBtn = btn;
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillLayoutSubviews {
    self.searchView.frame = CGRectMake(20, 20+self.view.safeAreaInsets.top, self.searchView.width, self.searchView.height);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.typeView.mas_bottom).offset(20);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

#pragma mark - network
/// 近期活动
- (void)getjinqihuodongRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"20",
        @"pageIndex" : @(self.pageIndex),
        @"paixu" : self.paixu,
        @"key" : self.key
    };
    [TYNetworkTool getRequest:WDGetjinqihuodongAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([data[@"status"] integerValue] == 1) {
            
            NSArray *arr = [WDDynamicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (self.isFresh) {
                if (arr&&arr.count>0) {
                    [self.dataArr addObjectsFromArray:arr];
                    [self.tableView reloadData];
                }else {
                    [MBProgressHUD promptMessage:@"没有更多了" inView:self.view];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
            }else {
                [self.dataArr removeAllObjects];
                if (arr&&arr.count>0) {
                    [self.dataArr addObjectsFromArray:arr];
                    
                }else {
                    NSLog(@"加载空视图");
//                    self.tableView.tableHeaderView = [UIView new];
                }
                [self.tableView reloadData];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
        

    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/// 文学动态
- (void)getwenxuedongtaiRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"20",
        @"pageIndex" : @(self.pageIndex),
        @"paixu" : self.paixu,
        @"key" : self.key
    };

    [TYNetworkTool getRequest:WDGetwenxuedongtaiAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([data[@"status"] integerValue] == 1) {
            
            NSArray *arr = [WDDynamicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (self.isFresh) {
                if (arr&&arr.count>0) {
                    [self.dataArr addObjectsFromArray:arr];
                    [self.tableView reloadData];
                }else {
                    [MBProgressHUD promptMessage:@"没有更多了" inView:self.view];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
            }else {
                [self.dataArr removeAllObjects];
                if (arr&&arr.count>0) {
                    [self.dataArr addObjectsFromArray:arr];
                    
                }else {
                    NSLog(@"加载空视图");
                }
                [self.tableView reloadData];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }

    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/// 书籍推荐
- (void)getshujituijianRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"20",
        @"pageIndex" : @(self.pageIndex),
        @"key" : self.key
    };
    [TYNetworkTool getRequest:WDGetshujituijianAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([data[@"status"] integerValue] == 1) {
            
            NSArray *arr = [WDDynamicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (self.isFresh) {
                if (arr&&arr.count>0) {
                    [self.dataArr addObjectsFromArray:arr];
                    [self.tableView reloadData];
                }else {
                    [MBProgressHUD promptMessage:@"没有更多了" inView:self.view];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    
                }
            }else {
                [self.dataArr removeAllObjects];
                if (arr&&arr.count>0) {
                    [self.dataArr addObjectsFromArray:arr];
                    
                }else {
                    NSLog(@"加载空视图");
                }
                [self.tableView reloadData];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }

    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/*
 channel_id （近期活动channel_id=15 书籍推荐channel_id=16 文学动态channel_id=20）
 */
- (void)getxiangxiRequestData:(WDDynamicModel *)model {
    NSString *channel_id = @"";
    
    switch (self.dynamicType) {
        case DynamicTypeWenxue:
        {
            channel_id = @"20";
        }
            break;
        case DynamicTypeJinqi:
        {
            channel_id = @"15";
        }
            break;
        case DynamicTypeBook:
        {
            channel_id = @"16";
        }
            break;
        default:
            break;
    }
    NSDictionary *dic = @{
        @"channel_id" : channel_id,
        @"id" : model.ID
    };
    [TYNetworkTool getRequest:WDgetxiangxiAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            WDWebViewController *vc = [[WDWebViewController alloc] init];
            vc.htmlString = model.content?:@"";
            vc.navigationItem.title = model.sub_title?:@"";
            [[WDGlobal getCurrentViewController].navigationController pushViewController:vc animated:YES];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
#pragma mark - delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.dynamicType == DynamicTypeBook) {
        WDDynamicDetailBookCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDDynamicDetailBookCell"];
        if (cell == nil) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"WDDynamicDetailBookCell" owner:nil options:nil].lastObject;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.row < self.dataArr.count) {
            WDDynamicModel *model = self.dataArr[indexPath.row];
            model.type = self.dynamicType;
            cell.model = model;
        }
        return cell;
    }
    WDDynamicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDDynamicDetailCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WDDynamicDetailCell" owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < self.dataArr.count) {
        WDDynamicModel *model = self.dataArr[indexPath.row];
        model.type = self.dynamicType;
        cell.model = model;
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.dynamicType == DynamicTypeBook ? 180 : 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WDDynamicModel *model = self.dataArr[indexPath.row];
    [self getxiangxiRequestData:model];
}
#pragma mark - searchView
- (WDSearchHistoryView *)searchView {
    if (!_searchView) {
        _searchView = [[WDSearchHistoryView alloc] initWithFrame:CGRectMake(20, 20, kSCREEN_WIDTH - 40, 40)];
        kWEAK_SELF;
        _searchView.textChangeBlock = ^(NSString * _Nonnull text) {
            weakSelf.searchView.frame = CGRectMake(40, 20, kSCREEN_WIDTH - 80, 300);
        };
    }
    return _searchView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
@end
