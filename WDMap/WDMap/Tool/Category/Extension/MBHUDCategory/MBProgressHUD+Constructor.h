//
//  MBProgressHUD+Constructor.h
//  NetClass
//
//  Created by wbb on 2017/11/9.
//  Copyright © 2017年 WD. All rights reserved.
//

/**
 *  MBProgressHUD 文字提示构造器
 */

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (Constructor)

#pragma mark -- 旋转背景属性修改 --
+ (instancetype)showHubViewAddedOnTopView:(UIView *)topView animated:(BOOL)animated;


/// 提示弹框，隐藏时回调
/// @param view 当前view
/// @param message 提示内容
/// @param completionBlock 回调事件
+ (instancetype)showView:(UIView *)view withMessage:(NSString *)message block:(void (^)(void))completionBlock;

#pragma mark -- label --
/// label:不偏移
+ (void)promptMessage:(NSString *)message inView:(UIView *)view;

/// label:上下偏移20
+ (void)promptMessageYoffset:(CGFloat)yyOffset withMessage:(NSString *)message inView:(UIView *)view;

#pragma mark -- detail --
+ (void)promptDetailMessage:(NSString *)message inView:(UIView *)view;

+ (void)hideHUD;


/// 打卡成功
+ (void)showDakaSuccess:(UIView *)view ;
@end
