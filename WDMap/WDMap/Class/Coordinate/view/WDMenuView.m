//
//  WDMenuView.m
//  WDMap
//
//  Created by wbb on 2021/2/2.
//

#import "WDMenuView.h"
#import "WDScenicClassifyModel.h"

@interface WDMenuView()
@property (nonatomic, copy) NSArray *menuList;
@property (nonatomic, strong) UIButton * selectBtn;
@end
@implementation WDMenuView

- (instancetype)initWithFrame:(CGRect)frame withMenuList:(NSArray *)menuList {
    self = [super initWithFrame:frame];
    if (self) {
        self.menuList = menuList;
        [self setCornerRadius:10];
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(5, 5);
        [self initUI];
    }
    return self;
}
- (void)initUI {
    
    float width = 50.f;
    float edge = 10.0;
    for (int i=0; i<self.menuList.count; i++) {
        WDScenicClassifyModel *model = self.menuList[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.appweixuanimg_url?:@""] forState:UIControlStateNormal];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.appxuanzhongimg_url?:@""] forState:UIControlStateSelected];

        btn.tag = 10+i;
        btn.frame = CGRectMake(edge, edge+(width + edge)*i, width, width);
        [self addSubview:btn];
    }
}

- (void)menuClick:(UIButton *)btn {
    
    if (self.selectBtn == btn) {
        return;
    }
    self.selectBtn.selected = NO;
    btn.selected = !btn.selected;
    
    WDScenicClassifyModel *model = self.menuList[btn.tag - 10];
    BOOL isChild = NO;
    if (model.childrendata && model.childrendata.count > 0) {
        isChild = YES;
    }
    if (self.menuTouchBlock) {
        self.menuTouchBlock(btn.tag - 10, isChild);
    }
    self.selectBtn = btn;
}
@end
