//
//  WDDynamicScrollerCell.h
//  WDMap
//
//  Created by wbb on 2021/2/1.
//

#import <UIKit/UIKit.h>
#import "WDDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDDynamicScrollerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *eyeLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic, strong) WDDynamicModel * model;
@end

NS_ASSUME_NONNULL_END
