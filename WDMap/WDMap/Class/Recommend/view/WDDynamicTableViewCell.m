//
//  WDDynamicTableViewCell.m
//  WDMap
//
//  Created by wbb on 2021/2/1.
//

#import "WDDynamicTableViewCell.h"
#import "WDDynamicScrollerCell.h"
#import <ZKCycleScrollView/ZKCycleScrollView.h>
#import "WDWebViewController.h"

static NSString * const kCellId = @"kCellId";

@interface WDDynamicTableViewCell() <ZKCycleScrollViewDelegate, ZKCycleScrollViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *moreImage;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@property (strong, nonatomic)ZKCycleScrollView *cycleScrollView;

@end

@implementation WDDynamicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = hexColor(efefef);

    // 3.纯代码方式创建有限轮播
    
    [self.backView addSubview:self.cycleScrollView];
    
    [self.moreImage addTarget:self action:@selector(pushNextVC)];
}
-(void)itemArray:(NSArray *)arr index:(NSInteger)index {
    _itemDataArr = arr;
    if (index == 0) {
        self.typeImage.image = [UIImage imageNamed:@"dynamic-chat-right-dots"];
        self.moreImage.image = [UIImage imageNamed:@"dynamic_dots"];
        self.titleLab.text = @"文学动态";
        self.contentLab.text = @"了解最新的世界文都信息";
    }else if(index == 1) {
        self.typeImage.image = [UIImage imageNamed:@"dynamic-chat-right-quote"];
        self.moreImage.image = [UIImage imageNamed:@"dynamic_quote"];
        self.titleLab.text = @"近期活动";
        self.contentLab.text = @"丰富的文都生活一览无余";
    }else if (index == 2) {
        self.typeImage.image = [UIImage imageNamed:@"dynamic-chat-right-text"];
        self.moreImage.image = [UIImage imageNamed:@"dynamic_text"];
        self.titleLab.text = @"在线书籍";
        self.contentLab.text = @"推荐最好的文学著作";
    }
    [self.cycleScrollView reloadData];
}

- (void)pushNextVC {
    if (self.pushDetailBlock) {
        self.pushDetailBlock();
    }
}

#pragma mark -- ZKCycleScrollView DataSource
- (NSInteger)numberOfItemsInCycleScrollView:(ZKCycleScrollView *)cycleScrollView {

    return self.itemDataArr.count;
    
}

- (__kindof ZKCycleScrollViewCell *)cycleScrollView:(ZKCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    WDDynamicScrollerCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:kCellId forIndex:index];
    cell.model = self.itemDataArr[index];
    return cell;
}

#pragma mark -- ZKCycleScrollView Delegate
- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    WDWebViewController *vc = [[WDWebViewController alloc] init];
    WDDynamicModel *model = self.itemDataArr[index];
    vc.htmlString = model.content?:@"";
    vc.navigationItem.title = model.sub_title?:@"";
    [[WDGlobal getCurrentViewController].navigationController pushViewController:vc animated:YES];

}

- (void)cycleScrollViewDidScroll:(ZKCycleScrollView *)cycleScrollView progress:(CGFloat)progress {
//    if (cycleScrollView != _colorCycleScrollView) return;
//     _pageControl.progress = progress;
    NSLog(@"progress = %f", progress);
}

- (void)cycleScrollView:(ZKCycleScrollView *)cycleScrollView didScrollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {

    
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    self.cycleScrollView.frame = self.backView.bounds;
    self.cycleScrollView.itemSize = CGSizeMake(kSCREEN_WIDTH - 180, self.backView.height);
}
#pragma mark - lazy

- (ZKCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[ZKCycleScrollView alloc] initWithFrame:self.backView.bounds shouldInfiniteLoop:NO]; // 这个初始化方法中第二个参数 shouldInfiniteLoop 意思是是否开启无线轮播；如果你使用其它初始化方法，例如 -initWithFrame：，默认是开启的，并且后续不能再更改
        _cycleScrollView.backgroundColor = hexColor(efefef);
        _cycleScrollView.delegate = self;
        _cycleScrollView.dataSource = self;
        _cycleScrollView.hidesPageControl = YES; // 隐藏默认的 pageControl，如果有需要你可以通过 -addSubView: 的方式添加自定义的 pageControl，然后在代理方法中进行联动
        _cycleScrollView.autoScroll = NO; // 关闭自动滚动
        _cycleScrollView.itemZoomScale = 0.8;
        _cycleScrollView.itemSpacing = 0.f; // 设置 cell 间距
        [_cycleScrollView registerCellNib:[UINib nibWithNibName:@"WDDynamicScrollerCell" bundle:nil] forCellWithReuseIdentifier:kCellId];
        __weak typeof(self) weakSelf = self;
        _cycleScrollView.loadCompletion = ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                [strongSelf.cycleScrollView scrollToItemAtIndex:1 animated:NO];
            };
    }
    return _cycleScrollView;
}
@end
