//
//  WDEnum.h
//  NetClass
//
//  Created by wbb on 2020/3/14.
//  Copyright © 2020 WD. All rights reserved.
//

#ifndef WDEnum_h
#define WDEnum_h

/// 文都状态中的type
typedef NS_ENUM(NSUInteger, DynamicType) {
    DynamicTypeWenxue,
    DynamicTypeJinqi,
    DynamicTypeBook,
};
/// 播放器循环状态
typedef NS_ENUM(NSUInteger, MusicRunLoopType) {
    MusicRunLoopShunXun,
    MusicRunLoopDanqu,
    MusicRunLoopSuiji,
};

#endif /* WDEnum_h */
