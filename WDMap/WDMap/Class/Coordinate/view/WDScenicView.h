//
//  WDScenicView.h
//  WDMap
//
//  Created by wbb on 2021/2/3.
//

#import "WDBaseView.h"
#import "WDScenicModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TouchHiddenBlock)(void);
@interface WDScenicView : WDBaseView
@property (nonatomic, copy) TouchHiddenBlock  touchHiddenBlock;
@property (nonatomic, strong) WDScenicModel *model;
@end

NS_ASSUME_NONNULL_END
