//
//  WDBaseViewController.m
//  Class
//
//  Created by wbb on 2020/3/3.
//  Copyright © 2020 WD. All rights reserved.
//

#import "WDBaseViewController.h"

@interface WDBaseViewController ()

@end

@implementation WDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

//#pragma mark - 控制屏幕旋转方法
////是否自动旋转,返回YES可以自动旋转,返回NO禁止旋转
//- (BOOL)shouldAutorotate {
//    
//    return NO;
//}
//
////返回支持的方向
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    
//    return UIInterfaceOrientationMaskPortrait;
//}
//
////由模态推出的视图控制器 优先支持的屏幕方向
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    
//    return UIInterfaceOrientationPortrait;
//}

@end
