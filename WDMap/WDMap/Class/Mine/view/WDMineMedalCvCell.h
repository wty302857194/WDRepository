//
//  WDMineMedalCvCell.h
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import <UIKit/UIKit.h>
#import "WDMineModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface WDMineMedalCvCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) WDMineXunzhangModel * model;
@end

NS_ASSUME_NONNULL_END
