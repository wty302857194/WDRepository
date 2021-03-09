//
//  WDUtil.m
//  NetClass
//
//  Created by wbb on 2020/3/5.
//  Copyright © 2020 WD. All rights reserved.
//

#import "WDUtil.h"

@implementation WDUtil
+(instancetype)shareInstance {
    static WDUtil *_shareGlobal = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareGlobal = [[WDUtil alloc] init];
    });
    return _shareGlobal;
}
/// MARK: 根据关键字保存对应的设置信息
+ (void)setInfo:(id)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:value forKey:key];
    [defaults synchronize];
}
/// MARK: 擦除关键字对应的设置信息
+(void)removeInfoForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
/// MARK: 根据关键字读取对应的设置信息
+ (id)getInfoForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id result = [defaults objectForKey:key];
    return result;
}
/// MARK:  删除NSUserDefaults所有记录
+ (void)removeAllInfo {
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
}
+ (void)resetDefaults {
    
    NSUserDefaults * defs = [NSUserDefaults standardUserDefaults];
    
    NSDictionary * dict = [defs dictionaryRepresentation];
    
    for(id key in dict) {
        [defs removeObjectForKey:key];
    }
    [defs synchronize];
}
/// MARK:  退出登录删除NSUserDefaults 部分信息
+ (void)removeUserInfo {
    [WDUtil removeInfoForKey:WD_USERNAME];
    [WDUtil removeInfoForKey:WD_PASSWORD];
    [WDUtil removeInfoForKey:WD_USERID];
}
@end
