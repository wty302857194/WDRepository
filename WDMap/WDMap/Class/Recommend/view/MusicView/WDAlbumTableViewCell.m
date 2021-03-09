//
//  WDAlbumTableViewCell.m
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import "WDAlbumTableViewCell.h"
#import "WDMusicModel.h"

@implementation WDAlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.text = @"";
    self.indexLab.text = @"";
    self.contentlab.text = @"";
}
- (IBAction)playclick:(id)sender {
}
- (void)setModel:(WDPlayMusicListModel *)model {
    _model = model;
    self.titleLab.text = model.title;
    self.contentlab.text = model.author;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
