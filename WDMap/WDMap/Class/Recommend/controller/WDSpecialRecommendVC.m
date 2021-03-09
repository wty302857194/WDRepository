//
//  WDSpecialRecommendVC.m
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import "WDSpecialRecommendVC.h"
#import "WDSearchHistoryView.h"
#import "WDMusicItemCell.h"
#import "WDSpecialRecommendCell.h"

@interface WDSpecialRecommendVC ()<UITableViewDataSource,UITableViewDelegate>
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

@implementation WDSpecialRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"特别推荐";
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
        make.height.offset(40);
    }];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.textColor = hexColor(898989);
    titleLab.text = @"推荐列表";
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
        make.top.equalTo(self.typeView.mas_bottom).offset(0);
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
        [weakSelf gethotyinyueRequestData];
    }];
}
- (void)headerRefreshRequest {
    self.pageIndex = 0;
    self.isFresh = NO;
    [self gethotyinyueRequestData];
}
#pragma mark - network
- (void)gethotyinyueRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"10",
        @"pageIndex" : [NSString stringWithFormat:@"%ld",self.pageIndex],
        @"suiji" : @"否",
        @"key" : self.key
    };
    [TYNetworkTool getRequest:WDGethotyinyueAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([data[@"status"] integerValue] == 1) {
            
            NSArray *arr = [WDHotMusicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (self.isFresh) {
                if (arr&&arr.count>0) {
                    [self.dataArr addObjectsFromArray:arr];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];

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
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }

    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WDSpecialRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDSpecialRecommendCell"];
        if (cell == nil) {
            cell = [[WDSpecialRecommendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WDSpecialRecommendCell"];
        }
        return cell;
    }
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
    return section == 0 ? 1 : self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float item_width = (kSCREEN_WIDTH - 40)/3.f;
    return indexPath.section == 0 ? item_width + 30 : 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WDBaseView *view = [[WDBaseView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 30)];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = section == 0 ? @"精选专辑" : @"热门单曲";
    [view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.offset(0);
    }];
    
    return view;
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
