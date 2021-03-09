//
//  WDRoadTableViewCell.m
//  WDMap
//
//  Created by wbb on 2021/2/8.
//

#import "WDRoadTableViewCell.h"
#import "WDScenicModel.h"
@implementation WDRoadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(WDRoadChildModel *)model {
    _model = model;
    self.titleLab.text = model.title;
}

@end
