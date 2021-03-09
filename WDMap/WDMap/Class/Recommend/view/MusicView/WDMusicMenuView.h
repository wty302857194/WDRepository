//
//  WDMusicMenuView.h
//  WDMap
//
//  Created by wbb on 2021/2/20.
//

#import "WDBaseView.h"

NS_ASSUME_NONNULL_BEGIN
/// 删除回掉
typedef void(^DeletItemBlock)(NSInteger index, BOOL isAll);
/// 选中item回掉
typedef void(^SelectItemBlock)(NSInteger index);
/// 循环回掉
typedef void(^CurrentLoopBlock)(void);
@interface WDMusicMenuView : WDBaseView

- (void)musicArray:(NSMutableArray *)musicArr index:(NSInteger)index;
@property (nonatomic, copy) DeletItemBlock deletItemBlock;
@property (nonatomic, copy) SelectItemBlock selectItemBlock;
@property (nonatomic, copy) CurrentLoopBlock currentLoopBlock;

@property (nonatomic, assign) MusicRunLoopType runLoopType;
@end

NS_ASSUME_NONNULL_END
