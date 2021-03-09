//
//  WDMineScenicTVCell.m
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDMineScenicTVCell.h"
#import "WDScenicModel.h"

@implementation WDMineScenicTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.text = @"";
    self.contentLab.text = @"";
    self.timeLab.text = @"";
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backView.borderColor = [UIColor blackColor];
    self.backView.borderWidth = 1;
    [self.backView setCornerRadius:5];
//    [WDGlobal addShadow:self.backView];
    [self.imgView setCornerRadius:self.imgView.height/2.f];

}
- (void)setModel:(WDScenicModel *)model {
    _model = model;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
    self.titleLab.text = model.title;
    self.contentLab.text = model.xiangxidizhi;
    NSString *str = [NSString stringWithFormat:@"%@", model.scsj];
    self.timeLab.text = str;
    
}

@end
