//
//  WDSearchHistoryView.h
//  WDMap
//
//  Created by wbb on 2021/1/30.
//

#import "WDBaseView.h"
@class WDScenicModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^TextChangeBlock)(NSString *text);
typedef void(^SelectItemBlock)(WDScenicModel *model);

@interface WDSearchHistoryView : WDBaseView
@property (nonatomic, copy) TextChangeBlock textChangeBlock;
@property (nonatomic, copy) SelectItemBlock selectItemBlock;
@property (nonatomic, copy) NSArray * dataArr;


/// 是否是点击搜索按钮才开始搜索。
@property (nonatomic, assign) BOOL isNotValueChange;
@end

NS_ASSUME_NONNULL_END
