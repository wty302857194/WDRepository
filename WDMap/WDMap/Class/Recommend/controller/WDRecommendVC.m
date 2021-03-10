//
//  WDRecommendVC.m
//  WDMap
//
//  Created by wbb on 2021/1/29.
//

#import "WDRecommendVC.h"
#import "WDDynamicVC.h"
#import "WDVoiceBoxVC.h"
#import "WDHomeVC.h"

@interface WDRecommendVC ()<UIScrollViewDelegate>
@property(nonatomic, strong) UIButton *rightBtn;

@property(nonatomic, strong) UIButton *selectBtn;
@property(nonatomic, strong) UILabel *lineLab;

@property(nonatomic, strong) UIScrollView *scrollView;
@end

@implementation WDRecommendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文都地图";
    self.edgesForExtendedLayout = UIRectEdgeNone;

    [self initUI];
    
    if ([WDGlobal shareInstance].isVoiceBox) {
        [self dynamicClick:self.rightBtn];
        [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH, 0)];
    }
}
- (void)initUI {
    [self addBarButtonItem];
    
    [self addChileVC];
}
- (void)addChileVC {
    WDDynamicVC *dynamicVC = [[WDDynamicVC alloc] init];
    dynamicVC.view.frame = CGRectMake(0, 0, kSCREEN_WIDTH, self.view.height);
    [self addChildViewController:dynamicVC];
    [self.scrollView addSubview:dynamicVC.view];

    
    WDVoiceBoxVC *voiceBoxVC = [[WDVoiceBoxVC alloc] init];
    voiceBoxVC.view.frame = CGRectMake(kSCREEN_WIDTH, 0, kSCREEN_WIDTH, self.view.height);
    [self addChildViewController:voiceBoxVC];
    [self.scrollView addSubview:voiceBoxVC.view];

}
/// MARK : BarButtonItem
- (void)addBarButtonItem {
    UIButton *left_home = [UIButton buttonWithType:UIButtonTypeCustom];
    [left_home setBackgroundImage:[UIImage imageNamed:@"dynamic_search"] forState:UIControlStateNormal];
    left_home.frame = CGRectMake(0, 0, 25, 25);
    [left_home addTarget:self action:@selector(leftHomeClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:left_home];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    UIButton *leftBtn = [UIButton buttonWithTitle:@"文都动态" titleColor:[UIColor blackColor] font:[UIFont systemFontOfSize:18] target:self action:@selector(dynamicClick:)];
    leftBtn.tag = 10;
    leftBtn.frame = CGRectMake(0, 0, titleView.width/2.f, titleView.height);
    [titleView addSubview:leftBtn];

    UIButton *rightBtn = [UIButton buttonWithTitle:@"声音盒子" titleColor:hexColor(898989) font:[UIFont systemFontOfSize:18] target:self action:@selector(dynamicClick:)];
    rightBtn.tag = 11;
    rightBtn.frame = CGRectMake(titleView.width/2.f, 0, titleView.width/2.f, titleView.height);
    [titleView addSubview:rightBtn];
    self.rightBtn = rightBtn;
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, titleView.height-1, titleView.width/2.f, 1)];
    lab.backgroundColor = hexColor(ffeb00);
    [titleView addSubview:lab];
    self.lineLab = lab;
    self.navigationItem.titleView = titleView;
    
    self.selectBtn = leftBtn;
    

}
- (void)leftHomeClick {
//    [kDelegate rootHomeVC];
}

- (void)dynamicClick:(UIButton *)btn {
    if (self.selectBtn == btn) {
        return;
    }
    [self.selectBtn setTitleColor:hexColor(898989) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [UIView animateWithDuration:0.2 animations:^{
        self.lineLab.center = CGPointMake(btn.centerX, self.lineLab.centerY);
        [self.scrollView setContentOffset:CGPointMake((btn.tag - 10) * kSCREEN_WIDTH, 0)];
    }];
    
    self.selectBtn = btn;


}
#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

#pragma mark - lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = NO;
        [self.view addSubview:_scrollView];
        _scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH * 2, self.view.height);

        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return  _scrollView;
}
@end
