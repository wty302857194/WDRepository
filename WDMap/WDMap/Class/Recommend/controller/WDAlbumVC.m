//
//  WDAlbumVC.m
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import "WDAlbumVC.h"
#import "WDAlbumTableViewCell.h"
#import "WDMusicModel.h"
#import "WDMusicPlayVC.h"
#import "WDMusicPlayView.h"

@interface WDAlbumVC ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSMutableArray * dataArr;

@property (nonatomic, assign) NSInteger pageIndex;
/// 是否加载
@property (nonatomic, assign) BOOL isFresh;
@end

@implementation WDAlbumVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refershDataSource];
}
- (IBAction)play:(id)sender {
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
        [weakSelf getyinyueRequestData];
    }];
}
- (void)headerRefreshRequest {
    self.pageIndex = 0;
    self.isFresh = NO;
    [self getyinyueRequestData];
}
#pragma mark - network
- (void)getyinyueRequestData {
    /*
     action:Getyinyue
     fenleiid：专辑ID
     pageSize：每页记录数
     pageIndex：当前页数

     */
    NSDictionary *dic = @{
        @"pageSize": @"10",
        @"fenleiid" : self.fenleiid?:@"",
        @"pageIndex" : @(self.pageIndex),
    };
    [TYNetworkTool getRequest:WDGetyinyueAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([data[@"status"] integerValue] == 1) {

            WDGetyinyueModel *model = [WDGetyinyueModel mj_objectWithKeyValues:data];
            NSArray *arr = model.playMusicList;
            if (self.isFresh) {
                if (arr&&arr.count>0) {
                    [self.dataArr addObjectsFromArray:arr];
                    [self.tableView reloadData];

                }else {
                    [MBProgressHUD promptMessage:@"没有更多了" inView:self.view];
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];

                }
            }else {
                [self initUIWithModel:model];
                
                self.dataArr = [NSMutableArray arrayWithCapacity:0];
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

/// 初始化UI
/// @param model model description
- (void)initUIWithModel:(WDGetyinyueModel *)model {
    self.titleLab.text = model.title;
    self.contentLab.text = model.content;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
}
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WDAlbumTableViewCell" owner:nil options:nil].lastObject;
    }
    if (indexPath.row < self.dataArr.count) {
        WDPlayMusicListModel *model = self.dataArr[indexPath.row];
        cell.model = model;
        cell.indexLab.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    WDMusicPlayVC *vc = [[WDMusicPlayVC alloc] init];
//    [vc musicArray:self.dataArr index:indexPath.row];
//    [self presentViewController:vc animated:YES completion:nil];
    
    WDPlayMusicListModel *model = self.dataArr[indexPath.row];
    [WDGlobal showMusicPlayView];
    [[WDMusicPlayView musicPlayView] currrentFenleiid:self.fenleiid currentMusicId:model.ID];
}
@end
