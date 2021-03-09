//
//  NSString+WDExtension.h
//  NetClass
//
//  Created by lnd on 2020/4/16.
//  Copyright © 2020 WD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WDExtension)

/**
 *手机号码验证 MODIFIED BY HELENSONG
 */
- (BOOL) isValidateMobile;

/// 密码判断
/// @param password 密码
+ (BOOL)validatePassword:(NSString *)password;
/**
 * 判断字段是否包含空格
 */
- (BOOL)validateContainsSpace;

/**
 *  根据生日返回年龄
 */
- (NSString *)ageFromBirthday;

/**
 *  根据身份证返回岁数
 */
- (NSString *)ageFromIDCard;

/**
 *  根据身份证返回生日
 */
- (NSString*)birthdayFromIDCard;

/**
 *  根据身份证返回性别
 */
- (NSString*)sexFromIDCard;

/**
十六进制转换为十进制
 
@param binary 十六进制数
@return 十进制数
*/
+ (NSInteger)getDecimalSystem:(NSString *)binary;

/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

+ (NSString *)stringWithMoneyAmount:(double)amount;

+ (NSString *)stringIntervalFrom:(NSDate *)start to:(NSDate *)end;

//邮箱
+ (BOOL)validateEmail:(NSString *)email;

- (BOOL)isEmptyString;

// 手机号字符串（11122223333）格式化位111 2222 3333
+ (NSString *)stringTo334FormaterWithSourceStr:(NSString *)sourceStr;


+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (BOOL)isNineKeyBoard:(NSString *)string;
+ (BOOL)hasEmoji:(NSString*)string;
/// 过滤表情包等
- (NSString *)WD_noEmoji;

/// 字典或者数组转json
/// @param data 字典或者数组
+ (NSString *)dataToJsonString:(id)data;

/**
 更改某一范围内的字体和颜色
 
 @param textStr 文本
 @param color 颜色
 @param font 字体
 @param range 范围
 @return 改好的字符串
 */
+ (NSMutableAttributedString *)WD_setAttributedStringWithStr:(NSString *)textStr
                                                   textColor:(UIColor *)color
                                                    textFont:(UIFont *)font
                                                   textRange:(NSRange)range;

/**
 固定文本宽度计算文本的高度
 
 @param string 文本
 @param width 宽度
 @param font 字体
 @return 高度
 */
+ (CGFloat)WD_autoHeightWithString:(NSString *)string
                             Width:(CGFloat)width
                              Font:(UIFont *)font;

/// 文件大小转换
/// @param size 大小
+ (NSString *)WD_convertFileSize:(long long)size;


#pragma mark - 播放时间的处理
+(NSString *)stringWithTime:(NSTimeInterval)time;

@end

NS_ASSUME_NONNULL_END
