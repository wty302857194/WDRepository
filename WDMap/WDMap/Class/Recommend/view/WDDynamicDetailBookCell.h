//
//  WDDynamicDetailBookCell.h
//  WDMap
//
//  Created by wbb on 2021/2/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WDDynamicModel;
@interface WDDynamicDetailBookCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bookImgView;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *authorLab;

@property (nonatomic, strong) WDDynamicModel * model;

@end

NS_ASSUME_NONNULL_END
