//
//  WDMineMedalVC.m
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDMineMedalVC.h"
#import "WDMineMedalCvCell.h"
#import "WDMineMedalDetailVC.h"

@interface WDMineMedalVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, copy) NSArray * dataArr;
@end

@implementation WDMineMedalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"我的勋章";
    [self.view addSubview:self.collectionView];
    
    [self GetxunzhangRequestData];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}
#pragma mark - network
/*
 Getxunzhang
 */
- (void)GetxunzhangRequestData {
    NSDictionary *dic = @{
        @"openid" : @"",
        @"uid" : [WDGlobal userID],
    };
    [TYNetworkTool getRequest:WDGetxunzhangAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {

        if ([data[@"status"] integerValue] == 1) {
            self.dataArr = [WDMineXunzhangModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [self.collectionView reloadData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {

        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
#pragma mark - delegate

//有多少的分组

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个分组里有多少个item

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据identifier从缓冲池里去出cell
    WDMineMedalCvCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WDMineMedalCvCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WDMineXunzhangModel *model = self.dataArr[indexPath.row];
    WDMineMedalDetailVC *vc = [[WDMineMedalDetailVC alloc] init];
    vc.imgString = model.xunzhang?:@"";
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        CGFloat itemWidth = (kSCREEN_WIDTH - 0) / 2.f;
        //设置单元格大小
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth * 3/ 5.f);
        
        //最小行间距(默认为10)
        
        flowLayout.minimumLineSpacing = 0;
        
        //最小item间距（默认为10）
        
        flowLayout.minimumInteritemSpacing = 0;
        
        //设置senction的内边距
        
        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = main_background_color;
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"WDMineMedalCvCell" bundle:nil] forCellWithReuseIdentifier:@"WDMineMedalCvCell"];
        //设置数据源代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
