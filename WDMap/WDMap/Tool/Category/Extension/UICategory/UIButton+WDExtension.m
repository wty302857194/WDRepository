//
//  UIButton+WDExtension.m
//  NetClass
//
//  Created by wbb on 15/12/5.
//  Copyright © 2015年 WD. All rights reserved.
//

#import "UIButton+WDExtension.h"
static const void *associateKey = @"associateKey";

@implementation UIButton (Extension)

- (void)setIsChild:(BOOL)isChild {
    objc_setAssociatedObject(self, &associateKey, @(isChild),OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)isChild {
    NSNumber *numberValue = objc_getAssociatedObject(self, &associateKey);
    return [numberValue boolValue];
    
}
- (void)layoutButtonWithEdgeInsetsStyle:(WDButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space {
  
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = self.titleLabel.intrinsicContentSize.width;
    CGFloat labelHeight = self.titleLabel.intrinsicContentSize.height;
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    switch (style) {
        case WDButtonEdgeInsetsStyleTop:
        {
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
        }
            break;
        case WDButtonEdgeInsetsStyleLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case WDButtonEdgeInsetsStyleBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case WDButtonEdgeInsetsStyleRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

#pragma mark --- 创建默认按钮--有字体、颜色--有图片---有背景
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font imageName:(NSString *)imageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action backImageName:(NSString *)backImageName  {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    // 设置标题
    if (title) [button setTitle:title forState:UIControlStateNormal];
    if (titleColor) [button setTitleColor:titleColor forState:UIControlStateNormal];
    if (font) button.titleLabel.font = font;
    button.adjustsImageWhenHighlighted = NO;
    // 图片
    if (imageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//        NSString *highlighted = [NSString stringWithFormat:@"%@_highlighted", imageName];
//        [button setImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    }
    if (selectImageName) {
        [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
    }
    // 背景图片
    if (backImageName) {
        [button setBackgroundImage:[UIImage imageNamed:backImageName] forState:UIControlStateNormal];
        
//        NSString *backHighlighted = [NSString stringWithFormat:@"%@_highlighted", backImageName];
//        [button setBackgroundImage:[UIImage imageNamed:backHighlighted] forState:UIControlStateHighlighted];
    }
    
    // 监听方法
    if (action != nil) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

#pragma mark  --- 有文字,有颜色，有字体，有图片，没有背景图片
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font imageName:(NSString *)imageName target:(id)target action:(SEL)action {
    return [self buttonWithTitle:title titleColor:titleColor font:font imageName:imageName selectImageName:nil target:target action:action backImageName:nil];
}


#pragma mark  --- 有文字,有颜色，有字体，没有图片，没有背景
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action {
    return [self buttonWithTitle:title titleColor:titleColor font:font imageName:nil selectImageName:nil target:target action:action backImageName:nil];
}

#pragma mark  --- 有文字,有颜色,有字体,没图片，有背景
+ (instancetype)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font target:(id)target action:(SEL)action backImageName:(NSString *)backImageName {
    return [self buttonWithTitle:title titleColor:titleColor font:font imageName:nil selectImageName:nil target:target action:action backImageName:backImageName];
}

#pragma mark  --- 有图片，有选中图片，没有背景图片
+ (instancetype)buttonWithImageName:(NSString *)imageName selectImageName:(NSString *)selectImageName target:(id)target action:(SEL)action {
    return [self buttonWithTitle:nil titleColor:nil font:nil imageName:imageName  selectImageName:selectImageName target:target action:action backImageName:nil];
}
#pragma mark  --- 有图片，有选中图片，没有背景图片
+ (instancetype)buttonWithBackgroundImage:(NSString *)imageName target:(id)target action:(SEL)action {
    return [self buttonWithTitle:nil titleColor:nil font:nil imageName:nil  selectImageName:nil target:target action:action backImageName:imageName];
}
@end
