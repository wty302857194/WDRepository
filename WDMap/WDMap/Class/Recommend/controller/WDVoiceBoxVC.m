//
//  WDVoiceBoxVC.m
//  WDMap
//
//  Created by wbb on 2021/2/2.
//

#import "WDVoiceBoxVC.h"
#import "WDVoiceBoxHeaderView.h"
#import "WDVoiceBoxTvCell.h"
#import "WDVoiceBoxDetailTvCell.h"
#import "WDMusicModel.h"

@interface WDVoiceBoxVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) WDVoiceBoxHeaderView * headerView;

@property (nonatomic, copy) NSArray * dataArr;
@property (nonatomic, assign) NSInteger count;
@end

@implementation WDVoiceBoxVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.count = 0;
    self.dataArr = @[];
    [self initUI];
    
    [self gethotyinyueRequestData];
}
- (void)initUI {
    self.view.backgroundColor = hexColor(efefef);
    [self.view addSubview:self.tableView];
    [self addTableViewHeaderView];
}
- (void)addTableViewHeaderView {
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - network
- (void)gethotyinyueRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"10",
        @"pageIndex" : @"0",
        @"suiji" : @"是",
        @"key" : @""
    };
    [TYNetworkTool getRequest:WDGethotyinyueAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {

        if ([data[@"status"] integerValue] == 1) {
            self.dataArr = [WDHotMusicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.dataArr.count;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        WDVoiceBoxTvCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDVoiceBoxTvCell"];
        if (cell == nil) {
            cell = [[WDVoiceBoxTvCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WDVoiceBoxTvCell"];
        }
        return cell;
    }
    
    WDVoiceBoxDetailTvCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDVoiceBoxDetailTvCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WDVoiceBoxDetailTvCell" owner:nil options:nil].lastObject;
    }
    
    if (indexPath.row < self.dataArr.count) {
        cell.model = self.dataArr[indexPath.row];
        if (indexPath.row == self.dataArr.count - 1) {
            cell.isCorner = YES;
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? VoiceBox_item_width + 30 + 20 : 80;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 40)];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(14, 0, kSCREEN_WIDTH - 28, 40)];
    contentView.backgroundColor = [UIColor whiteColor];
    [WDGlobal addCorners:contentView];
    [header addSubview:contentView];
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = section == 0 ? @"精选专辑" : @"热门单曲";
    titleLab.font = [UIFont systemFontOfSize:18];
    [contentView addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.centerY.offset(0);
    }];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coordinate_go"]];
    [contentView addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView.mas_right).offset(-10);
        make.centerY.equalTo(contentView.mas_centerY);
    }];
    
    UILabel *taskLab = [[UILabel alloc] init];
    taskLab.text = @"换一批";
    taskLab.tag = section + 100;
    taskLab.textAlignment = NSTextAlignmentRight;
    taskLab.textColor = hexColor(898989);
    taskLab.font = [UIFont systemFontOfSize:13];
    [taskLab addTarget:self action:@selector(changeDataSource:)];
    [contentView addSubview:taskLab];
    [taskLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(60);
        make.right.equalTo(imgView.mas_left).offset(-5);
        make.centerY.offset(0);
    }];
    return header;
}
- (void)changeDataSource:(UITapGestureRecognizer *)tapGesture {
    UILabel *lab = (UILabel *)tapGesture.view;
    NSUInteger tag = lab.tag - 100;
    if (tag == 0) {
        WDVoiceBoxTvCell *cell = (WDVoiceBoxTvCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell getyinyuefenleiRequestData];
    }else {
//        self.count ++;
        [self gethotyinyueRequestData];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? 14 : 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WDHotMusicModel *model = self.dataArr[indexPath.row];
    [WDGlobal showMusicPlayView];
    [[WDMusicPlayView musicPlayView] currrentFenleiid:model.zhuanjiid currentMusicId:model.ID];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kLayoutViewMarginTop + kTableBarHeight+64, 0);
        _tableView.backgroundColor = hexColor(efefef);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _tableView;
}
- (WDVoiceBoxHeaderView *)headerView {
    if (!_headerView) {
        CGFloat headerHeight = 20 + (kSCREEN_WIDTH-28) *48 / 121.f + 14 + ((kSCREEN_WIDTH-28 -14)/2.f) * 65 / 165.f + 20;

        _headerView = [[WDVoiceBoxHeaderView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, headerHeight)];
        
    }
    return _headerView;
}
@end
