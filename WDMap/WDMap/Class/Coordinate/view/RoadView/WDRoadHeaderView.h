//
//  WDRoadHeaderView.h
//  WDMap
//
//  Created by wbb on 2021/2/8.
//

#import "WDBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class WDRoadModel;

typedef void(^RodeHeaderBlock)(void);
@interface WDRoadHeaderView : WDBaseView
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *address_num_lab;
@property (weak, nonatomic) IBOutlet UILabel *tag_num_lab;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *roadImgView;
@property (weak, nonatomic) IBOutlet UIImageView *addressImgView;

@property (nonatomic, copy) RodeHeaderBlock rodeHeaderBlock;

@property (nonatomic, strong) WDRoadModel * model;
@end

NS_ASSUME_NONNULL_END
