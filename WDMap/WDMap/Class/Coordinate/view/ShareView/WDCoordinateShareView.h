//
//  WDCoordinateShareView.h
//  WDMap
//
//  Created by wbb on 2021/2/17.
//

#import "WDBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TouchHiddenBlock)(NSInteger index);

@interface WDCoordinateShareView : WDBaseView
@property (nonatomic, copy) TouchHiddenBlock  touchHiddenBlock;

@end

NS_ASSUME_NONNULL_END
