//
//  WDMusicItemCell.m
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import "WDMusicItemCell.h"
#import "WDMusicModel.h"
@implementation WDMusicItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.titleLab.text = @"";
    self.detailLab.text = @"";
}

- (void)setModel:(WDHotMusicModel *)model {
    _model = model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img_url?:@""] placeholderImage:PLACE_HOLDER_IMAGE];
    self.titleLab.text = model.title?:@"";
    self.detailLab.text = model.zhuanji?:@"";
}

@end
