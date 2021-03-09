//
//  WDRoadView.m
//  WDMap
//
//  Created by wbb on 2021/2/8.
//

#import "WDRoadView.h"
#import "WDRoadHeaderView.h"
#import "WDRoadTableViewCell.h"
#import "WDScenicModel.h"

@interface WDRoadView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, copy) NSArray * dataArr;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger index;
@end
@implementation WDRoadView
+ (instancetype)roadView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil].lastObject;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.backView addTarget:self action:@selector(click)];

    [self.tableView registerNib:[UINib nibWithNibName:@"WDRoadTableViewCell" bundle:nil] forCellReuseIdentifier:@"WDRoadTableViewCell"];
    
    [self GetxianluRequestData];
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [WDGlobal addCorners:self.contentView];

    
}

- (void)click {
    if (self.touchHiddenBlock) {
        self.touchHiddenBlock();
    }
}
- (IBAction)cancelBtn:(id)sender {
    [self click];
}


#pragma mark - network
- (void)GetxianluRequestData {
    NSDictionary *dic = @{
        
    };
    [TYNetworkTool getRequest:WDGetxianluAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            self.dataArr = [WDRoadModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            /// 这里要给一个初始值，不然默认是0，此时点击第0区会有问题
            self.index = self.dataArr.count;
            [self.tableView reloadData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    WDRoadModel *model = self.dataArr[section];

    return model.isSelect ? model.childrendata.count : 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDRoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDRoadTableViewCell" forIndexPath:indexPath];
    WDRoadModel *model = self.dataArr[indexPath.section];
    WDRoadChildModel *chidModel = model.childrendata[indexPath.row];
    cell.model = chidModel;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 20;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WDRoadModel *model = self.dataArr[section];
    
    WDRoadHeaderView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WDRoadHeaderView class]) owner:nil options:nil].lastObject;
    view.model = model;
    kWEAK_SELF;
    view.rodeHeaderBlock = ^{
        if (weakSelf.index != section) {
            if(weakSelf.index < weakSelf.dataArr.count) {
                WDRoadModel *select_model = self.dataArr[weakSelf.index];
                select_model.isSelect = NO;
            }
        }
        model.isSelect = !model.isSelect;
        weakSelf.index = section;
        [tableView reloadData];
    };
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    WDRoadModel *model = self.dataArr[indexPath.section];
    WDRoadChildModel *child_model = model.childrendata[indexPath.row];
    if (self.roadDetailBlock) {
        self.roadDetailBlock(child_model.ID);
    }
}
@end
