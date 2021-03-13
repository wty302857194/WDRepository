//
//  WDHomeVC.m
//  WDMap
//
//  Created by wbb on 2021/1/31.
//

#import "WDHomeVC.h"
#import "WDHomeCollectionViewCell.h"
#import "WDWKWebVC.h"

static  NSString *identifier = @"identifier";

typedef void(^FooterClickBlcok)(void);

@interface CollectionHeaderView : UICollectionReusableView
@property (copy, nonatomic) FooterClickBlcok footerClickBlcok;
@end

@implementation CollectionHeaderView
- (instancetype)initWithFrame:(CGRect)frame

{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIImageView *leftImageView = [[UIImageView alloc] init];
        leftImageView.image = [UIImage imageNamed:@"home_bottom"];
        [leftImageView addTarget:self action:@selector(touchClick)];
        [self addSubview:leftImageView];
        [leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.right.offset(0);
        }];
        
    }
    return self;
}
- (void)touchClick {
    if (self.footerClickBlcok) {
        self.footerClickBlcok();
    }
}
@end




@interface WDHomeVC ()<UICollectionViewDataSource>

@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) FLAnimatedImageView *gifImageView;
@end

@implementation WDHomeVC
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
    if (!kDelegate.isRootTabBarVC) {
        [self addGIFImageView];
    }
    
}
- (void)addGIFImageView {
    FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc] initWithFrame:self.view.bounds];
    gifImageView.userInteractionEnabled = NO;
    [self.view addSubview:gifImageView];
    self.gifImageView = gifImageView;
    
    NSString*name = @"202011181440417619.gif";
    NSString *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:name ofType:nil];
    NSData *imageData = [NSData dataWithContentsOfFile:filePath];
    FLAnimatedImage *aniImage = [[FLAnimatedImage alloc] initWithAnimatedGIFData:imageData];
    gifImageView.animatedImage = aniImage;
    
    kWEAK_SELF;
    gifImageView.loopCompletionBlock = ^(NSUInteger loopCountRemaining) {
        NSLog(@"loopCountRemaining === %lu",(unsigned long)loopCountRemaining);
        [weakSelf touchClick];
    };
    
}
- (void)touchClick {
    [self.gifImageView removeFromSuperview];
    self.gifImageView = nil;
}
#pragma mark - deleDate

//有多少的分组

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//每个分组里有多少个item

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 6;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据identifier从缓冲池里去出cell
    WDHomeCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    kWEAK_SELF;
    cell.buttnClickBlcok = ^{
        switch (indexPath.row) {
            case 0:
            {
                [kDelegate rootTabBarVC:1];
            }
                break;
            case 1:
            {
                [WDGlobal shareInstance].isVoiceBox = YES;
                [kDelegate rootTabBarVC:0];
            }
                break;
            case 2:
            {
                [kDelegate rootTabBarVC:2];
            }
                break;
            case 3:
            {
                [kDelegate rootTabBarVC:0];
            }
                break;
            case 4:
            {
                WDWKWebVC *vc = [[WDWKWebVC alloc] init];
                vc.navigationItem.title = @"关于文都";
                vc.htmlString = @"https://wxdt.vqune.com/mobile/guanyuwendu/show-1.html";
                [weakSelf.navigationController pushViewController:vc animated:YES];
                vc.navigationItem.rightBarButtonItem = nil;

            }
                break;
            case 5:
            {
                [kDelegate rootTabBarVC:3];
            }
                break;

            default:
                break;
        }
    };
    [cell indexPath:indexPath.row];
    return cell;
}
//footer的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    return CGSizeMake(kSCREEN_WIDTH, kSCREEN_WIDTH*96/375);
}
//header 和 footer的获取逻辑
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    UICollectionReusableView *view = nil;
    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
        CollectionHeaderView *temp = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        kWEAK_SELF;
        temp.footerClickBlcok = ^{
            [kDelegate rootTabBarVC:0];
        };
        view = temp;
    }
    
    return view;
}





- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        //自动网格布局
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        CGFloat itemWidth = (self.view.width-5) / 2.f;
        [flowLayout setFooterReferenceSize:CGSizeMake(kSCREEN_WIDTH, kSCREEN_WIDTH*96/375)];
        
        //设置单元格大小
        CGFloat coefficient = 189 / 186.f;
        if (kiPhone6) {
            coefficient = 126/124.f;
        }else if(kiPhone6Plus) {
            coefficient = 209/206.f;
        }else if(IS_IPHONE_Xr) {
            coefficient = 159/137.f;
        }else if(IS_IPHONE_Xs) {
            coefficient = 213/186.f;
        }else if(IS_IPHONE_Xs_Max) {
            coefficient = 238/205.f;
        }else if(IS_IPHONE_12_Pro) {
            coefficient = 223/193.f;
        }
        flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth * coefficient);
        
        //最小行间距(默认为10)
        
        flowLayout.minimumLineSpacing = 5;
        
        //最小item间距（默认为10）
        
        flowLayout.minimumInteritemSpacing = 5;
        
        //设置senction的内边距
        
        //网格布局
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        
        //注册cell
        [_collectionView registerNib:[UINib nibWithNibName:@"WDHomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
        [_collectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
        //设置数据源代理
        _collectionView.dataSource = self;
    }
    return _collectionView;
}
@end
