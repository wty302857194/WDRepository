//
//  WDMineScenicTVCell.h
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WDScenicModel;
@interface WDMineScenicTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, strong) WDScenicModel * model;
@end

NS_ASSUME_NONNULL_END
