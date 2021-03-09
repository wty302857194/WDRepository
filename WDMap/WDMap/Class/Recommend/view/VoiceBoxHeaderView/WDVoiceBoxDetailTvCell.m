//
//  WDVoiceBoxDetailTvCell.m
//  WDMap
//
//  Created by wbb on 2021/2/20.
//

#import "WDVoiceBoxDetailTvCell.h"
#import "WDMusicModel.h"

@implementation WDVoiceBoxDetailTvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = main_background_color;
    
    self.titleLab.text = @"";
    self.detailLab.text = @"";
}

- (void)drawRect:(CGRect)rect {
    
    if (self.isCorner) {
        [WDGlobal addCorners:self.backView emunType:WDBottomState cornerNum:30];
    }
}

- (void)setModel:(WDHotMusicModel *)model {
    _model = model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img_url?:@""] placeholderImage:PLACE_HOLDER_IMAGE];
    self.titleLab.text = model.title?:@"";
    self.detailLab.text = model.zhuanji?:@"";
}

@end
