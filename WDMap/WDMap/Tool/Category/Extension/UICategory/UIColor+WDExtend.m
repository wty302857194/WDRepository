//
//  UIColor+WDExtend.m
//  NetClass
//
//  Created by WD on 14/11/19.
//  Copyright (c) 2014年 WD. All rights reserved.
//

#import "UIColor+WDExtend.h"

@implementation UIColor (Extend)

#pragma mark  十六进制颜色
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString
{
    return [self colorWithHexColorString:hexColorString alpha:1.0f];
}

#pragma mark  十六进制颜色
+ (UIColor *)colorWithHexColorString:(NSString *)hexColorString alpha:(float)alpha
{
    unsigned int red, green, blue;
    
    NSRange range;
    range.length =2;
    range.location =0;
    
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&red];
    
    range.location =2;
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&green];
    
    range.location =4;
    [[NSScanner scannerWithString:[hexColorString substringWithRange:range]]scanHexInt:&blue];
    
    UIColor *color = [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:alpha];
    
    return color;
}

// 使用HEX命名方式的颜色字符串生成一个UIColor对象
+ (UIColor *)WD_colorWithHexString:(NSString *)hexString {
    // 去掉# 字符串中的小写字母转成大写字母
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    colorString = [colorString stringByReplacingOccurrencesOfString:@"0X" withString:@""];
    
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start:0 length:1];
            green = [self colorComponentFrom: colorString start:1 length:1];
            blue  = [self colorComponentFrom: colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start:0 length:1];
            red   = [self colorComponentFrom: colorString start:1 length:1];
            green = [self colorComponentFrom: colorString start:2 length:1];
            blue  = [self colorComponentFrom: colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start:0 length:2];
            green = [self colorComponentFrom: colorString start:2 length:2];
            blue  = [self colorComponentFrom: colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start:0 length:2];
            red   = [self colorComponentFrom: colorString start:2 length:2];
            green = [self colorComponentFrom: colorString start:4 length:2];
            blue  = [self colorComponentFrom: colorString start:6 length:2];
            break;
        default:
            // 让项目崩溃并打印崩溃原因
            [NSException raise:@"Invalid color value" format:@"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string
                        start:(NSUInteger)start
                       length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

+ (UIColor *)WD_toColor:(unsigned long)color {
    
    int r = color % 256;
    int g = (color / 256) % 256;
    unsigned long b = (color / 256) / 256;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}
/// 颜色转16进制
+ (NSString *)hexadecimalFromUIColor:(UIColor*)color {
    
    if(CGColorGetNumberOfComponents(color.CGColor) < 4) {
        
        const CGFloat *components =CGColorGetComponents(color.CGColor);
        
        color = [UIColor colorWithRed:components[0]
                 
                               green:components[0]
                 
                                blue:components[0]
                 
                               alpha:components[1]];
        
    }
    
    if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) !=kCGColorSpaceModelRGB) {
        
        return [NSString stringWithFormat:@"#FFFFFF"];
        
    }
    
    NSString *r,*g,*b;
    
    (int)((CGColorGetComponents(color.CGColor))[0]*255.0) == 0?(r =[NSString stringWithFormat:@"0%x",(int)((CGColorGetComponents(color.CGColor))[0]*255.0)]):(r= [NSString stringWithFormat:@"%x",(int)((CGColorGetComponents(color.CGColor))[0]*255.0)]);
    
    (int)((CGColorGetComponents(color.CGColor))[1]*255.0)== 0?(g = [NSString stringWithFormat:@"0%x",(int)((CGColorGetComponents(color.CGColor))[1]*255.0)]):(g= [NSString stringWithFormat:@"%x",(int)((CGColorGetComponents(color.CGColor))[1]*255.0)]);
    
    (int)((CGColorGetComponents(color.CGColor))[2]*255.0)== 0?(b = [NSString stringWithFormat:@"0%x",(int)((CGColorGetComponents(color.CGColor))[2]*255.0)]):(b= [NSString stringWithFormat:@"%x",(int)((CGColorGetComponents(color.CGColor))[2]*255.0)]);
    
    return [NSString stringWithFormat:@"%@%@%@",r,g,b];
    
}

@end



