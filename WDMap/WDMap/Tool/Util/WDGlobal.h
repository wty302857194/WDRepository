//
//  WDGlobal.h
//  Class
//
//  Created by wbb on 2020/3/4.
//  Copyright © 2020 WD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSInteger, WDRectCornerType) {
    WDTopState,
    WDLeftState,
    WDBottomState,
    WDRightState,
    WDTopLeftState,
    WDTopRightState,
    WDBottomLeftState,
    WDBottomRightState,
    WDAllState,
};
@class WDScenicModel;
@interface WDGlobal : NSObject

@property (nonatomic, strong) NSMutableArray * rightBarBtnArr;
@property (nonatomic, assign) BOOL isVoiceBox;
@property (nonatomic, strong) WDScenicModel * __nullable scenicModel;

/// 单利类
+(instancetype)shareInstance;
/// 初始化数据
- (void)initData;

/// 是否使用Wi-Fi
+ (BOOL)isSelectWiFi;
/// 是否是第一次进来
+ (BOOL)isFirstComed;
// 用户userID
+ (NSString *)userID;
// 登录成功
+ (BOOL)isLogin;
// 用户名字
+ (NSString *)userName;

// 获取当前controller
+ (UIViewController *)getCurrentViewController;
// 提示弹框
+ (void)showAlertView:(NSString *)msg;
// 弹框
+ (void)ty_alertController:(NSString *)title message:(nullable NSString *)message currentContorller:(UIViewController *)controller cancelButtonTitle:(nullable NSString *)cancelButtonTitle sureButtonTitle:(nullable NSString *)sureButtonTitle cancelHandler:(void (^)(void))cancelHandler sureHandler:(void (^)(void))sureHandler;
// 字典转json
+ (NSString *)ty_jsonStringforDic:(NSDictionary *)dic;
// 修改根视图 到tabbar
+ (void)changeRootVCToTabbarVC;
// 修改根视图 到LoginVC
//+ (void)changeRootVCToLoginVC;

// 根据文字大小和控件宽度计算控件高度
+ (CGFloat)heightForText:(NSString *)text textFont:(CGFloat)fontSize standardWidth:(CGFloat)controlWidth;

// 根据文字大小和控件高度计算控件宽度
+ (CGFloat)widthForText:(NSString *)text textFont:(CGFloat)fontSize  standardHeight:(CGFloat)controlHeight;
+ (CGSize)sizeForText:(NSString *)text textFont:(CGFloat)fontSize standardWidth:(CGFloat)controlWidth;

/// 正则手机号
+ (BOOL)isValidateMobile:(NSString *)mobile;

+ (void)addShadow:(UIView *)view;
+ (void)addShadow:(UIView *)view cornerRadius:(NSInteger)count;

+ (void)addCorners:(UIView *)view;
+ (void)addCorners:(UIView *)view emunType:(WDRectCornerType)type cornerNum:(NSInteger)corner;

+ (NSMutableAttributedString *)getHtmlStringWithString:(NSString *)string;

/// 显示播放器
+ (void)showMusicPlayView;
/// 隐藏播放器
+ (void)hiddenMusicPlayView;
/// 移除播放器
+ (void)removeMusicPlayView;

/// 精度问题
+ (CGFloat)jingdu:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
