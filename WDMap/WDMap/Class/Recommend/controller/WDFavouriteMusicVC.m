//
//  WDFavouriteMusicVC.m
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import "WDFavouriteMusicVC.h"
#import "WDSearchHistoryView.h"
#import "WDMusicItemCell.h"
#import "WDMusicModel.h"

@interface WDFavouriteMusicVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) WDSearchHistoryView *searchView;
@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) UILabel * moveLineLab;
@property (nonatomic, strong) UIView * typeView;
@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, assign) NSInteger pageIndex;
/// 是否加载
@property (nonatomic, assign) BOOL isFresh;
/// 搜索关键字
@property (nonatomic, copy) NSString * key;
@end

@implementation WDFavouriteMusicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的喜欢";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.pageIndex = 0;
    self.key = @"";
    
    [self.view addSubview:self.searchView];
    
    [self addChosseTypeUI];
    
    [self.view addSubview:self.tableView];

    [self refershDataSource];
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
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = hexColor(898989);
    titleLab.text = @"全部列表";
    [typeView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.offset(0);
    }];
}

- (void)viewWillLayoutSubviews {
    self.searchView.frame = CGRectMake(20, 20+self.view.safeAreaInsets.top, self.searchView.width, self.searchView.height);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(self.typeView.mas_bottom).offset(20);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
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
        [weakSelf getyyshoucangRequestData];
    }];
}
- (void)headerRefreshRequest {
    self.pageIndex = 0;
    self.isFresh = NO;
    [self getyyshoucangRequestData];
}
#pragma mark - network
- (void)getyyshoucangRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"10",
        @"uid" : [WDGlobal userID],
        @"openid" : @"",
        @"pageIndex" : @(self.pageIndex),
        @"key" : self.key
    };
    [TYNetworkTool getRequest:WDGetyyshoucangappAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([data[@"status"] integerValue] == 1) {
            
            NSArray *arr = [WDHotMusicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
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
#pragma mark - delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WDMusicItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDMusicItemCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WDMusicItemCell" owner:nil options:nil].lastObject;
        
    }
    if (indexPath.row < self.dataArr.count) {
        cell.model = self.dataArr[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WDHotMusicModel *model = self.dataArr[indexPath.row];
    [WDGlobal showMusicPlayView];
    [[WDMusicPlayView musicPlayView] currrentFenleiid:model.zhuanjiid currentMusicId:model.ID];
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
