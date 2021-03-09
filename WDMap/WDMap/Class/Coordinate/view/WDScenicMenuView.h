//
//  WDScenicMenuView.h
//  WDMap
//
//  Created by wbb on 2021/2/25.
//

#import "WDBaseView.h"
@class WDScenicClassifyModel;

NS_ASSUME_NONNULL_BEGIN
typedef void(^MenuTouchBlock)(WDScenicClassifyModel *model);

@interface WDScenicMenuView : WDBaseView
@property (nonatomic, copy) MenuTouchBlock menuTouchBlock;

- (instancetype)initWithFrame:(CGRect)frame withMenuList:(NSArray *)menuList ;
- (void)show;
- (void)disappear;
@end

NS_ASSUME_NONNULL_END
