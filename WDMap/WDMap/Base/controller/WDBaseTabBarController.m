//
//  WDBaseTabBarController.m
//  Class
//
//  Created by wbb on 2020/3/3.
//  Copyright © 2020 WD. All rights reserved.
//

#import "WDBaseTabBarController.h"
#import "WDRecommendVC.h"
#import "WDHistoryVC.h"
#import "WDCoordinateVC.h"
#import "WDBaseNavigationController.h"
#import "WDARVC.h"
#import "WDMineVC.h"

#import "WDGuideView.h"

@interface WDBaseTabBarController ()

@property (nonatomic, strong) WDGuideView *guideView;

@end


@implementation WDBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBar.tintColor = main_select_text_color;
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
//    [UITabBar appearance].translucent = NO;
    
    [self addTabBarVC:[[WDRecommendVC alloc] init] withTitle:@"推荐" withNormalImage:@"tabbar_recommend_normal" withSelectImage:@"tabbar_recommend_select"];
    [self addTabBarVC:[[WDHistoryVC alloc] init] withTitle:@"历史" withNormalImage:@"tabbar_history_normal" withSelectImage:@"tabbar_history_select"];
    [self addTabBarVC:[[WDCoordinateVC alloc] init] withTitle:@"坐标" withNormalImage:@"tabbar_coordinate_normal" withSelectImage:@"tabbar_coordinate_select"];
    [self addTabBarVC:[[WDARVC alloc] init] withTitle:@"AR游" withNormalImage:@"tabbar_ar_normal" withSelectImage:@"tabbar_ar_select"];
    [self addTabBarVC:[[WDMineVC alloc] init] withTitle:@"我的" withNormalImage:@"tabbar_mine_normal" withSelectImage:@"tabbar_mine_select"];

//    if ([WDGlobal isLogin]&&[[WDUtil getInfoForKey:WD_IDSFIRST] boolValue]) {
//        self.guideView.hidden = NO;
//    }
}

- (void)addTabBarVC:(UIViewController *)viewController withTitle:(NSString *)title withNormalImage:(NSString *)normalImage withSelectImage:(NSString *)selectImage {
    UIColor *titleColor = nil;
    if ([title isEqualToString:@"推荐"]) {
        titleColor = hexColor(FFEB00);
    }else if([title isEqualToString:@"历史"]) {
        titleColor = hexColor(326EFA);
    }else if([title isEqualToString:@"坐标"]) {
        titleColor = hexColor(32FAE6);
    }else if([title isEqualToString:@"AR游"]) {
        titleColor = hexColor(FF7D19);
    }else if([title isEqualToString:@"我的"]) {
        titleColor = hexColor(E1B9FA);
    }
    [viewController.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:titleColor} forState:UIControlStateSelected];

    viewController.tabBarItem.image = [UIImage imageNamed:normalImage];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    viewController.tabBarItem.title = title;
    WDBaseNavigationController *nav = [[WDBaseNavigationController alloc] initWithRootViewController:viewController];
    [self addChildViewController:nav];
}

#pragma mark - lazy
//- (WDGuideView *)guideView {
//    if (!_guideView) {
//        _guideView = [[WDGuideView alloc] init];
//        _guideView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREENH_HEIGHT);
//        [self.view addSubview:_guideView];
//    }
//    return _guideView;
//}

///** 点击tabbarItem自动调用 */
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSInteger index = [self.tabBar.items indexOfObject:item];
//    if (index != _currentIndex) {
//        // 不需要重复添加
//        if (self.tabBarImageVArray.count == 0) {
//            self.tabBarImageVArray = [self throughTabBarSubviewsMakeUpImageArray];
//        }
//        [self animationWithIndex:index];
//        _currentIndex = index;
//    }
//}
//
///** 遍历，将TabBar上需要动画的控件集合成数组 */
//- (NSArray *)throughTabBarSubviewsMakeUpImageArray {
//
//    NSMutableArray *imageMuArr = [NSMutableArray arrayWithCapacity:itemCount];
//
//    for (UIView *tabBarButton in self.tabBar.subviews) {
//        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//
//            /** 这一层for循环分离UITabBarButton中的imageV和label两个Subview，目的是只让图片有动画效果，或者只让文字有动画效果 */
//            // 当前只让图片有动画效果
//            for (UIImageView *barImageV in tabBarButton.subviews) {
//                if ([barImageV isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
//                    [imageMuArr addObject:barImageV];
//                }
//            }
//        }
//    }
//    return [imageMuArr mutableCopy];
//}

/**
 * 图片动画
 
 * CABasicAnimation类的使用方式就是基本的关键帧动画。
 * 所谓关键帧动画，就是将Layer的属性作为KeyPath来注册，指定动画的起始帧和结束帧，然后自动计算和实现中间的过渡动画的一种动画方式。
 */
//- (void)animationWithIndex:(NSInteger)index {
//
//    CABasicAnimation *pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//
//    pulse.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pulse.duration = 0.1;
//    pulse.repeatCount = 1;
//    pulse.autoreverses = YES;
//    pulse.fromValue = [NSNumber numberWithFloat:0.9];
//    pulse.toValue = [NSNumber numberWithFloat:1.1];
//    UIImageView *animalImageV = self.tabBarImageVArray[index];
//    [animalImageV.layer addAnimation:pulse forKey:nil];
//}
//
//- (NSArray *)tabBarImageVArray {
//    if (!_tabBarImageVArray) {
//        _tabBarImageVArray = [NSArray array];
//    }
//    return _tabBarImageVArray;
//}

@end
