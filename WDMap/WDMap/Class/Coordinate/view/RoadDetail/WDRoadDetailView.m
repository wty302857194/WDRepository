//
//  WDRoadDetailView.m
//  WDMap
//
//  Created by wbb on 2021/2/16.
//

#import "WDRoadDetailView.h"
#import "WDRoadDetailCell.h"
#import "WDScenicModel.h"

@interface WDRoadDetailView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, copy) NSArray * dataArr;
@end
@implementation WDRoadDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.backView addTarget:self action:@selector(click)];
    
    [self initUI];
}
- (void)initUI {
    [self.contentBackView addSubview:self.collectionView];

}
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [WDGlobal addCorners:self.contentView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
}
- (IBAction)cancelClick:(UIButton *)sender {
    [self click];
}

- (void)click {
    self.hidden = YES;

}

- (void)GetxianlutoidRequestData:(NSString *)ID {
    NSDictionary *dic = @{
        @"xlid":ID
    };
    [TYNetworkTool getRequest:WDGetxianlutoidAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            [self initWithData:data];
            
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
- (void)initWithData:(NSDictionary *)dic {
    self.clockNumLab.text = dic[@"shichang"]?:@"0";
    self.locationNumLab.text = dic[@"jindianshu"]?:@"";
    self.titleLab.text = dic[@"parenttitle"]?:@"";
    self.contentLab.text = dic[@"title"]?:@"";
    self.dataArr = [WDRoadjingdiandataModel mj_objectArrayWithKeyValuesArray:dic[@"data"]];
    [self.collectionView reloadData];
}
#pragma mark - deleDate

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
    WDRoadDetailCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WDRoadDetailCell" forIndexPath:indexPath];
    cell.model = self.dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WDRoadjingdiandataModel *model = self.dataArr[indexPath.row];
    CGPoint point = CGPointMake([model.jingdu floatValue], [model.weidu floatValue]);
    if (self.locationBlock) {
        self.locationBlock(point);
    }
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        //设置单元格大小
        
        flowLayout.itemSize = CGSizeMake(70, 70);
        
        //最小行间距(默认为10)
        
        flowLayout.minimumLineSpacing = 10;
        
        //最小item间距（默认为10）
        
        flowLayout.minimumInteritemSpacing = 10;
        
        //设置senction的内边距
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);

        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:self.contentBackView.frame collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"WDRoadDetailCell" bundle:nil] forCellWithReuseIdentifier:@"WDRoadDetailCell"];
        //设置数据源代理
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

@end
