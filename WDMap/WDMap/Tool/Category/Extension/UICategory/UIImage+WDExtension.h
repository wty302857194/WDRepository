//
//  UIImage+WDExtension.h
//  wbb
//
//  Created by wbb on 15/3/11.
//  Copyright (c) 2015年 wbb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/**
 *  返回拉伸图片
 */
+ (UIImage *)resizedImage:(NSString *)name;

/// 通过颜色生成图片
+ (UIImage *)WD_imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 *  带边框的图片
 *
 *  @param name        图片名字
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithName:(NSString *)name borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 *  带边框的图片
 *
 *  @param image        图片
 *  @param borderWidth 边框宽度
 *  @param borderColor 边框颜色
 */
+ (instancetype)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


//view 生成图片
+ (instancetype)makeImageWithView:(UIView *)view withSize:(CGSize)size;


//渐变色image
+ (instancetype)jianBianImage:(UIColor *)starColor endColor:(UIColor *)endColor width:(float)width height:(float)height;

// 圆角图片
- (UIImage *)clipImage:(UIImage *)image;
@end
