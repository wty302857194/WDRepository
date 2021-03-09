//
//  WDGuideView.m
//  WDMap
//
//  Created by wbb on 2021/1/30.
//

#import "WDGuideView.h"
@interface WDGuideView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView * scrollView;
@end
@implementation WDGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    [scrollView setContentSize:CGSizeMake(kSCREEN_WIDTH * 4, kSCREENH_HEIGHT)];
    scrollView.delegate = self;

    scrollView.scrollEnabled = YES;

    scrollView.pagingEnabled = YES; //使用翻页属性

    scrollView.bounces = NO;
    [self addSubview:scrollView];
    self.scrollView = scrollView;
    
    for (int i = 0; i<4; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*kSCREEN_WIDTH, 0, kSCREEN_WIDTH, kSCREENH_HEIGHT)];
        imgView.image = [UIImage imageNamed:@""];
        [scrollView addSubview:imgView];
    }
    
    //定义PageControll
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kSCREENH_HEIGHT - 100, kSCREEN_WIDTH, 20)];
    self.pageControl.numberOfPages = 4;//指定页面个数
    
    self.pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    [self.pageControl setValue:[UIImage imageNamed:@"BluePoint.png"] forKeyPath:@"_currentPageImage"];

    [self.pageControl setValue:[UIImage imageNamed:@"black"] forKeyPath:@"_pageImage"];
    
    [self addSubview:self.pageControl];
}
//scrollview的委托方法，当滚动时执行

- (void)scrollViewDidScroll:(UIScrollView *)sender {

    int page = self.scrollView.contentOffset.x / kSCREEN_WIDTH;//通过滚动的偏移量来判断目前页面所对应的小白点

    self.pageControl.currentPage = page;//pagecontroll响应值的变化

}

- (void)changePage:(UIPageControl *)sender {

    NSInteger page = self.pageControl.currentPage;//获取当前pagecontroll的值

    [self.scrollView setContentOffset:CGPointMake(kSCREEN_WIDTH * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面

   }
@end
