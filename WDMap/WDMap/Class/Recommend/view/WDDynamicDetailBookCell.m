//
//  WDDynamicDetailBookCell.m
//  WDMap
//
//  Created by wbb on 2021/2/17.
//

#import "WDDynamicDetailBookCell.h"
#import "WDDynamicModel.h"

@implementation WDDynamicDetailBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentLab.text = @"";
    self.nameLab.text = @"";
    self.authorLab.text = @"";
    
}

- (void)setModel:(WDDynamicModel *)model {
    _model = model;
    
    self.nameLab.text = model.sub_title?:@"";
    self.contentLab.text = model.zhaiyao;
    [self.bookImgView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
    self.authorLab.text = [NSString stringWithFormat:@"作者：%@",model.zuozhe];
}

@end
