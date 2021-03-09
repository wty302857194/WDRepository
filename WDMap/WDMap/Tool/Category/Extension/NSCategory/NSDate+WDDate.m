//
//  NSDate+WDDate.m
//  NetClass
//
//  Created by lnd on 2020/3/6.
//  Copyright © 2020 WD. All rights reserved.
//

#import "NSDate+WDDate.h"

@implementation NSDate (WDDate)

/** 获取当前时间戳 */
+ (NSString *)WD_currentTimestamp {
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%llu", recordTime];
    return timeSp;
}

/** 获取当前时间 double接收*/
+ (NSTimeInterval)WD_currentTimeInterval {
    
    return [[NSDate date] timeIntervalSince1970];
}

/** 获取当前时间字符串 */
+ (NSString *)WD_currentTimeWithDateFormatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [self WD_initDateFormatter];
    [dateFormatter setDateFormat:formatter];
    NSString *time = [dateFormatter stringFromDate:[NSDate date]];
    return time;
}

/** 把时间戳转化为时间 */
+ (NSString *)WD_timestampTranslateTime:(NSString *)timestamp dateFormatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [self WD_initDateFormatter];
    [dateFormatter setDateFormat:formatter];
    NSDate *confirmDate = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSString *time = [dateFormatter stringFromDate:confirmDate];
    
    return time;
}

/** 把时间转化为时间戳 */
+ (NSString *)WD_timeTranslateTimestamp:(NSString *)time dateFormatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormater = [self WD_initDateFormatter];
    [dateFormater setDateFormat:formatter];
    NSDate *date = [dateFormater dateFromString:time];
    NSString *timeSp = [NSString stringWithFormat:@"%.0lf", [date timeIntervalSince1970]];
    return timeSp;
}

/** NSDate转成时间戳 */
+ (NSString *)WD_dateTranslatetimestamp:(NSDate *)date {
    
    NSString *timeSp = [NSString stringWithFormat:@"%.0lf", [date timeIntervalSince1970]];
    return timeSp;
}

/** 时间戳转成NSDate */
+ (NSDate *)WD_timestampTranslateDate:(NSString *)timestamp {
    if (!timestamp || timestamp.length == 0) {
        return [NSDate date];
    }
    NSDate *confirmDate = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    return confirmDate;
}

/** NSDate转成时间字符串 */
+ (NSString *)WD_dateTranslateTimeString:(NSDate *)date dateFormatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [self WD_initDateFormatter];
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter stringFromDate:date];
}

/** 时间字符串转成NSDate */
+ (NSDate *)WD_timeStringTranslateDate:(NSString *)timeString dateFormatter:(NSString *)formatter {
    
    NSDateFormatter *dateFormatter = [self WD_initDateFormatter];
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter dateFromString:timeString];
}

/** 判断是否是润年 */
- (BOOL)WD_isLeapYear {
    return [NSDate WD_isLeapYear:self];
}

+ (BOOL)WD_isLeapYear:(NSDate *)date {
    NSUInteger year = [date WD_year];
    if ((year % 4  == 0 && year % 100 != 0) || year % 400 == 0) {
        return YES;
    }
    return NO;
}

/**
 * 判断某个时间是否为今天
 */
- (BOOL)WD_isToday {
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[self class] WD_initDateFormatter];
    fmt.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}

#pragma mark -- 日历相关
/** 日期组件 */
- (NSDateComponents *)WD_compontents {
    // 创建日历
    NSCalendar *calendar = [self WD_initCalendar];
    //定义成分
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:self];
}

/** 获得NSDate对应的年份 */
- (NSUInteger)WD_year {
    return [self WD_compontents].year;
}

/** 获得NSDate对应的月份 */
- (NSUInteger)WD_month {
    return [self WD_compontents].month;
}

/** 获得NSDate对应的日期 */
- (NSUInteger)WD_day {
    return [self WD_compontents].day;
}

/** 获得NSDate对应的小时 */
- (NSUInteger)WD_hour {
    return [self WD_compontents].hour;
}

/** 获得NSDate对应的分钟数 */
- (NSUInteger)WD_minute {
    return [self WD_compontents].minute;
}

/** 获得NSDate对应的秒数 */
- (NSUInteger)WD_second {
    return [self WD_compontents].second;
}

/** 获得NSDate对应的星期 */
- (NSUInteger)WD_weekday {
    return [self WD_compontents].weekday;
}

/** 获得NSDate对应的星期 (星期几) */
- (NSString *)WD_weekdayConvertChinese {
    
    int weekday = (int)[self WD_weekday]; //weekday就是星期几，1代表星期日，2代表星期一，后面依次
    switch (weekday) {
        case 1:
            return @"周日";
            break;
        case 2:
            return @"周一";
            break;
        case 3:
            return @"周二";
            break;
        case 4:
            return @"周三";
            break;
        case 5:
            return @"周四";
            break;
        case 6:
            return @"周五";
            break;
        case 7:
            return @"周六";
            break;
            
        default:
            break;
    }
    
    return @"";
}

/** 获得NSDate对应的月份 (几月) */
- (NSString *)WD_monthConvertEnglishMonthWhetherShorthand:(BOOL)shorthand {
    
    int month = (int)[self WD_month]; //month就是月份，1代表JAN，2代表FEB，后面依次
    switch (month) {
        case 1:
            if (shorthand) return @"JAN";
            return @"January";
            break;
        case 2:
            if (shorthand) return @"FEB";
            return @"February";
            break;
        case 3:
            if (shorthand) return @"MAR";
            return @"March";
            break;
        case 4:
            if (shorthand) return @"APR";
            return @"April";
            break;
        case 5:
            if (shorthand) return @"MAY";
            return @"May";
            break;
        case 6:
            if (shorthand) return @"JUN";
            return @"June";
            break;
        case 7:
            if (shorthand) return @"JUL";
            return @"July";
            break;
        case 8:
            if (shorthand) return @"AUG";
            return @"August";
            break;
        case 9:
            if (shorthand) return @"SEP";
            return @"September";
            break;
        case 10:
            if (shorthand) return @"OCT";
            return @"October";
            break;
        case 11:
            if (shorthand) return @"NOV";
            return @"November";
            break;
        case 12:
            if (shorthand) return @"DEC";
            return @"December";
            break;
        default:
            break;
    }
    return @"";
}

/** 获得NSDate对应的当前月第一天是一周的第几天 */
- (NSUInteger)WD_indexOfWeekForFirstDayInCurrentMonth {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:self];
    dateComponents.day = 1;
    
    NSDate *beginDate = [[self WD_initCalendar] dateFromComponents:dateComponents];
    NSDateComponents *beginDateComponents = [calendar components:NSCalendarUnitWeekday fromDate:beginDate];
    NSInteger indexOfWeek = ([beginDateComponents weekday] + 6) % 7;
    
    return indexOfWeek;
}

/** 获得NSDate对应的当月天数 */
- (NSUInteger)WD_daysInMonth {
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    
    return range.length;
}

+ (NSUInteger)WD_daysInMonth:(NSDate *)date month:(NSUInteger)month {
    switch (month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return [date WD_isLeapYear] ? 29 : 28;
    }
    return 30;
}

/** 获取当天是当年的第几周 */
- (NSUInteger)WD_weekOfDayInYear {
    return [[self WD_initCalendar] ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:self];
}

/** 判断与某一天是否为同一天 */
- (BOOL)WD_sameDayWithDate:(NSDate *)otherDate {
    
    if (self.WD_year == otherDate.WD_year && self.WD_month == otherDate.WD_month && self.WD_day == otherDate.WD_day) {
        return YES;
    }
    
    return NO;
}

/** 判断与某一天是否为同一周 */
- (BOOL)WD_sameWeekWithDate:(NSDate *)otherDate {
    
    if (self.WD_year == otherDate.WD_year && self.WD_month == otherDate.WD_month && self.WD_weekOfDayInYear == otherDate.WD_weekOfDayInYear) {
        return YES;
    }
    
    return NO;
}

/** 判断与某一天是否为同一月 */
- (BOOL)WD_sameMonthWithDate:(NSDate *)otherDate {
    
    if (self.WD_year == otherDate.WD_year && self.WD_month == otherDate.WD_month) {
        return YES;
    }
    
    return NO;
}

/** 计算两个时间戳相差天数 */
+ (NSInteger)WD_differenceDaysWithTimestamp:(NSString *)timeSP anotherTimeStamp:(NSString *)otherTimeSP {
    
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:[NSDate dateWithTimeIntervalSince1970:[timeSP doubleValue]]];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:[NSDate dateWithTimeIntervalSince1970:[otherTimeSP doubleValue]]];
    
    NSDateComponents *dayComponents = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    NSInteger days = (long)(abs((int)[dayComponents day]) + 1);
    return days;
}

+ (NSString *)WD_convertStringWithMinSec:(CGFloat)time {
    if (isnan(time)) time = 0.f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}

+ (NSString *)WD_convertStringWithHourMinSec:(CGFloat)time {

    if (isnan(time)) time = 0.f;
    int hour = time / 3600.0;
    int min  = (time - hour * 3600) / 60.0;
    int sec  = time - hour * 3600 - min * 60;
    
    NSString *hourStr = hour > 9 ? [NSString stringWithFormat:@"%d",hour] : [NSString stringWithFormat:@"0%d",hour];
    NSString *minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString *secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString *timeStr = [NSString stringWithFormat:@"%@:%@:%@", hourStr, minStr, secStr];
    return timeStr;
}

/** 时间戳转换时间格式 (1521814909 -> 4个月前) */
+ (NSString *)WD_timeInfoWithTimesamp:(NSString *)timesamp {
    
    NSDate *date = [self WD_timestampTranslateDate:timesamp];
    
    return [self WD_timeInfoWithDate:date];
}

/** 时间转换时间格式 (@"2018-03-04 12:20:22" -> 4个月前) */
+ (NSString *)WD_timeInfoWithTime:(NSString *)time dateFormatter:(NSString *)formatter {
    
    NSDate *date = [self WD_timeStringTranslateDate:time dateFormatter:formatter];
    
    return [self WD_timeInfoWithDate:date];
}

+ (NSString *)WD_timeInfoWithDate:(NSDate *)date {
    
    NSDate *curDate = [NSDate date];
    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
    
    int month = (int)([curDate WD_month] - [date WD_month]);
    int year = (int)([curDate WD_year] - [date WD_year]);
    int day = (int)([curDate WD_day] - [date WD_day]);
    
    NSTimeInterval retTime = 1.0;
    if (time < 60) {
        return @"刚刚";
    } else if (time < 3600) { // 小于一小时
        retTime = time / 60;
        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
    } else if (time < 3600 * 24) { // 小于一天，也就是今天
        retTime = time / 3600;
        retTime = retTime <= 0.0 ? 1.0 : retTime;
        return [NSString stringWithFormat:@"%.0f小时前", retTime];
    } else if (time < 3600 * 24 * 2) {
        return @"昨天";
    }
    // 第一个条件是同年，且相隔时间在一个月内
    // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
    else if ((abs(year) == 0 && abs(month) <= 1)
             || (abs(year) == 1 && [curDate WD_month] == 1 && [date WD_month] == 12)) {
        int retDay = 0;
        if (year == 0) { // 同年
            if (month == 0) { // 同月
                retDay = day;
            }
        }
        
        if (retDay <= 0) {
            // 获取发布日期中，该月有多少天
            int totalDays = (int)[self WD_daysInMonth:date month:[date WD_month]];
            
            // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
            retDay = (int)[curDate WD_day] + (totalDays - (int)[date WD_day]);
        }
        
        return [NSString stringWithFormat:@"%d天前", (abs)(retDay)];
    } else  {
        if (abs(year) <= 1) {
            if (year == 0) { // 同年
                return [NSString stringWithFormat:@"%d个月前", abs(month)];
            }
            
            // 隔年
            int month = (int)[curDate WD_month];
            int preMonth = (int)[date WD_month];
            if (month == 12 && preMonth == 12) {// 隔年，但同月，就作为满一年来计算
                return @"1年前";
            }
            return [NSString stringWithFormat:@"%d个月前", (abs)(12 - preMonth + month)];
        }
        
        return [NSString stringWithFormat:@"%d年前", abs(year)];
    }
    //  永远过不来
    return @"1小时前";
}


#pragma mark -- onceDateFormatter
+ (NSDateFormatter *)WD_initDateFormatter {
    
    static NSDateFormatter *formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
    });
    
    return formatter;
}

#pragma mark -- onceCalendar
- (NSCalendar *)WD_initCalendar {
    
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    return calendar;
}

#pragma mark -- 日历
+ (NSInteger)numberOfDaysInCurrentMonth {
    // 初始化日历
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取系统当前日期
    NSDate *currentDate = [NSDate date];
    // 获取当前日期中当前月中天的范围
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:currentDate];
    // 得到当前月中总共有多少天（即范围的长度）
    NSInteger numberOfDaysInCurrentMonth = range.length;
    return numberOfDaysInCurrentMonth;
}

/** 获取当前月中共有多少周 */
+ (NSInteger)numberOfWeeksInCurrentMonth {
    // 初始化日历
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取系统当前日期
    NSDate *currentDate = [NSDate date];
    // 获取当前日期中当前月中周的范围
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:currentDate];
    // 得到当前月中总共有多少周（即范围的长度）
    NSInteger numberOfWeeksInCurrentMonth = range.length;
    return numberOfWeeksInCurrentMonth;
}

+ (NSInteger)indexOfWeekForFirstDayInCurrentMonth {
    // 初始化日历
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取系统当前日期
    NSDate *currentDate = [NSDate date];
    // 获取当前月中的第一天的日期
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:currentDate];
    [dateComponents setDay:1];
    NSDate *beginDate = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    // 当前月中的第一天的日期组件
    NSDateComponents *beginDateComponents = [calendar components:NSCalendarUnitWeekday fromDate:beginDate];
    // 将格式：日一, ……,五, 六  转换成格式：一二, ……, 六 日，获得索引
    NSInteger indexOfWeek = ([beginDateComponents weekday] + 6) % 7;
    
    return indexOfWeek;
}

+ (NSInteger)indexOfMonthForTodayInCurrentMonth {
    // 初始化日历
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取系统当前日期
    NSDate *currentDate = [NSDate date];
    // 获取当前日期的组件
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitDay fromDate:currentDate];
    NSInteger indexOfMonthForTodayInCurrentMonth = [dateComponents day];
    return indexOfMonthForTodayInCurrentMonth;
}

@end
