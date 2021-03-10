//
//  WDHistoryVC.m
//  WDMap
//
//  Created by wbb on 2021/1/29.
//

#import "WDHistoryVC.h"
#import "WDHistoryCvCell.h"

@interface WDHistoryVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIView * bottomView;
@end

@implementation WDHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = main_background_color;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"数字文都";
    
    
    [self.view addSubview:self.collectionView];
    [self initBottomView];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.offset(100);
    }];
    
    
    
    [WDGlobal addCorners:self.bottomView];
}

#pragma mark - delegate

//有多少的分组

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个分组里有多少个item

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据identifier从缓冲池里去出cell
    WDHistoryCvCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WDHistoryCvCell" forIndexPath:indexPath];
    cell.isSelect = indexPath.row == 0 ? YES : NO;
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WDHistoryCvCell *cell = (WDHistoryCvCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.isSelect = YES;
}
#pragma mark - lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        CGFloat itemWidth = kSCREEN_WIDTH / 5.f;
        //设置单元格大小
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 10);
        
        //最小行间距(默认为10)
        
        flowLayout.minimumLineSpacing = 0;
        
        //最小item间距（默认为10）
        
        flowLayout.minimumInteritemSpacing = 0;
        
        //设置senction的内边距
        
        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = main_background_color;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"WDHistoryCvCell" bundle:nil] forCellWithReuseIdentifier:@"WDHistoryCvCell"];
        //设置数据源代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}
- (void)initBottomView {
    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    
    UIImageView *backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history_bgi"]];
    
}
@end
