//
//  WDHomeCollectionViewCell.h
//  WDMap
//
//  Created by wbb on 2021/1/31.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^ButtnClickBlcok)(void);
@interface WDHomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;
@property (copy, nonatomic) ButtnClickBlcok buttnClickBlcok;
- (void)indexPath:(NSInteger )index;
@end

NS_ASSUME_NONNULL_END
