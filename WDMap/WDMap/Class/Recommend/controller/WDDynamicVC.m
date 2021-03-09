//
//  WDDynamicVC.m
//  WDMap
//
//  Created by wbb on 2021/2/2.
//

#import "WDDynamicVC.h"
#import "WDDynamicTableViewCell.h"
#import "WDDynamicDetailVC.h"
#import "WDDynamicModel.h"

static NSString *kCellId = @"cellId";

@interface WDDynamicVC ()<UITableViewDelegate,UITableViewDataSource> {
    dispatch_group_t group;
}

@property(nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray * jinqiArr;
@property (nonatomic, copy) NSArray * bookArr;
@property (nonatomic, copy) NSArray * wenxueArr;
@property (nonatomic, strong) NSMutableArray * dataArr;

@end

@implementation WDDynamicVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [NSMutableArray arrayWithCapacity:0];
    [self.view addSubview:self.tableView];

    [self groupNotify];
}
/**
 * 队列组 dispatch_group_notify
 */
- (void)groupNotify {
    
    group =  dispatch_group_create();
    
    [self getjinqihuodongRequestData];

    [self getwenxuedongtaiRequestData];

    [self getshujituijianRequestData];

    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务 1、任务 2 都执行完毕后，回到主线程执行下边任务
        [self reloadDataSource];              // 模拟耗时操作
    });
}
/// 刷新列表数据
- (void)reloadDataSource {
    [self.dataArr addObject:self.wenxueArr];
    [self.dataArr addObject:self.jinqiArr];
    [self.dataArr addObject:self.bookArr];

    [self.tableView reloadData];
}
#pragma mark - network
/// 近期活动
- (void)getjinqihuodongRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"6",
        @"pageIndex" : @"0",
        @"paixu" : @"最热",
        @"key" : @""
    };
    dispatch_group_enter(group);
    [TYNetworkTool getRequest:WDGetjinqihuodongAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = [NSArray arrayWithArray:data[@"data"]];
            if (arr && arr.count>0) {
                if (arr.count>6) {
                    self.jinqiArr = [WDDynamicModel mj_objectArrayWithKeyValuesArray:[arr subarrayWithRange:NSMakeRange(0, 6)]];
                }else {
                    self.jinqiArr = [WDDynamicModel mj_objectArrayWithKeyValuesArray:arr];
                }
            }else {
                [MBProgressHUD promptMessage:@"近期活动暂无数据" inView:self.view];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
        
        dispatch_group_leave(self->group);

    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/// 文学动态
- (void)getwenxuedongtaiRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"6",
        @"pageIndex" : @"0",
        @"paixu" : @"最热",
        @"key" : @""
    };
    dispatch_group_enter(group);

    [TYNetworkTool getRequest:WDGetwenxuedongtaiAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = [NSArray arrayWithArray:data[@"data"]];
            if (arr && arr.count>0) {
                if (arr.count>6) {
                    self.wenxueArr = [WDDynamicModel mj_objectArrayWithKeyValuesArray:[arr subarrayWithRange:NSMakeRange(0, 6)]];
                }else {
                    self.wenxueArr = [WDDynamicModel mj_objectArrayWithKeyValuesArray:arr];
                }
            }else {
                [MBProgressHUD promptMessage:@"文学动态暂无数据" inView:self.view];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
        dispatch_group_leave(self->group);

    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/// 书籍推荐
- (void)getshujituijianRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"6",
        @"pageIndex" : @"0",
        @"key" : @""
    };
    dispatch_group_enter(group);
    [TYNetworkTool getRequest:WDGetshujituijianAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = [NSArray arrayWithArray:data[@"data"]];
            if (arr && arr.count>0) {
                if (arr.count>6) {
                    self.bookArr = [WDDynamicModel mj_objectArrayWithKeyValuesArray:[arr subarrayWithRange:NSMakeRange(0, 6)]];
                }else {
                    self.bookArr = [WDDynamicModel mj_objectArrayWithKeyValuesArray:arr];
                }
            }else {
                [MBProgressHUD promptMessage:@"书籍推荐暂无数据" inView:self.view];
            }
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
        dispatch_group_leave(self->group);

    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 270;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WDDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId forIndexPath:indexPath];
    [cell itemArray:self.dataArr[indexPath.row] index:indexPath.row];
    kWEAK_SELF;
    
    cell.pushDetailBlock = ^{
        DynamicType type = DynamicTypeWenxue;
        switch (indexPath.row) {
            case 0:
            {
                type = DynamicTypeWenxue;
            }
                break;
            case 1:
            {
                type = DynamicTypeJinqi;
            }
                break;
            case 2:
            {
                type = DynamicTypeBook;
            }
                break;
            default:
                break;
        }
        WDDynamicDetailVC *vc = [[WDDynamicDetailVC alloc] init];
        vc.dynamicType = type;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}


#pragma mark - lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, kLayoutViewMarginTop + kTableBarHeight+64, 0);
        _tableView.backgroundColor = hexColor(efefef);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerNib:[UINib nibWithNibName:@"WDDynamicTableViewCell" bundle:nil] forCellReuseIdentifier:kCellId];
    }
    return _tableView;
}

@end
