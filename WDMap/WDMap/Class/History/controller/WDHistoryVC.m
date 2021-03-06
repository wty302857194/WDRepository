//
//  WDHistoryVC.m
//  WDMap
//
//  Created by wbb on 2021/1/29.
//

#import "WDHistoryVC.h"
#import "WDHistoryCvCell.h"
#import "WDDigitModel.h"
#import "WDScenicModel.h"

static const  NSInteger maxWidth = 70;

@interface WDHistoryVC ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) UIScrollView * scrollerView;

@property (nonatomic, strong) NSMutableArray * dynastyArr;
@property (nonatomic, copy) NSString *dynastyID;
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, copy) NSArray * poetArr;
@property (nonatomic, copy) NSArray * scenicArr;
@end

@implementation WDHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = main_background_color;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"数字文都";
    self.selectIndex = 0;
    
    [self GetniandaiRequestData];
    
    [self.view addSubview:self.collectionView];
//    [self initBottomView];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.height.offset(100);
    }];
    
    
    
    
}
#pragma mark - network
- (void)GetniandaiRequestData {
    NSDictionary *dic = @{
        
    };
    [TYNetworkTool getRequest:WDGetniandaiAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            self.dynastyArr = [NSMutableArray arrayWithCapacity:0];
            NSArray *arr = [WDDigitModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            for (int i = 0; i < arr.count; i++) {
                WDDigitModel *model = arr[i];
                if(i == 0) {
                    self.dynastyID = model.ID;
                }
                model.isSelect = i == 0 ? YES : NO;
                [self.dynastyArr addObject:model];
            }
            
            
            [self.collectionView reloadData];
            
            [self GetrenwuRequestData];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
/*
 action:Getrenwu
 fenleiid：分类ID（年代ID） （传值0，则显示所有分类下的数据）
 pageSize：每页记录数
 pageIndex：当前页数
 */
- (void)GetrenwuRequestData {
    NSDictionary *dic = @{
        @"fenleiid" : self.dynastyID,
        @"pageSize" : @"9999",
        @"pageIndex" : @"0"
    };
    [TYNetworkTool getRequest:WDGetrenwuAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = [WDPoetModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            self.poetArr = arr;
            [self initBottomView];
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
    
    return self.dynastyArr.count;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //根据identifier从缓冲池里去出cell
    WDHistoryCvCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WDHistoryCvCell" forIndexPath:indexPath];
    if (indexPath.row < self.dynastyArr.count) {
        WDDigitModel *model = self.dynastyArr[indexPath.row];
        cell.model = model;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.selectIndex == indexPath.row) {
        return;
    }
    WDDigitModel *model = self.dynastyArr[indexPath.row];
    model.isSelect = YES;
    
    if (self.selectIndex != indexPath.row) {
        if(self.selectIndex < self.dynastyArr.count) {
            WDDigitModel *select_model = self.dynastyArr[self.selectIndex];
            select_model.isSelect = NO;
        }
    }
    
    self.selectIndex = indexPath.row;
    
    [self.collectionView reloadData];
    
    self.dynastyID = model.ID;
    [self GetrenwuRequestData];
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
    for(UIView *view in [self.scrollerView subviews]) {
        [view removeFromSuperview];
    }
    
    UIScrollView *scrollerView = [[UIScrollView alloc] init];
    scrollerView.showsVerticalScrollIndicator = NO;
    scrollerView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollerView];
    self.scrollerView = scrollerView;
    [scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
    [self.view setNeedsDisplay];
    [self.view layoutSubviews];
    
    /// 总共分为几页
    NSInteger count = ceilf(self.poetArr.count / 10.f);
    [scrollerView setContentSize:CGSizeMake(count * kSCREEN_WIDTH, scrollerView.height)];
    
    for (int i = 0; i<count; i++) {
        WDBaseView *bottomView = [[WDBaseView alloc] initWithFrame:CGRectMake(i*kSCREEN_WIDTH, 0, kSCREEN_WIDTH, scrollerView.height)];
        bottomView.clipsToBounds = YES;
        [scrollerView addSubview:bottomView];
        [WDGlobal addCorners:bottomView];
        
        UIImageView *backImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"history_bgi"]];
        backImgView.contentMode = UIViewContentModeScaleAspectFit;
        [bottomView addSubview:backImgView];
        [backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
        
        /// 这里是每页显示的数据
        NSArray *dataArr = @[];
        if (count>1) {
            if (i < count-1 ) {
                dataArr = [self.poetArr subarrayWithRange:NSMakeRange(i*10, 10)];
            }else {
                dataArr = [self.poetArr subarrayWithRange:NSMakeRange(i*10, self.poetArr.count - i*10)];
            }
        }else {
            dataArr = [self.poetArr subarrayWithRange:NSMakeRange(0, self.poetArr.count)];
        }
        
        
        [self initUI:dataArr withSupperView:bottomView];
    }
}

- (void)initUI:(NSArray *)dataArr withSupperView:(UIView *)view {
    NSInteger width = view.frame.size.width;
    NSInteger height = view.frame.size.height;

    NSMutableArray *frameArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < dataArr.count; i++) {
        WDPoetModel *model = dataArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

        // 元素宽高
        float count = 0;
        // x坐标
        float x = 0;
        // y坐标
        float y = 0;

        count = arc4random()%10 + maxWidth -10;
        btn.tag = [model.ID integerValue];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:model.xingming?:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(touchClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"history_nomal_img"] forState:UIControlStateNormal];
//        x = arc4random()%(width/2)+(width/4);
//        y = arc4random()%(height/2)+(width/4);
        x = arc4random()%(width *2/3)+(width/7);
        y = arc4random()%(height*2/3)+(height/7);
        if (i>0) {
            while ([self isContain:CGRectMake(x, y, count, count) frameArray:frameArr]) {
                x = arc4random()%(width *2/3)+(width/7);
                y = arc4random()%(height*2/3)+(height/7);
            }
        }

        btn.frame = CGRectMake(x, y, count, count);
        [view addSubview:btn];

        [frameArr addObject:@(btn.frame)];
    }
}
- (void)touchClick:(UIButton *)btn {
    if(btn.isSelected) return;
    
    for (UIView *view in btn.superview.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            if (view != btn) {
                [view setHidden:YES];
            }
        }
    }
    
    [btn setBackgroundImage:[UIImage imageNamed:@"history_ poetry_name"] forState:UIControlStateNormal];
    
    [self GetjingdiantouidRequestData:[NSString stringWithFormat:@"%ld", (long)btn.tag] fromView:btn];
    
    btn.selected = !btn.selected;
}
/*
 action:Getjingdiantouid
 rwid:人物ID
 pageSize：每页记录数
 pageIndex：当前页数
 */
- (void)GetjingdiantouidRequestData:(NSString *)rwid fromView:(UIButton *)btn{
    NSDictionary *dic = @{
        @"rwid" : rwid,
        @"pageSize" : @"9999",
        @"pageIndex" : @"0"
    };
    [TYNetworkTool getRequest:WDGetjingdiantouidAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            self.scenicArr = [WDScenicModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [self initJingdianUI:self.scenicArr withSupperView:btn];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
- (void)initJingdianUI:(NSArray *)dataArr withSupperView:(UIButton *)button {
    
    
    UIView *view = button.superview;
    NSInteger width = view.frame.size.width;
    NSInteger height = view.frame.size.height;

    [UIView animateWithDuration:0.2 animations:^{
        button.width = button.width +10;
        button.height = button.height +10;
        
        for (UIView *imgView in view.subviews) {
            if ([imgView isKindOfClass:[UIImageView class]]) {
                imgView.transform = CGAffineTransformMakeScale(0.95, 0.95);
            }
        }
    }];
    
    
    NSMutableArray *frameArr = [NSMutableArray arrayWithCapacity:0];
    [frameArr addObject:@(button.frame)];
    for (int i = 0; i < dataArr.count; i++) {
        WDScenicModel *model = dataArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

        // 元素宽高
        float count = button.width - 10;
        
        // x坐标
        float x = arc4random()%(width/2)+(width/5);
        // y坐标
        float y = arc4random()%(height/2)+(height/5);
        while ([self isContain:CGRectMake(x, y, count, count) frameArray:frameArr]) {
            x = arc4random()%(width/2)+(width/5);
            y = arc4random()%(height/2)+(height/5);
        }
        
        btn.tag = i + 9999999;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [btn setTitle:model.title?:@"" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(jingdianDetail:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"history_item_bgi"] forState:UIControlStateNormal];

        btn.frame = CGRectMake(x, y, count, count);
        [view addSubview:btn];

        [frameArr addObject:@(btn.frame)];
    }
}
- (void)jingdianDetail:(UIButton *)btn {
    UITabBarController *tabVC = (UITabBarController *)kWindow.rootViewController;
    [tabVC setSelectedIndex:2];
    WDScenicModel *model = self.scenicArr [btn.tag - 9999999];
    [WDGlobal shareInstance].scenicModel = model;
}

- (BOOL)isContain:(CGRect)currentFrame frameArray:(NSArray *)frameArr {

    BOOL isContain = NO;
    for (int i = 0; i<frameArr.count; i++) {
        CGRect frame = [frameArr[i] CGRectValue];
        if (CGRectIntersectsRect(frame, currentFrame)) {
            isContain = YES;
            break;
        }
    }
    return isContain;
}

@end
