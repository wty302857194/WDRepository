//
//  WDUtil.h
//  NetClass
//
//  Created by wbb on 2020/3/5.
//  Copyright © 2020 WD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDUtil : NSObject

@property (nonatomic, assign) BOOL isFaceBackLogin;//是否是从人脸识别返回到登录页



+(instancetype)shareInstance;
/// 根据关键字保存对应的设置信息
+ (void)setInfo:(id)value forKey:(NSString *)key;
/// 擦除关键字对应的设置信息
+(void)removeInfoForKey:(NSString *)key;
/// 根据关键字读取对应的设置信息
+ (id)getInfoForKey:(NSString *)key;
/// 删除NSUserDefaults所有记录
+ (void)removeAllInfo;
+ (void)resetDefaults;

/// 删除NSUserDefaultsu 用户信息
+ (void)removeUserInfo;
@end

NS_ASSUME_NONNULL_END
