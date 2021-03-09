//
//  UIColor+WDExtend.h
//  NetClass
//
//  Created by WD on 14/11/19.
//  Copyright (c) 2014年 WD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extend)

/**
 *  十六进制颜色
 */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString;

/**
 *  十六进制颜色:含alpha
 */
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha;

+ (UIColor *)WD_colorWithHexString:(NSString *)hexString;

+ (UIColor *)WD_toColor:(unsigned long)color;

/// 颜色转16进制
+ (NSString *)hexadecimalFromUIColor:(UIColor*)color;
@end
