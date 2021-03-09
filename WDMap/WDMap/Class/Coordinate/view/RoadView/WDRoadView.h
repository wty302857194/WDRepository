//
//  WDRoadView.h
//  WDMap
//
//  Created by wbb on 2021/2/8.
//

#import "WDBaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TouchHiddenBlock)(void);
typedef void(^RoadDetailBlock)(NSString *xlid);
@interface WDRoadView : WDBaseView
@property (nonatomic, copy) TouchHiddenBlock  touchHiddenBlock;
@property (nonatomic, copy) RoadDetailBlock  roadDetailBlock;

+ (instancetype)roadView;
@end

NS_ASSUME_NONNULL_END
