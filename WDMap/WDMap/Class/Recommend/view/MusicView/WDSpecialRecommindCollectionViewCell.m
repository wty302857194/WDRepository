//
//  WDSpecialRecommindCollectionViewCell.m
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import "WDSpecialRecommindCollectionViewCell.h"

@implementation WDSpecialRecommindCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(WDMusicAlbumModel *)model {
    _model = model;
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img_url?:@""] placeholderImage:PLACE_HOLDER_IMAGE];
    self.titleLab.text = model.title?:@"";
}

@end
