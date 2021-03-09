//
//  WDScenicViewController.m
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDScenicViewController.h"
#import "WDSearchHistoryView.h"
#import "WDMineScenicTVCell.h"
#import "WDScenicModel.h"
#import "WDScenicClassifyModel.h"

@interface WDScenicViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) WDSearchHistoryView * searchView;

@property (nonatomic, strong) UIView *labelView;
@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) UIButton * lastBtn;

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, copy) NSArray * menuArr;/// 景点分类数据源

@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, assign) NSInteger pageIndex;
/// 是否加载
@property (nonatomic, assign) BOOL isFresh;
/// 搜索关键字
@property (nonatomic, copy) NSString * key;

@property (nonatomic, copy) NSString * fenleiId;

@end

@implementation WDScenicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的景点";
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    self.key = @"";
    self.fenleiId = @"0";
    
    self.searchView.hidden = NO;
    
    
    [self getjingdianfenleiRequestData];

    [self refershDataSource];
}
/// 刷新加载
- (void)refershDataSource {
    kWEAK_SELF;
    [WDRefershClass refreshWithHeader:self.tableView refreshingBlock:^{

        [weakSelf relodataSorce];
    }];
    [WDRefershClass refreshWithFooter:self.tableView refreshingBlock:^{
        weakSelf.pageIndex ++;
        weakSelf.isFresh = YES;
        [weakSelf GetshoucangRequestData];
    }];
}
- (void)relodataSorce {
    self.pageIndex = 0;
    self.isFresh = NO;
    [self GetshoucangRequestData];
}
- (void)addLabelView {
    if (self.labelView) {
        [self.labelView removeFromSuperview];
        self.labelView = nil;
    }
    UIView *labelView = [[UIView alloc] init];
    [self.view addSubview:labelView];
    self.labelView = labelView;
    
    __block CGFloat total_width = 0;
    for (int i = 0; i < self.menuArr.count; i++) {
        WDScenicClassifyModel *model = self.menuArr[i];
        CGFloat btn_width = [WDGlobal widthForText:model.title textFont:15 standardHeight:30] + 10;
        total_width = btn_width + 10 + total_width;
        UIButton *btn = [UIButton buttonWithTitle:model.title titleColor:[UIColor blackColor] font:[UIFont systemFontOfSize:15] target:self action:@selector(touchLabelClick:)];
        btn.tag = 100 + i;
        [btn setCornerRadius:5];
        btn.borderColor = [UIColor blackColor];
        btn.borderWidth = 1;
        btn.backgroundColor = hexColor(F0DCFA);
        [labelView addSubview:btn];
        if ([model.title isEqualToString:@"全部"]) {
            btn.backgroundColor = hexColor(E1B9FA);
            self.selectBtn = btn;
        }
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.offset(10);
                make.top.offset(10);
            }else {
                if (total_width > kSCREEN_WIDTH) {
                    make.top.equalTo(self.lastBtn.mas_bottom).offset(10);
                    make.left.offset(10);
                    total_width = 0;
                }else {
                    make.top.equalTo(self.lastBtn);
                    make.left.equalTo(self.lastBtn.mas_right).offset(10);
                }
            }
            make.width.offset(btn_width);
            make.height.offset(30);
        }];
        self.lastBtn = btn;
    }
    
    [self.view addSubview:self.tableView];

    [self.view setNeedsDisplay];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        make.left.offset(60);
        make.right.offset(-60);
        make.height.offset(40);
    }];
    
    [self.labelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(10);
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.equalTo(self.lastBtn.mas_bottom).offset(10);
    }];
    if (self.labelView) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.labelView.mas_bottom).offset(10);
            make.left.right.offset(0);
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        }];
    }
    
}
- (void)touchLabelClick:(UIButton *)btn {
    WDScenicClassifyModel *model = self.menuArr[btn.tag - 100];
    btn.backgroundColor = hexColor(E1B9FA);
    self.selectBtn.backgroundColor = hexColor(F0DCFA);
    self.fenleiId = model.ID;
    self.selectBtn = btn;

    [self relodataSorce];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDMineScenicTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDMineScenicTVCell" forIndexPath:indexPath];
    WDScenicModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - network
- (void)getjingdianfenleiRequestData {
    [TYNetworkTool getRequest:WDGetjingdianfenleiAPI parameters:@{} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = [WDScenicClassifyModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            NSMutableArray *data_arr = [NSMutableArray arrayWithCapacity:0];
            for (WDScenicClassifyModel *model in arr) {
                if (model.childrendata.count == 0) {
                    [data_arr addObject:model];
                }
            }
            self.menuArr = [NSArray arrayWithArray:data_arr];
            [self addLabelView];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
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
        @"fenleiid" : self.fenleiId,
        @"pageSize" : @"10",
        @"pageIndex" : @(self.pageIndex),
        @"uid" : [WDGlobal userID],
        @"key" : self.key
    };
    [TYNetworkTool getRequest:WDGetshoucangAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = [WDScenicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];

        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"WDMineScenicTVCell" bundle:nil] forCellReuseIdentifier:@"WDMineScenicTVCell"];
    }
    return _tableView;
}
#pragma mark - searchView
- (WDSearchHistoryView *)searchView {
    if (!_searchView) {
        _searchView = [[WDSearchHistoryView alloc] initWithFrame:CGRectMake(60, 20, kSCREEN_WIDTH - 120, 40)];
        _searchView.isNotValueChange = YES;
        kWEAK_SELF;
        _searchView.textChangeBlock = ^(NSString * _Nonnull text) {
            weakSelf.key = text;
            [weakSelf relodataSorce];
        };
        [self.view addSubview:_searchView];
    }
    return _searchView;
}

@end
