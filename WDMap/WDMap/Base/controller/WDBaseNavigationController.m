//
//  WDBaseNavigationController.m
//  Class
//
//  Created by wbb on 2020/3/3.
//  Copyright © 2020 WD. All rights reserved.
//

#import "WDBaseNavigationController.h"
#import "WDLoginViewController.h"
#import "WDMusicPlayVC.h"

@interface WDBaseNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, getter=isPushing) BOOL isPushing; ///< 是否正在push，防止多次push同一个VC

/// 是否是gif
@property (nonatomic, assign) BOOL isGif;
@end

@implementation WDBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeImg:) name:WD_CHANGEGIFIMAGR object:nil];
}

- (void)changeImg:(NSNotification *)notification {
    NSNumber *num = notification.object;
    self.isGif = [num boolValue];
    if (self.isGif) {
        [self setGifImg];
    }else {
        [self setBackImg];
    }
}
- (void)rightPlayClick {
    if (![kDelegate.window.subviews containsObject:[WDMusicPlayView musicPlayView]]) {
        [WDGlobal removeMusicPlayView];
        return;
    }
    [WDGlobal showMusicPlayView];
}
- (void)setGifImg {
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"rightBarItem" ofType:@"gif"];
    NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage sd_imageWithGIFData:imageData];
    for (UIButton *btn in [WDGlobal shareInstance].rightBarBtnArr) {
        [btn setBackgroundImage:image forState:UIControlStateNormal];

    }
    
}
- (void)setBackImg {
    for (UIButton *btn in [WDGlobal shareInstance].rightBarBtnArr) {
        [btn setBackgroundImage:[UIImage imageNamed:@"recommend_play"] forState:UIControlStateNormal];
    }

}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    // 拦截多次push同一个VC
    if (self.isPushing) {
        return;
    }
    self.isPushing = YES;
    
    
    
    if (!kDelegate.isRootLogin) {
        UIImage *image = nil;
        if(self.isGif) {
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"rightBarItem" ofType:@"gif"];
            NSData *imageData = [NSData dataWithContentsOfFile:imagePath];
            image = [UIImage sd_imageWithGIFData:imageData];
        }else {
            image = [UIImage imageNamed:@"recommend_play"];
        }
        UIButton *right_home = [UIButton buttonWithType:UIButtonTypeCustom];
        right_home.frame = CGRectMake(0, 0, 25, 25);
        [right_home setBackgroundImage:image forState:UIControlStateNormal];
        
        [right_home addTarget:self action:@selector(rightPlayClick) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:right_home];
        
        [[WDGlobal shareInstance].rightBarBtnArr addObject:right_home];
    }
    
    
    
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        NSString *imageStr = @"mine_goBack";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:imageStr] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
        backItem.imageInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        viewController.navigationItem.leftBarButtonItem = backItem;

        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    UIViewController *vc = [WDGlobal getCurrentViewController];
    UIButton *btn = vc.navigationItem.rightBarButtonItem.customView;
    [[WDGlobal shareInstance].rightBarBtnArr removeObject:btn];
    
    return [super popViewControllerAnimated:animated];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    self.isPushing = NO;
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
