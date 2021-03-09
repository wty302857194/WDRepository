//
//  WDDynamicScrollerCell.m
//  WDMap
//
//  Created by wbb on 2021/2/1.
//

#import "WDDynamicScrollerCell.h"

@implementation WDDynamicScrollerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [WDGlobal addShadow:self.backView];
    self.eyeLab.text = @"";
    self.titleLab.text = @"";
    self.timeLab.text = @"";
}
- (void)setModel:(WDDynamicModel *)model {
    _model = model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img_url?:@""] placeholderImage:PLACE_HOLDER_IMAGE];
    self.titleLab.text = model.title?:@"";
    NSString *str = [model.add_time?:@"" substringWithRange:NSMakeRange(6, 10)];
    self.timeLab.text = [NSDate WD_timestampTranslateTime:str?:@"" dateFormatter:WD_yyyyMMdd_fmt];
    self.eyeLab.text = model.click?:@"";
}
@end
