//
//  NSDictionary+WDSafeObjectForKey.h
//  NetClass
//
//  Created by wbb on 15/10/28.
//  Copyright © 2015年 WD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WDSafeObjectForKey)

- (id)safeObjectForKey:(id)key;

- (BOOL)safeBoolForKey:(id)key;

// 将NSDictionary中的Null类型的项目转化成@""
+ (NSDictionary *)nullDic:(NSDictionary *)sourceDic;

@end
