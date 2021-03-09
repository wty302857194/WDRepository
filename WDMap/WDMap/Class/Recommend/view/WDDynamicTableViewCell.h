//
//  WDDynamicTableViewCell.h
//  WDMap
//
//  Created by wbb on 2021/2/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^PushDetailBlock)(void);
@interface WDDynamicTableViewCell : UITableViewCell
@property (nonatomic, copy) NSArray * itemDataArr;
@property (nonatomic, copy) PushDetailBlock pushDetailBlock;

-(void)itemArray:(NSArray *)arr index:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
