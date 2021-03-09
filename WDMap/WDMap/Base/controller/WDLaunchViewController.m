//
//  WDLaunchViewController.m
//  WDMap
//
//  Created by wbb on 2021/2/22.
//

#import "WDLaunchViewController.h"

@interface WDLaunchViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIPageControl * pageControl;

@property (nonatomic, copy) NSArray * dataArr;
@end

@implementation WDLaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initWithUI];
    [self getyindaotuRequestData];
    
}
- (void)initWithUI {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed:@"launch_image_1"];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    
}
- (void)getyindaotuRequestData {
    [TYNetworkTool getRequest:WDGetyindaotuAPI parameters:@{} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            self.dataArr = [NSArray arrayWithArray:data[@"data"]];
            
            [self initUI];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
            [self initUI];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
        [self initUI];
        
    }];
}
- (void)initUI {
    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.pageControl];
}
- (void)getinHome {
    [WDUtil setInfo:@(YES) forKey:WD_IDSFIRSTCOMED];
    [kDelegate setRootVC];
}

#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //计算pagecontroll相应地页(滚动视图可以滚动的总宽度/单个滚动视图的宽度=滚动视图的页数)
    NSInteger currentPage = (int)(scrollView.contentOffset.x) / (int)(self.view.frame.size.width);
    self.pageControl.currentPage = currentPage;//将上述的滚动视图页数重新赋给当前视图页数,进行分页
}
#pragma mark - pageControll的事件响应
-(void)pageControlChanged:(UIPageControl*)sender
{
    //计算scrollview相应地contentOffset
    CGFloat x = sender.currentPage * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(x,0);
    
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(self.view.width * 4, self.view.height);
        
        NSInteger count = 4;
        if (self.dataArr && self.dataArr.count>0) {
            count = self.dataArr.count;
        }
        
        for (int i = 0; i<count; i++) {
            NSDictionary *dic = self.dataArr[i];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.view.width, 0, self.view.width, self.view.height)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:dic[@"img_url"]?:@""] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"launch_image_%d",i+1]]];
            [_scrollView addSubview:imgView];
            
            if (i == count - 1) {
                [imgView addTarget:self action:@selector(getinHome)];
            }
        }
    }
    return _scrollView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.height - 80, self.scrollView.width, 50)];
        NSInteger count = 4;
        if (self.dataArr && self.dataArr.count>0) {
            count = self.dataArr.count;
        }
        _pageControl.numberOfPages = count;
        _pageControl.pageIndicatorTintColor = hexColor(f1f0e8);
        _pageControl.currentPageIndicatorTintColor = hexColor(898989);
        [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventValueChanged];

    }
    return _pageControl;
}
@end
