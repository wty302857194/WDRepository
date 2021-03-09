//
//  UIButton+WDExtension.h
//  NetClass
//
//  Created by wbb on 15/12/5.
//  Copyright © 2015年 WD. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, WDButtonEdgeInsetsStyle) {
    WDButtonEdgeInsetsStyleTop, // image在上，label在下
    WDButtonEdgeInsetsStyleLeft, // image在左，label在右
    WDButtonEdgeInsetsStyleBottom, // image在下，label在上
    WDButtonEdgeInsetsStyleRight, // image在右，label在左
};

@interface UIButton (Extension)

@property (nonatomic, assign) BOOL isChild;



#pragma mark -- Title和Image同时展示布局
/**
 * 设置button的titleLabel和imageView的布局样式，及间距
 *
 * @param style titleLabel和imageView的布局样式
 * @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(WDButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;

/**
 *  创建按钮有文字,有颜色,有字体,有图片,有选中图片,有背景
 *
 *  @param title         标题
 *  @param titleColor         字体颜色
 *  @param font      字号
 *  @param imageName     图像
 *  @param backImageName 背景图像
 *
 *  @return UIButton
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action backImageName:(NSString *)backImageName;

/**
 *  创建按钮有文字,有颜色,有字体,有图片,没有有背景
 *
 *  @param title         标题
 *  @param titleColor         字体颜色
 *  @param font      字号
 *  @param imageName     图像
 *
 *  @return UIButton
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font imageName:(NSString *)imageName target:(id)target action:(SEL)action;




/**
 *  创建按钮有文字,有颜色，有字体，没有图片，没有背景
 *
 *  @param title         标题
 *  @param titleColor    标题颜色
 *  @param font      字号
 *
 *  @return UIButton
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action;

/**
 *  创建按钮有文字,有颜色，有字体，没有图片，有背景
 *
 *  @param title         标题
 *  @param titleColor    标题颜色
 *  @param backImageName 背景图像名称
 *
 *  @return UIButton
 */
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action backImageName:(NSString *)backImageName;


#pragma mark  --- 有图片，有选中图片，没有背景图片
+ (instancetype)buttonWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action;

#pragma mark  --- 有背景图片
+ (instancetype)buttonWithBackgroundImage:(NSString *)imageName target:(id)target action:(SEL)action;



@end
