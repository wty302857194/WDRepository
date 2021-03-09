//
//  WDScenicTableViewController.h
//  WDMap
//
//  Created by wbb on 2021/2/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WDScenicModel;

@interface WDScenicTableViewController : UITableViewController
@property (nonatomic, strong) WDScenicModel * scenicModel;
@property (nonatomic, copy) NSString * userName;
@end

NS_ASSUME_NONNULL_END
