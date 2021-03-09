//
//  WDHotLineVC.h
//  WDMap
//
//  Created by wbb on 2021/2/16.
//

#import "WDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class WDScenicModel, WDRelevancePersonModel;
@interface WDHotLineVC : WDBaseViewController
@property (nonatomic, strong) WDScenicModel *model;
@property (nonatomic, strong) WDRelevancePersonModel *personModel;
@end

NS_ASSUME_NONNULL_END
