//
//  WDScenicTableViewController.m
//  WDMap
//
//  Created by wbb on 2021/2/23.
//

#import "WDScenicTableViewController.h"
#import "WDMusicPlayVC.h"
#import "SDCycleScrollView.h"
#import "WDScenicModel.h"
#import "WDMineMedalDetailVC.h"

@interface WDScenicTableViewController ()<SDCycleScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *cycleScrollViewBackView;
@property (nonatomic, strong) SDCycleScrollView * cycleScrollView;
@property (weak, nonatomic) IBOutlet UIView *userBackView;
@property (weak, nonatomic) IBOutlet UILabel *detailContentLab;
@property (weak, nonatomic) IBOutlet UITableViewCell *contentCell;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, assign) CGFloat cell_height;
@end

@implementation WDScenicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getjingdianRequestData:self.scenicModel.ID fenleiid:@"" pageSize:@"" key:@""];
    
    NSArray *userArr = [self.userName componentsSeparatedByString:@" "];
    [self initUserView:userArr];
}
- (void)initUserView:(NSArray *)dataArr {
    NSMutableArray *userArr = [NSMutableArray arrayWithArray:dataArr];
    NSString *firstStr = userArr.firstObject;
    if (firstStr.length == 0) {
        [userArr removeObjectAtIndex:0];
    }
    UILabel *selectLab = nil;
    
    CGFloat total_width = 0;
    CGFloat height = 24;
    for (int i = 0; i < userArr.count; i++) {
        CGFloat btn_width = [WDGlobal widthForText:userArr[i] textFont:15 standardHeight:height] + 10;
        total_width = btn_width + 10 + total_width;
        UILabel *nameLab = [[UILabel alloc] init];
        nameLab.backgroundColor = hexColor(befff0);
        nameLab.layer.borderWidth = 1;
        nameLab.textAlignment = NSTextAlignmentCenter;
        nameLab.font = [UIFont systemFontOfSize:14];
        nameLab.layer.borderColor = [UIColor blackColor].CGColor;
        nameLab.text = userArr[i];
        [self.userBackView addSubview:nameLab];
        [nameLab setCornerRadius:height/2.f];
        [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.offset(10);
                make.top.offset(10);
            }else {
                if (total_width > kSCREEN_WIDTH) {
                    make.top.equalTo(selectLab.mas_bottom).offset(10);
                    make.left.offset(10);
                }else {
                    make.top.equalTo(selectLab);
                    make.left.equalTo(selectLab.mas_right).offset(10);
                }
            }
            make.width.offset(btn_width);
            make.height.offset(height);
        }];
        selectLab = nameLab;
    }
}
/// 景点数据
- (void)getjingdianRequestData:(NSString *)idStr fenleiid:(NSString *)fenleiid pageSize:(NSString *)pageSize key:(NSString *)key {
    NSDictionary *dic = @{
        @"id" : idStr,
        @"fenleiid" : fenleiid,
        @"pageSize" : pageSize,
        @"pageIndex" : @(0),
        @"key" : key,
    };
    [TYNetworkTool getRequest:WDGetjingdianAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            WDScenicModel *model = [WDScenicModel mj_objectWithKeyValues:data[@"data"]];
            self.scenicModel = model;
            [self initWithData];
            if (model.albums.count>0) {
                NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:0];
                for (WDAlbumsModel *albumsModel in model.albums) {
                    [imgArr addObject:albumsModel.original_path?:@""];
                }
                [self initCycleScrollView:imgArr];
            }
            
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}

- (void)initCycleScrollView:(NSArray *)imgArr {
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.cycleScrollViewBackView.bounds delegate:self placeholderImage:PLACE_HOLDER_IMAGE];
    cycleScrollView.imageURLStringsGroup = imgArr;
    [WDGlobal addShadow:cycleScrollView];
    [self.cycleScrollViewBackView addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
}
- (void)initWithData {
    self.timeLab.text = self.scenicModel.kaifangshijian?:@"";
    self.addressLab.text = self.scenicModel.xiangxidizhi?:@"";
    self.detailContentLab.attributedText = [WDGlobal getHtmlStringWithString:self.scenicModel.fields[@"jingdianjieshao"]?:@""];
    [self.detailContentLab sizeToFit];
    
    self.cell_height = self.detailContentLab.height;
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.offset(0);
    }];
}
- (IBAction)shareClick:(UIButton *)sender {
    WDMineMedalDetailVC *vc =[[WDMineMedalDetailVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 250;
    }
    if (indexPath.row == 5) {
        return 30;
    }
    if (indexPath.row == 6) {
        return self.cell_height;
    }
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


@end
