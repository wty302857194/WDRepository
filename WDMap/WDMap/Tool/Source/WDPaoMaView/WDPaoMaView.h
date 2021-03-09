//
//  WDPaoMaView.h
//  WDMap
//
//  Created by wbb on 2021/2/3.
//

#import "WDBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDPaoMaView : WDBaseView
// 构造方法
- (instancetype)initWithList:(NSArray *)list;
+ (instancetype)paoMaViewWithList:(NSArray *)list;
@end

NS_ASSUME_NONNULL_END
