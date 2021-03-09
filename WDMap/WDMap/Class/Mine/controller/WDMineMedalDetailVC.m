//
//  WDMineMedalDetailVC.m
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDMineMedalDetailVC.h"
#import "WDCoordinateShareView.h"

@interface WDMineMedalDetailVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) WDCoordinateShareView * shareView;
@end

@implementation WDMineMedalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.shareView];

    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.imgString] placeholderImage:PLACE_HOLDER_IMAGE];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTouch)];
    longPress.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:longPress];
    
    
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.equalTo(self.view.mas_safeAreaLayoutGuideLeft);
        make.right.equalTo(self.view.mas_safeAreaLayoutGuideRight);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}
- (void)longTouch {
    self.shareView.hidden = NO;
}
- (WDCoordinateShareView *)shareView {
    if (!_shareView) {
        _shareView = [WDCoordinateShareView shareInstance];
        _shareView.hidden = YES;
        kWEAK_SELF;
        _shareView.touchHiddenBlock = ^(NSInteger index) {
            switch (index) {
                case 0:// 微信
                {
                    
                }
                    break;
                case 1:// 朋友圈
                {
                    
                }
                    break;
                case 2:// qq
                {
                    
                }
                    break;
                case 3:// 新浪
                {
                    
                }
                    break;
                case 4:// 下载
                {
                    
                }
                    break;
                default:
                    break;
            }
        };
    }
    return _shareView;
}
@end
