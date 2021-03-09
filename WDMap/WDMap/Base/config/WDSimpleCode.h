//
//  WDSimpleCode.h
//  Class
//
//  Created by lnd on 2020/3/4.
//  Copyright © 2020 WD. All rights reserved.
//

#ifndef WDSimpleCode_h
#define WDSimpleCode_h

//MARK: 圆角
/// 设置View圆角
#define kAppViewCorner(view,radius)   {view.layer.cornerRadius = radius; view.layer.masksToBounds = YES;}

/// 设置View边框
#define kAppViewBorder(view, width, color) {view.layer.borderWidth = width; view.layer.borderColor = color.CGColor;}

/// 设置view阴影
#define kAppViewShadow(view, shadowRadiusNum) {view.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor; view.layer.shadowOffset = CGSizeMake(0, 5); view.layer.shadowOpacity = 1; view.layer.shadowRadius = shadowRadiusNum;}

//MARK: 字符串拼接
/// 字符串拼接
#define kAppStringFormat(FORMAT,...) \
[NSString stringWithFormat:FORMAT,##__VA_ARGS__]

// 操作系统版本号
#define kApp_iOS_Version               ([[[UIDevice currentDevice] systemVersion] floatValue])

#define kAppShowRect(rect)             NSLog(@" rect.x = %f\n rect.y = %f\n rect.w = %f\n rect.h = %f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
#define kAppShowSize(size)             NSLog(@" size.w = %f\n size.h = %f", size.width, size.height)
#define kAppShowPoint(point)           NSLog(@" point.x = %f\n point.y = %f", point.x, point.y)

#endif /* WDSimpleCode_h */
