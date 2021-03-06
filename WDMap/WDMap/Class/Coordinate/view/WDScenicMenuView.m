//
//  WDScenicMenuView.m
//  WDMap
//
//  Created by wbb on 2021/2/25.
//

#import "WDScenicMenuView.h"
#import "WDScenicClassifyModel.h"

static NSInteger const close_width = 28;
@interface WDScenicMenuView()
@property (nonatomic, copy) NSArray *menuList;
@property (nonatomic, strong) UIButton * selectBtn;
@property (nonatomic, strong) UIButton * rightMenuBtn;

@property (nonatomic, assign) NSInteger index;/// item索引
/// 二级菜单点击
@property (nonatomic, assign) BOOL isChild;
@end
@implementation WDScenicMenuView

- (instancetype)initWithFrame:(CGRect)frame withMenuList:(NSArray *)menuList ;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.menuList = menuList;
        self.index = 0;
        
        [self initItemList:self.menuList];
        
        [self addRightMenuBtn];

    }
    return self;
}

/// 添加item
/// @param list 数据源
- (void)initItemList:(NSArray *)list{
    float width = 50.f;
    float edge = 10.0;
    float leftEdge = -(width + edge * 2);
    
    
    WDBaseView *menuView = [[WDBaseView alloc] initWithFrame:CGRectMake(leftEdge, 80 + (width + edge) * self.index, width + edge * 2, list.count * (width + edge) + edge)];
    menuView.tag = 10+self.index;
    [self addSubview:menuView];
    [WDGlobal addCorners:menuView emunType:WDRightState cornerNum:10];
    menuView.layer.shadowColor = [UIColor grayColor].CGColor;
    menuView.layer.shadowOffset = CGSizeMake(5, 5);
    

    
    for (int i=0; i<list.count; i++) {
        WDScenicClassifyModel *model = list[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(menuClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.appweixuanimg_url?:@""] forState:UIControlStateNormal];
        [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.appxuanzhongimg_url?:@""] forState:UIControlStateSelected];
        btn.isChild = self.isChild;
        btn.tag = 1000+i;
        btn.frame = CGRectMake(edge, edge+(width + edge)*i, width, width);
        [menuView addSubview:btn];
    }
}
/// MARK: 左边按钮
- (void)addRightMenuBtn {
    
    CGFloat width = close_width;
    
    CGFloat center_y = 80+(self.menuList.count * (50+10) +10)/2.f - width*94/28.f/2;

    UIButton *rightMenuBtn = [UIButton buttonWithBackgroundImage:@"Coordinate_left_close" target:self action:@selector(menuCkick)];
    rightMenuBtn.frame = CGRectMake(0, 0, width, width*94/28.f);
    rightMenuBtn.center = CGPointMake(0, center_y);
    [self addSubview:rightMenuBtn];
    self.rightMenuBtn = rightMenuBtn;
}
- (void)menuCkick {
    [self disappear];
    [self removeSecondMenu];
    
    self.selectBtn.selected = NO;
    self.selectBtn = nil;
}

/// 移除二级菜单
- (void)removeSecondMenu {
    if (self.isChild) {
        self.isChild = NO;
        UIView *view = [self viewWithTag:10 + self.index];
        [view removeFromSuperview];
        view = nil;
        self.index = 0;
    }
}
- (void)menuClick:(UIButton *)btn {
    
    if (self.selectBtn == btn) {
        return;
    }
    self.selectBtn.selected = NO;
    btn.selected = !btn.selected;
    NSInteger tagIndex = btn.tag - 1000;
    self.rightMenuBtn.hidden = NO;
    self.width = btn.superview.width + close_width;
    
    if (btn.isChild) {
        WDScenicClassifyModel *model = self.menuList[self.index];
        WDScenicClassifyModel *item_model = model.childrendata[tagIndex];
        
        if (self.menuTouchBlock) {
            self.menuTouchBlock(item_model);
        }
        
        [self removeSecondMenu];
    }else {
        WDScenicClassifyModel *model = self.menuList[tagIndex];
        if (model.childrendata && model.childrendata.count > 0) {
            self.rightMenuBtn.hidden = YES;
            self.width = 2 * btn.superview.width;
            self.index = tagIndex;
            self.isChild = YES;
            [self initItemList:model.childrendata];
            [self show];
        }else {
            
            [self removeSecondMenu];
            
            if (self.menuTouchBlock) {
                self.menuTouchBlock(model);
            }
        }
    }
    
    self.selectBtn = btn;
}
- (void)show {
    self.hidden = NO;
    UIView *view = [self viewWithTag:10 + self.index];
    [UIView animateWithDuration:0.2 animations:^{
        if (self.index>0) {
            view.x = view.width;
        }else {
            view.x = 0;
            self.rightMenuBtn.x = view.width;
        }
    }];
    
}
- (void)disappear {
    UIView *view = [self viewWithTag:10];
    [UIView animateWithDuration:0.2 animations:^{
        view.x = -view.width;
        self.rightMenuBtn.x = - self.rightMenuBtn.right;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

@end
