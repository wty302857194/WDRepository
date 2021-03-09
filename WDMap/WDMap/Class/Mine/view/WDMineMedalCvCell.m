//
//  WDMineMedalCvCell.m
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDMineMedalCvCell.h"

@implementation WDMineMedalCvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backView.borderColor = [UIColor blackColor];
    self.backView.borderWidth = 1;
    [self.backView setCornerRadius:10];
    
    self.titleLab.text = @"";
    
}

- (void)setModel:(WDMineXunzhangModel *)model {
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.xunzhang?:@""] placeholderImage:PLACE_HOLDER_IMAGE];
    self.titleLab.text = model.title;
}

@end
