//
//  NSString+WDExtension.m
//  NetClass
//
//  Created by lnd on 2020/4/16.
//  Copyright © 2020 WD. All rights reserved.
//

#import "NSString+WDExtension.h"

@implementation NSString (WDExtension)

/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL) isValidateMobile {
    //手机号以13, 15, 17, 18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:self];
}

+ (BOOL)validatePassword:(NSString *)password {
    NSString *passwordRegex = @"^[a-zA-Z0-9-*/+.~!@#$%^&*()]{6,16}+$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordPredicate evaluateWithObject:password];
}

- (BOOL)validateContainsSpace {
    return [self rangeOfString:@" "].location == NSNotFound;
}

- (NSString *)ageFromBirthday {
    if (self.length != 10 ||
        [self characterAtIndex:4] != '.' ||
        [self characterAtIndex:7] != '.') {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd"];
    NSString *today = [formatter stringFromDate:[NSDate date]];
    
    NSString *selfYear = [self substringToIndex:4];
    NSString *nowYear = [today substringToIndex:4];
    NSInteger age = nowYear.integerValue - selfYear.integerValue;
    
    NSString *selfDate = [self substringFromIndex:5];
    NSString *nowDate = [today substringFromIndex:5];
    if ([nowDate compare:selfDate] < 0) {
        age = age - 1;
    }
    
    if (age < 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%zd", age];
}

- (NSString *)ageFromIDCard {
    NSString *birthday = [self birthdayFromIDCard];
    
    return [birthday ageFromBirthday];
}

- (NSString*)birthdayFromIDCard {
    NSString *result = @"未知";
    if (self.length == 15) {
        NSMutableString *birthString = [[self substringWithRange:NSMakeRange(6, 6)] mutableCopy];
        [birthString insertString:@"19" atIndex:0];
        [birthString insertString:@"." atIndex:4];
        [birthString insertString:@"." atIndex:7];
        result = birthString;
    } else if (self.length == 18) {
        NSMutableString *birthString = [[self substringWithRange:NSMakeRange(6, 8)] mutableCopy];
        [birthString insertString:@"." atIndex:4];
        [birthString insertString:@"." atIndex:7];
        result = birthString;
    }
    
    return result;
}

- (NSString*)sexFromIDCard {
    NSString *sexString = @"";
    
    if (self.length == 15) {
        sexString =  [[self substringWithRange:NSMakeRange(14, 1)] mutableCopy];
    } else if (self.length == 18) {
        sexString = [[self substringWithRange:NSMakeRange(16, 1)] mutableCopy];
    }
    
    int x = sexString.intValue;
    if (x < 0 || sexString.length == 0) {
        return @"";
    }
    if (x % 2 == 0) {
        return @"女";
    } else {
        return @"男";
    }
    return sexString;
}

/**
 十六进制转换为十进制
  
 @param binary 十六进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalSystem:(NSString *)binary {
    
    /// RGB转BGR 字符串中的小写字母转成大写字母
    NSString *colorString = [[binary stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    colorString = [colorString stringByReplacingOccurrencesOfString:@"0X" withString:@""];
    
    /// RGB
    NSString *r = @"FF";
    NSString *g = @"FF";
    NSString *b = @"FF";
    
    switch (colorString.length) {
        case 3: {
            r = [colorString substringWithRange:NSMakeRange(0, 1)];
            g = [colorString substringWithRange:NSMakeRange(1, 1)];
            b = [colorString substringWithRange:NSMakeRange(2, 1)];
            break;
        }
        case 6: {
            r = [colorString substringWithRange:NSMakeRange(0, 2)];
            g = [colorString substringWithRange:NSMakeRange(2, 2)];
            b = [colorString substringWithRange:NSMakeRange(4, 2)];
            break;
        }
            
        default:
            break;
    }
    /// BGR
    NSString *hexString = [NSString stringWithFormat:@"%@%@%@", b, g, r];
    
    return strtol(hexString.UTF8String, 0, 16);
}


- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

+ (NSString *)stringWithMoneyAmount:(double)amount {
    BOOL minus = amount < 0;
    if (minus) {
        amount = -amount;
    }
    NSMutableString *toString = [NSMutableString string];
    long round = floor(amount);
    int fraction = floor((amount - round + 0.005) * 100.0);
    NSString *fractionString = [NSString stringWithFormat:@".%02d", fraction];
    
    do {
        int thousand = round % 1000;
        if (round < 1000) {
            [toString insertString:[NSString stringWithFormat:@"%d", thousand] atIndex:0];
        } else {
            [toString insertString:[NSString stringWithFormat:@",%03d", thousand] atIndex:0];
        }
        round = round / 1000;
    } while (round);
    [toString appendString:fractionString];
    if (minus) {
        [toString insertString:@"-" atIndex:0];
    }
    return toString;
}

+ (NSString *)stringIntervalFrom:(NSDate *)start to:(NSDate *)end {
    NSInteger interval = end.timeIntervalSince1970 - start.timeIntervalSince1970;
    if (interval <= 0) {
        return @"刚刚";
    }
    
    if (interval < 60) {
        return [NSString stringWithFormat:@"%zd 秒前", interval];
    }
    
    interval = interval / 60;
    if (interval < 60) {
        return [NSString stringWithFormat:@"%zd 分钟前", interval];
    }
    
    interval = interval / 60;
    if (interval < 24) {
        return [NSString stringWithFormat:@"%zd 小时前", interval];
    }
    
    interval = interval / 24;
    if (interval < 7) {
        return [NSString stringWithFormat:@"%zd 天前", interval];
    }
    
    if (interval < 30) {
        return [NSString stringWithFormat:@"%zd 周前", interval / 7];
    }
    
    if (interval < 365) {
        return [NSString stringWithFormat:@"%zd 个月前", interval / 30];
    }
    return [NSString stringWithFormat:@"%zd 年前", interval / 365];
}
//邮箱
+ (BOOL)validateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL)isEmptyString {
    return self.length == 0 || [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

// 手机号字符串（11122223333）格式化位111 2222 3333
+ (NSString *)stringTo334FormaterWithSourceStr:(NSString *)sourceStr
{
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    if ([sourceStr rangeOfCharacterFromSet:[characterSet invertedSet]].location == NSNotFound){
        // 正常
        if ([sourceStr length] == 11)
        {
            NSMutableString *temString = [NSMutableString stringWithString:sourceStr];
            [temString insertString:@" " atIndex:0]; // 首位插入一个字符成12位
            sourceStr = temString;
            
            NSString *newString = @"";
            while (sourceStr.length > 0)
            {
                NSString *subString = [sourceStr substringToIndex:MIN(sourceStr.length, 4)];
                newString = [newString stringByAppendingString:subString];
                if (subString.length == 4) {
                    newString = [newString stringByAppendingString:@" "];
                }
                sourceStr = [sourceStr substringFromIndex:MIN(sourceStr.length, 4)];
            }

            newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
            return newString;

        } else {
            return @"手机号码少于11位";
        }
    } else {
        return @"手机号码含有非数字字符";
    }
}

//判断是否含有表情符号 yes-有 no-没有
+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        if (0xd800) {
            if (0xd800 <= hs && hs <= 0xdbff) {
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                    if (0x1d000 <= uc && uc <= 0x1f77f) {
                        returnValue =YES;
                    }
                }
            }else if (0x2100 <= hs && hs <= 0x27ff){
                returnValue =YES;
            }else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue =YES;
            }else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue =YES;
            }else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue =YES;
            }else{
                if (substring.length > 1) {
                    const unichar ls = [substring characterAtIndex:1];
                    if (ls == 0x20e3) {
                        returnValue =YES;
                    }
                }
            }
            if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0xd83e) {
                returnValue =YES;
            }
            
        }
    }];
    return returnValue;
}
//是否是系统自带九宫格输入 yes-是 no-不是
+ (BOOL)isNineKeyBoard:(NSString *)string {
    NSString *other = @"➋➌➍➎➏➐➑➒";
    int len = (int)string.length;
    for(int i=0;i<len;i++){
        if(!([other rangeOfString:string].location != NSNotFound))
            return NO;
    }
    return YES;
}
//判断第三方键盘中的表情
+ (BOOL)hasEmoji:(NSString*)string {
    NSString *pattern = @"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

- (NSString *)WD_noEmoji {
    //去除表情规则
    //  \u0020-\\u007E  标点符号，大小写字母，数字
    //  \u00A0-\\u00BE  特殊标点  (¡¢£¤¥¦§¨©ª«¬­®¯°±²³´µ¶·¸¹º»¼½¾)
    //  \u2E80-\\uA4CF  繁简中文,日文，韩文 彝族文字
    //  \uF900-\\uFAFF  部分汉字
    //  \uFE30-\\uFE4F  特殊标点(︴︵︶︷︸︹)
    //  \uFF00-\\uFFEF  日文  (ｵｶｷｸｹｺｻ)
    //  \u2000-\\u201f  特殊字符(‐‑‒–—―‖‗‘’‚‛“”„‟)
    // 注：对照表 http://blog.csdn.net/hherima/article/details/9045765
    
    NSRegularExpression* expression = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    
    NSString* result = [expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, self.length) withTemplate:@""];
    
    return result;
}

+ (NSString *)dataToJsonString:(id)data {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

+ (NSMutableAttributedString *)WD_setAttributedStringWithStr:(NSString *)textStr
                                                   textColor:(UIColor *)color
                                                    textFont:(UIFont *)font
                                                   textRange:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    [attributedString addAttribute:NSFontAttributeName value:font range:range];
    return attributedString;
}

+ (CGFloat)WD_autoHeightWithString:(NSString *)string
                             Width:(CGFloat)width
                              Font:(UIFont *)font {
    
    NSDictionary *dictA = @{
                            NSFontAttributeName : font,
                            };
    CGSize boundRectSize = CGSizeMake(width, MAXFLOAT);
    CGFloat newFloat = [string boundingRectWithSize:boundRectSize
                                            options: NSStringDrawingUsesLineFragmentOrigin
                        | NSStringDrawingUsesFontLeading
                                         attributes:dictA context:nil].size.height;
    
    return ceil(newFloat);
}

+ (NSString *)WD_convertFileSize:(long long)size {
    long kb = 1024;
    long mb = kb * 1024;
    long gb = mb * 1024;
    
    if (size >= gb) {
        return [NSString stringWithFormat:@"%.1fG", (float) size / gb];
    } else if (size >= mb) {
        float f = (float) size / mb;
        if (f > 100) {
            return [NSString stringWithFormat:@"%.0fM", f];
        }else{
            return [NSString stringWithFormat:@"%.1fM", f];
        }
    } else if (size >= kb) {
        float f = (float) size / kb;
        if (f > 100) {
            return [NSString stringWithFormat:@"%.0fK", f];
        } else {
            return [NSString stringWithFormat:@"%.1fK", f];
        }
    } else {
        return [NSString stringWithFormat:@"%lldB", size];
    }
}
#pragma mark - 播放时间的处理
+(NSString *)stringWithTime:(NSTimeInterval)time
{
    NSInteger min = time / 60;
    NSInteger sec = (int)round(time) % 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",min,sec];
}
@end
