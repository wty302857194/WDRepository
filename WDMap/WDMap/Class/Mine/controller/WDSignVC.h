//
//  WDSignVC.h
//  WDMap
//
//  Created by wbb on 2021/3/9.
//

#import "WDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TextChangeBlock)(NSString *text);
@interface WDSignVC : WDBaseViewController
@property (nonatomic, copy) TextChangeBlock textChangeBlock;
@end

NS_ASSUME_NONNULL_END
