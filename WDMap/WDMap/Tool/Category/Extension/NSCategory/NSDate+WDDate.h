//
//  NSDate+WDDate.h
//  NetClass
//
//  Created by lnd on 2020/3/6.
//  Copyright © 2020 WD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const WD_yyyyMMdd_fmt = @"yyyy-MM-dd";
static NSString *const WD_yyyyMMdd_CNfmt = @"yyyy年MM月dd日";
static NSString *const WD_yyyyMMdd_dotfmt = @"yyyy.MM.dd";

static NSString *const WD_MMdd_fmt = @"MM-dd";
static NSString *const WD_MMdd_CNfmt = @"MM月dd日";
static NSString *const WD_MMdd_dotfmt = @"MM.dd";
static NSString *const WD_MMdd_spritfmt = @"MM/dd";

static NSString *const WD_HHmmss_fmt = @"HH:mm:ss";
static NSString *const WD_HHmm_fmt = @"HH:mm";
static NSString *const WD_mmss_fmt = @"mm:ss";

static NSString *const WD_yyyyMMddHHmmss_fmt = @"yyyy-MM-dd HH:mm:ss";

@interface NSDate (WDDate)

/// 初始化formatter
+ (NSDateFormatter *)WD_initDateFormatter;

/**
 * 获取当前时间戳
 */
+ (NSString *)WD_currentTimestamp;

/**
 * 获取当前时间 double接收
 */
+ (NSTimeInterval)WD_currentTimeInterval;

/**
 * 获取当前时间字符串
 * @param formatter  时间模板 (例:yyyy-MM-dd)
 *
 * @return 转化好的时间字符串
 */
+ (NSString *)WD_currentTimeWithDateFormatter:(NSString *)formatter;

/**
 * 把时间戳转化为时间
 * @param timestamp  时间戳   (例:1234567890)
 * @param formatter  时间模板 (例:yyyy-MM-dd)
 *
 * @return 转化好的时间字符串
 */
+ (NSString *)WD_timestampTranslateTime:(NSString *)timestamp dateFormatter:(NSString *)formatter;

/**
 * 把时间转化为时间戳
 * @param time       时间    (例:2018-03-29)
 * @param formatter  时间模板 (例:yyyy-MM-dd)
 *
 * @return 转化好的时间戳字符串
 */
+ (NSString *)WD_timeTranslateTimestamp:(NSString *)time dateFormatter:(NSString *)formatter;

/**
 * NSDate转成时间戳
 * @param date  日期
 *
 * @return 转化好的时间戳字符串
 */
+ (NSString *)WD_dateTranslatetimestamp:(NSDate *)date;

/**
 * 时间戳转成NSDate
 * @param timestamp  时间戳  (例:1234567890)
 *
 * @return NSDate
 */
+ (NSDate *)WD_timestampTranslateDate:(NSString *)timestamp;

/**
 * NSDate转成时间字符串
 * @param date       日期
 * @param formatter  时间模板 (例:yyyy-MM-dd)
 *
 * @return 转化好的时间戳字符串
 */
+ (NSString *)WD_dateTranslateTimeString:(NSDate *)date dateFormatter:(NSString *)formatter;

/**
 * 时间字符串转成NSDate
 * @param timeString  时间  (例:2018-03-29)
 * @param formatter  时间模板 (例:yyyy-MM-dd)
 *
 * @return NSDate
 */
+ (NSDate *)WD_timeStringTranslateDate:(NSString *)timeString dateFormatter:(NSString *)formatter;

#pragma mark -- 日历相关
#pragma mark - 以下实例方法用date调用,会常用时间戳转成NSDate配合

/**
 * 判断是否是润年
 * @return YES表示润年，NO表示平年
 */
- (BOOL)WD_isLeapYear;
+ (BOOL)WD_isLeapYear:(NSDate *)date;
/**
 * 判断某个时间是否为今天
 */
- (BOOL)WD_isToday;
/**
 * 日期组件
 * 获取当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 *
 * @return 当天的包括“年”，“月”，“日”，“周”，“时”，“分”，“秒”的NSDateComponents
 **/
- (NSDateComponents *)WD_compontents;

/**
 * 获得NSDate对应的年份
 *
 * @return  NSDate对应的年份
 **/
- (NSUInteger)WD_year;

/**
 * 获得NSDate对应的月份
 *
 * @return  NSDate对应的月份
 */
- (NSUInteger)WD_month;

/**
 * 获得NSDate对应的日期
 *
 * @return  NSDate对应的日期
 */
- (NSUInteger)WD_day;

/**
 * 获得NSDate对应的小时数
 *
 * @return  NSDate对应的小时数
 */
- (NSUInteger)WD_hour;

/**
 * 获得NSDate对应的分钟数
 *
 * @return  NSDate对应的分钟数
 */
- (NSUInteger)WD_minute;

/**
 * 获得NSDate对应的秒数
 *
 * @return  NSDate对应的秒数
 */
- (NSUInteger)WD_second;

/**
 * 获得NSDate对应的星期 (周日->1...周六->7)
 *
 * @return  NSDate对应的星期
 */
- (NSUInteger)WD_weekday;

/**
 * 获得NSDate对应的星期 (星期几)
 *
 * @return  NSDate对应的星期
 */
- (NSString *)WD_weekdayConvertChinese;

/**
 * 获得NSDate对应的月份 (几月)
 * @param  shorthand  简拼 (YES->JAN, NO->January)
 *
 * @return NSDate对应的月份
 */
- (NSString *)WD_monthConvertEnglishMonthWhetherShorthand:(BOOL)shorthand;

/**
 * 获得NSDate对应的当前月第一天是一周的第几天 (日->0...六->6)
 * 应用于布局日历UI
 *
 * @return  NSDate对应的当月第一天是这周的第几天
 */
- (NSUInteger)WD_indexOfWeekForFirstDayInCurrentMonth;

/**
 * 获得NSDate对应的当月天数
 *
 * @return  NSDate对应的天数
 */
- (NSUInteger)WD_daysInMonth;
+ (NSUInteger)WD_daysInMonth:(NSDate *)date month:(NSUInteger)month;

/**
 * 获取当天是当年的第几周
 *
 * @return  当天是当年的第几周
 */
- (NSUInteger)WD_weekOfDayInYear;

/**
 * 判断与某一天是否为同一天
 * @param  otherDate  某一天
 *
 * @return  结果
 */
- (BOOL)WD_sameDayWithDate:(NSDate *)otherDate;

/**
 * 判断与某一天是否为同一周
 * @param  otherDate  某一天
 *
 * @return  结果
 */
- (BOOL)WD_sameWeekWithDate:(NSDate *)otherDate;

/**
 * 判断与某一天是否为同一月
 * @param  otherDate  某一天
 *
 * @return  结果
 */
- (BOOL)WD_sameMonthWithDate:(NSDate *)otherDate;

#pragma mark -- 日期相关计算
/**
 * 计算两个时间戳相差天数 (时间戳相同表示相差一天,时间戳先后顺序可以不作考虑)
 * @param timeSP       时间戳
 * @param otherTimeSP  另一个时间戳
 *
 * @return  差值
 */
+ (NSInteger)WD_differenceDaysWithTimestamp:(NSString *)timeSP anotherTimeStamp:(NSString *)otherTimeSP;

/**
 * 数值转换时间格式 (66 -> 01:06)
 * @param time   时间值
 *
 * @return  01:06
 */
+ (NSString *)WD_convertStringWithMinSec:(CGFloat)time;

/**
 * 数值转换时间格式 (3666 -> 01:01:06)
 * @param time   时间值
 *
 * @return  01:01:06
 */
+ (NSString *)WD_convertStringWithHourMinSec:(CGFloat)time;

/**
 * 时间戳转换时间格式 (1521814909 -> 4个月前)
 * @param timesamp   时间戳
 *
 * @return  刚刚、一分钟前、一小时前、昨天、两天前、一月前、一年前
 */
+ (NSString *)WD_timeInfoWithTimesamp:(NSString *)timesamp;

/**
 * 时间转换时间格式 (@"2018-03-04 12:20:22" -> 4个月前)
 * @param time   时间字符串
 * @param formatter  时间模板 (例:yyyy-MM-dd HH:mm:ss)
 *
 * @return  刚刚、一分钟前、一小时前、昨天、两天前、一月前、一年前
 */
+ (NSString *)WD_timeInfoWithTime:(NSString *)time dateFormatter:(NSString *)formatter;

#pragma mark -- 日历
/** 获取当前月总共有多少天 */
+ (NSInteger)numberOfDaysInCurrentMonth;
/** 获取当前月中共有多少周 */
+ (NSInteger)numberOfWeeksInCurrentMonth;
/** 获取当前月中第一天在一周内的索引 */
+ (NSInteger)indexOfWeekForFirstDayInCurrentMonth;
/** 获取当天在当月中的索引(第几天) */
+ (NSInteger)indexOfMonthForTodayInCurrentMonth;

@end

NS_ASSUME_NONNULL_END
