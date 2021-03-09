//
//  WDDynamicDetailCell.h
//  WDMap
//
//  Created by wbb on 2021/2/3.
//

#import <UIKit/UIKit.h>
#import "WDDynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WDDynamicDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timelab;
@property (weak, nonatomic) IBOutlet UILabel *numlab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLayout;
@property (weak, nonatomic) IBOutlet UIImageView *yaoshiImgView;

@property (nonatomic, strong) WDDynamicModel * model;
@end

NS_ASSUME_NONNULL_END
