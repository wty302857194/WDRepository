//
//  WDRoadDetailCell.m
//  WDMap
//
//  Created by wbb on 2021/2/16.
//

#import "WDRoadDetailCell.h"
#import "WDScenicModel.h"

@implementation WDRoadDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(WDRoadjingdiandataModel *)model {
    _model = model;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
    self.titleLab.text = model.title;
}
@end
