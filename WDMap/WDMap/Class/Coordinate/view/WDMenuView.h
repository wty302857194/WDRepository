//
//  WDMenuView.h
//  WDMap
//
//  Created by wbb on 2021/2/2.
//

#import "WDBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^MenuTouchBlock)(NSInteger index, BOOL isChild);
@interface WDMenuView : WDBaseView

@property (nonatomic, copy) MenuTouchBlock menuTouchBlock;

- (instancetype)initWithFrame:(CGRect)frame withMenuList:(NSArray *)menuList ;
@end

NS_ASSUME_NONNULL_END
