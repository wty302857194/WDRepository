//
//  WKHeader.h
//  MyViewController
//
//  Created by 杨飞 on 16/7/18.
//  Copyright © 2016年 WD. All rights reserved.
//

#ifndef WKHeader_h
#define WKHeader_h

#define iPhoneX   (CGSizeEqualToSize(CGSizeMake(375.f, 812.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(812.f, 375.f), [UIScreen mainScreen].bounds.size)  || CGSizeEqualToSize(CGSizeMake(414.f, 896.f), [UIScreen mainScreen].bounds.size) || CGSizeEqualToSize(CGSizeMake(896.f, 414.f), [UIScreen mainScreen].bounds.size))

#define kSafeAreaMaiginTop         (iPhoneX ? 44: 0)
#define kSafeAreaMaiginBottom      (iPhoneX ? 34 : 0)
#define kStatusBarHeight           (iPhoneX ? 44 : 20)    // 状态栏高度
#define kNavigationBarHeight       44     // NavBar高度
#define kTabBarHeight              (iPhoneX ? 83 : 49)

// 状态栏＋导航栏高度(兼容iPhoneX)
#define kLayoutViewMarginTop  ((kStatusBarHeight) + (kNavigationBarHeight))
#define kTableBarHeight            (iPhoneX ? 83 : 49)  // 底部tablebar的高度

//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
//判断iPhone4系列
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_12_Pro ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1284, 2778), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
#define IS_IPHONE_X_orMore (IS_IPHONE_X==YES || IS_IPHONE_Xr== YES || IS_IPHONE_Xs== YES || IS_IPHONE_Xs_Max== YES)



// 颜色 统一用16进制
#define hexColor(colorV)        [UIColor colorWithHexColorString:@#colorV]
#define hexColorAlpha(colorV,a) [UIColor colorWithHexColorString:@#colorV alpha:a];

#define main_color              hexColor(32FAE6)//app主题颜色
#define main_text_color         hexColor(000000)//字体主题颜色
#define main_light_text_color   hexColor(898989)//字体主题灰色
#define main_line_color         hexColor(fafafa)//分割线颜色
#define main_background_color   hexColor(efefef)//背景色
#define main_class_color        hexColor(2d3138)//课堂主题颜色
#define main_btn_color        hexColor(ede625)//课堂主题颜色

// 一些系统单例的简写
#define USER_DEFAULTS       [NSUserDefaults standardUserDefaults]

//获取通知中心
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kDelegate  ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define kWindow  [UIApplication sharedApplication].keyWindow

//3.设置随机颜色
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]
//4.设置RGB颜色/设置RGBA颜色
#define kRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
// clear背景颜色
#define kClearColor [UIColor clearColor]

//7.设置 view 圆角和边框

#define kViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

//11.获取view的frame/图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]


#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREENH_HEIGHT [UIScreen mainScreen].bounds.size.height
#define kSCREEN_SIZE [UIScreen mainScreen].bounds.size

#define  VoiceBox_item_width  ((kSCREEN_WIDTH - 40 -28)/3.f)

#define k_IS_LANDSCAPE        UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])

// 屏幕宽度，跟横竖屏无关
#define k_DEVICE_WIDTH     (k_IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.height : [[UIScreen mainScreen] bounds].size.width)
// 屏幕高度，跟横竖屏无关
#define k_DEVICE_HEIGHT    (k_IS_LANDSCAPE ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)

#ifdef DEBUG
#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)
#endif

#define kWeakSelf(type)  __weak typeof(type) weak##type = type

#define kWEAK_SELF   __weak typeof(self) weakSelf = self

#define kSTRONG_SELF   __strong typeof(weakSelf) strongSelf = weakSelf

#define PLACE_HOLDER_IMAGE  [UIImage imageNamed:@""]

#endif /* WKHeader_h */
