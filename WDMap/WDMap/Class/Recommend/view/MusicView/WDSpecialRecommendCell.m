//
//  WDSpecialRecommendCell.m
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import "WDSpecialRecommendCell.h"
#import "WDSpecialRecommindCollectionViewCell.h"
#import "WDAlbumVC.h"

@interface WDSpecialRecommendCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, copy) NSArray * currentDataArr;

@end

@implementation WDSpecialRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.collectionView];
        [self getyinyuefenleiRequestData];

    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}

#pragma mark - network

/// 声音盒子专辑
- (void)getyinyuefenleiRequestData {
    NSDictionary *dic = @{
        @"top": @"1",
        @"suiji" : @"是"
    };
    [TYNetworkTool getRequest:WDGetyinyuefenleiAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = [NSArray arrayWithArray:data[@"data"]];
            self.currentDataArr = [WDMusicAlbumModel mj_objectArrayWithKeyValuesArray:[arr subarrayWithRange:NSMakeRange(0, 3)]];
            [self.collectionView reloadData];
        }else {
            [MBProgressHUD promptMessage:msg inView:[WDGlobal getCurrentViewController].view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:[WDGlobal getCurrentViewController].view];
    }];
}

#pragma mark - deleDate

//有多少的分组

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个分组里有多少个item

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.currentDataArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据identifier从缓冲池里去出cell
    WDSpecialRecommindCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WDSpecialRecommindCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.row < self.currentDataArr.count) {
        cell.model = self.currentDataArr[indexPath.row];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WDMusicAlbumModel *model = self.currentDataArr[indexPath.row];
    WDAlbumVC *vc = [[WDAlbumVC alloc] init];
    vc.fenleiid = model.ID;
    [[WDGlobal getCurrentViewController].navigationController pushViewController:vc animated:self];
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        //设置单元格大小
    
        float item_width = (kSCREEN_WIDTH - 40)/3.f;
        flowLayout.itemSize = CGSizeMake(item_width, item_width + 30);
        
        //最小行间距(默认为10)
        
        flowLayout.minimumLineSpacing = 10;
        
        //最小item间距（默认为10）
        
        flowLayout.minimumInteritemSpacing = 10;
        
        //设置senction的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);

        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentView.frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"WDSpecialRecommindCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"WDSpecialRecommindCollectionViewCell"];
        //设置数据源代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
