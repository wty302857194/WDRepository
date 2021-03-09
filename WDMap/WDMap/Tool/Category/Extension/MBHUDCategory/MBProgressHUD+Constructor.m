//
//  MBProgressHUD+Constructor.m
//  NetClass
//
//  Created by wbb on 2017/11/9.
//  Copyright © 2017年 WD. All rights reserved.
//

#import "MBProgressHUD+Constructor.h"
@interface CustomView : WDBaseView

@end
@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"coordinate_daka_success"]];
        [imgView sizeToFit];
        imgView.frame = CGRectMake(48, 34, self.width-96, self.width-96);
        [self addSubview:imgView];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"打卡成功";
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.frame = CGRectMake(0, 0, self.width, 30);
        titleLab.center = CGPointMake(CGRectGetMidX(imgView.frame), CGRectGetMaxY(imgView.frame) +20);
        [self addSubview:titleLab];
    }
    return self;
}
- (CGSize)intrinsicContentSize {
    CGFloat height = 174;
    CGFloat width = 174;
    return CGSizeMake(width, height);
}


@end



@implementation MBProgressHUD (Constructor)

+ (instancetype)showHubViewAddedOnTopView:(UIView *)topView animated:(BOOL)animated
{
    MBProgressHUD *hud;
    if (topView == nil) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    } else {
        hud = [MBProgressHUD showHUDAddedTo:topView animated:YES];
    }
    hud.graceTime = 0.5;
//    hud.bezelView.color = [UIColor blackColor];
//    hud.bezelView.alpha = 0.8;
    return hud;
}

+ (instancetype)showView:(UIView *)view withMessage:(NSString *)message block:(void (^)(void))completionBlock
{
    MBProgressHUD *hud = [MBProgressHUD commonPropertyShowInView:view];

    hud.label.text = message;
//    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:14];
    hud.margin = 10.f;
    
    /// 显示2秒后隐藏
    [hud hideAnimated:YES afterDelay:2];

    /// 隐藏后代理回调
    hud.completionBlock = ^{
        completionBlock();
    };
    return hud;
}

+ (instancetype)commonPropertyShowInView:(UIView *)view
{
    MBProgressHUD *hud;
    if (view == nil) {
        hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
    } else {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
//    hud.bezelView.color = [UIColor colorWithWhite:0.f alpha:1];
//    hud.contentColor = [UIColor colorWithWhite:0.f alpha:1];
    hud.mode = MBProgressHUDModeText;
    
//    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont systemFontOfSize:14];
    
    hud.margin = 10.f;
    return hud;
}

+ (void)promptMessage:(NSString *)message inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD commonPropertyShowInView:view];
    hud.label.text = message;
    [view bringSubviewToFront:hud];
    [hud hideAnimated:YES afterDelay:1.5];
}

+ (void)promptMessageYoffset:(CGFloat)yyOffset withMessage:(NSString *)message inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD commonPropertyShowInView:view];
    hud.label.text = message;
    CGPoint point = hud.offset;
    point.y = yyOffset;
    hud.offset = point;
    [hud hideAnimated:YES afterDelay:1];
}

+ (void)promptDetailMessage:(NSString *)message inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD commonPropertyShowInView:view];
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    [hud hideAnimated:YES afterDelay:1.3];
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = (UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:view animated:YES];
    
}
/// 打卡成功
+ (void)showDakaSuccess:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD commonPropertyShowInView:view];
    hud.mode = MBProgressHUDModeCustomView;
    [view bringSubviewToFront:hud];

    CustomView *backView = [[CustomView alloc] initWithFrame:CGRectMake(0, 0, 174, 174)];
    [backView setCornerRadius:10];
    backView.center = view.center;

    hud.customView = backView;
    
    [hud hideAnimated:YES afterDelay:1];

}

@end


