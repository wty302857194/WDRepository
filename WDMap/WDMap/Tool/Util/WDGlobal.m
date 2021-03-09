//
//  WDGlobal.m
//  Class
//
//  Created by wbb on 2020/3/4.
//  Copyright © 2020 WD. All rights reserved.
//

#import "WDGlobal.h"
#import "WDBaseTabBarController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WDMusicPlayView.h"

@implementation WDGlobal
+(instancetype)shareInstance {
    static WDGlobal *_shareGlobal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareGlobal = [[WDGlobal alloc] init];
    });
    return _shareGlobal;
}
- (void)initData {
    self.rightBarBtnArr = [NSMutableArray arrayWithCapacity:0];
}
/// 是否是第一次进来
+ (BOOL)isFirstComed {
    BOOL role = [[WDUtil getInfoForKey:WD_IDSFIRSTCOMED] boolValue];
    return role;
}
+ (NSString *)userName {
    NSString *name = [WDUtil getInfoForKey:WD_USERNAME];
    if (name && name.length > 0) {
        return name;
    }
    return @"";
}
+ (NSString *)userID {
    NSString *userID = [WDUtil getInfoForKey:WD_USERID];
    if (userID) {
        userID = [NSString stringWithFormat:@"%@", [WDUtil getInfoForKey:WD_USERID]];
        if (userID.length > 0) {
            return userID;
        }
    }
    return @"";
}
+ (BOOL)isLogin {
    if ([WDGlobal userID].length>0) {
        return YES;
    }
    return NO;
}



+ (UIViewController *)getCurrentViewController {
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    //获取根控制器
    UIViewController* currentViewController = window.rootViewController;
    //获取当前页面控制器
    BOOL runLoopFind = YES;
    while (runLoopFind){
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]){
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        } else {
            NSUInteger childViewControllerCount = currentViewController.childViewControllers.count;
            if (childViewControllerCount > 0) {
                currentViewController = currentViewController.childViewControllers.lastObject;
                return currentViewController;
            } else {
                return currentViewController;
            }
        }
    }
    return currentViewController;
}

+ (void)showAlertView:(NSString *)msg {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:okAction];
    [[WDGlobal getCurrentViewController] presentViewController:alertController animated:YES completion:nil];
}



+ (void)ty_alertController:(NSString *)title message:(nullable NSString *)message currentContorller:(UIViewController *)controller cancelButtonTitle:(nullable NSString *)cancelButtonTitle sureButtonTitle:(nullable NSString *)sureButtonTitle cancelHandler:(void (^)(void))cancelHandler sureHandler:(void (^)(void))sureHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    if (sureButtonTitle) {
        [alert addAction:[UIAlertAction actionWithTitle:sureButtonTitle
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
            sureHandler();
        }]];
    }
    
    if (cancelButtonTitle) {
         [alert addAction:[UIAlertAction actionWithTitle:cancelButtonTitle
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action) {
               cancelHandler();
           }]];
    }
   
//    UIView *subView1 = alert.view.subviews[0];
//    UIView *subView2 = subView1.subviews[0];
//    UIView *subView3 = subView2.subviews[0];
//    UIView *subView4 = subView3.subviews[0];
//    UIView *subView5 = subView4.subviews[0];
//    //取title和message：
//    UILabel *message1 = subView5.subviews[1];
//    message1.textAlignment = NSTextAlignmentLeft;

    [controller presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)ty_jsonStringforDic:(NSDictionary *)dic {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (void)changeRootVCToTabbarVC {
    WDBaseTabBarController *tabBar = [[WDBaseTabBarController alloc] init];
    CATransition *transtition = [CATransition animation];
    transtition.duration = 0.5;
    transtition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transtition forKey:@"animation"];
}
//+ (void)changeRootVCToLoginVC {
//    WDLoginVC *tabBar = [[WDLoginVC alloc] init];
//    CATransition *transtition = [CATransition animation];
//    transtition.duration = 0.5;
//    transtition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    [UIApplication sharedApplication].keyWindow.rootViewController = tabBar;
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transtition forKey:@"animation"];
//}
// 根据文字大小和控件宽度计算控件高度
+ (CGFloat)heightForText:(NSString *)text textFont:(CGFloat)fontSize standardWidth:(CGFloat)controlWidth
{
    return [self sizeForText:text textFont:fontSize standardWidth:controlWidth].height;
}

+ (CGFloat)widthForText:(NSString *)text textFont:(CGFloat)fontSize  standardHeight:(CGFloat)controlHeight
{
    if ([text length]==0) {
        return 0;
    }else {
        NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
        return  [text boundingRectWithSize:CGSizeMake(1000,controlHeight) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.width;
    }
}
+ (CGSize)sizeForText:(NSString *)text textFont:(CGFloat)fontSize standardWidth:(CGFloat)controlWidth
{
    if ([text length]==0) {
        return CGSizeMake(0, 0);
    }else {
        NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
        return  [text boundingRectWithSize:CGSizeMake(controlWidth, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size;
    }
}

+ (BOOL)isValidateMobile:(NSString *)mobile {
    NSString *phoneRegex = @"1[3456789]([0-9]){9}";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
+ (void)addShadow:(UIView *)view {
    [WDGlobal addShadow:view cornerRadius:10];
}
+ (void)addShadow:(UIView *)view cornerRadius:(NSInteger)count {
    view.layer.cornerRadius = count;
    UIColor *color = hexColorAlpha(898989, 1);
    view.layer.shadowColor = color.CGColor;
    view.layer.shadowOffset = CGSizeMake(3, 3);
    view.layer.shadowOpacity = 0.6;
}

+ (void)addCorners:(UIView *)view {
    [WDGlobal addCorners:view emunType:WDTopState cornerNum:30];
}

+ (void)addCorners:(UIView *)view emunType:(WDRectCornerType)type cornerNum:(NSInteger)corner{
    UIRectCorner rectCorner = UIRectCornerTopRight;
    
    switch (type) {
        case WDTopState:
            rectCorner = UIRectCornerTopRight | UIRectCornerTopLeft;
            break;
        case WDLeftState:
            rectCorner = UIRectCornerBottomLeft | UIRectCornerTopLeft;
            break;
        case WDBottomState:
            rectCorner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        case WDRightState:
            rectCorner = UIRectCornerTopRight | UIRectCornerBottomRight;
            break;
        case WDTopLeftState:
            rectCorner = UIRectCornerTopLeft;
            break;
        case WDTopRightState:
            rectCorner = UIRectCornerTopRight;
            break;
        case WDBottomLeftState:
            rectCorner = UIRectCornerBottomLeft;
            break;
        case WDBottomRightState:
            rectCorner = UIRectCornerBottomRight;
            break;
        case WDAllState:
            rectCorner = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
            break;
        default:
            break;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(corner, corner)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor whiteColor].CGColor;
    layer.path = path.CGPath;
    view.layer.mask = layer;
}

+ (NSMutableAttributedString *)getHtmlStringWithString:(NSString *)string {
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
    // 设置段落格式
//    NSMutableParagraphStyle *para = [[NSMutableParagraphStyle alloc] init];
//    para.lineSpacing = 8;
//    //    para.paragraphSpacing = 10;
//    [attStr addAttribute:NSParagraphStyleAttributeName value:para range:NSMakeRange(0, attStr.length)];
    // 设置文本的Font
//    [attStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, attStr.length)];
    return attStr;
}

+ (void)showMusicPlayView {
    WDMusicPlayView *playView = [WDMusicPlayView musicPlayView];

    if (![kWindow.subviews containsObject:playView]) {
        [kWindow addSubview:playView];
        [kWindow bringSubviewToFront:playView];
        playView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, kSCREENH_HEIGHT);
    }else {
        playView.hidden = NO;
    }
    [UIView animateWithDuration:0.5 animations:^{
        playView.frame = CGRectMake(0, 0, kSCREEN_WIDTH, kSCREENH_HEIGHT);

    }];
}
+ (void)hiddenMusicPlayView {
    WDMusicPlayView *playView = [WDMusicPlayView musicPlayView];
    [UIView animateWithDuration:0.5 animations:^{
        playView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, kSCREENH_HEIGHT);

    } completion:^(BOOL finished) {
        playView.hidden = YES;
    }];
}

+ (void)removeMusicPlayView {
    __block WDMusicPlayView *playView = [WDMusicPlayView musicPlayView];
    [UIView animateWithDuration:0.5 animations:^{
        playView.frame = CGRectMake(0, kSCREENH_HEIGHT, kSCREEN_WIDTH, kSCREENH_HEIGHT);

    } completion:^(BOOL finished) {
        playView.hidden = YES;
        [playView removeFromSuperview];
        [playView clear];
    }];
}
@end
