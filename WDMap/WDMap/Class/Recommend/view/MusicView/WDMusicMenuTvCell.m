//
//  WDMusicMenuTvCell.m
//  WDMap
//
//  Created by wbb on 2021/2/20.
//

#import "WDMusicMenuTvCell.h"
#import "WDMusicModel.h"

@implementation WDMusicMenuTvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.namelab.text = @"";
    self.userlab.text = @"";
    
}
- (void)setIsChoose:(BOOL)isChoose {
    if (!isChoose) {
        self.imgView.hidden = YES;
        self.leftLayout.constant = 15;
        self.namelab.textColor = [UIColor blackColor];
        self.userlab.textColor = hexColor(898989);
        self.namelab.font = [UIFont systemFontOfSize:15];
        self.userlab.font = [UIFont systemFontOfSize:13];
    }else {
        self.imgView.hidden = NO;
        self.leftLayout.constant = 35;
        self.namelab.textColor = hexColor(326bf9);
        self.userlab.textColor = hexColor(326bf9);
        self.namelab.font = [UIFont systemFontOfSize:16];
        self.userlab.font = [UIFont systemFontOfSize:14];
    }
}
- (void)setMusicModel:(WDPlayMusicListModel *)musicModel {
    _musicModel = musicModel;
    self.namelab.text = musicModel.title;
    self.userlab.text = [NSString stringWithFormat:@"-%@", musicModel.author];
    
}
- (IBAction)deletClick:(UIButton *)sender {
    if (self.deleItemtBlock) {
        self.deleItemtBlock();
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
