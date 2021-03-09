//
//  WDDynamicDetailCell.m
//  WDMap
//
//  Created by wbb on 2021/2/3.
//

#import "WDDynamicDetailCell.h"

@implementation WDDynamicDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.text = @"";
    self.contentLab.text = @"";
    self.timelab.text = @"";
    self.numlab.text = @"";
}
- (void)setModel:(WDDynamicModel *)model {
    if(model.type == DynamicTypeWenxue) {
        self.yaoshiImgView.hidden = YES;
        self.widthLayout.constant = 0;
        self.contentLab.textColor = hexColor(3d6ef0);

    }else {
        self.contentLab.textColor = hexColor(e64870);
    }
    
    self.titleLab.text = model.sub_title?:@"";
    self.contentLab.text = model.title;
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
    NSString *str = [model.add_time?:@"" substringWithRange:NSMakeRange(6, 10)];
    self.timelab.text = [NSDate WD_timestampTranslateTime:str dateFormatter:WD_yyyyMMdd_fmt];
    self.numlab.text = [NSString stringWithFormat:@"%@人已读",model.click];
}


@end
