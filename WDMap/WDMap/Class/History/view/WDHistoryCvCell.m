//
//  WDHistoryCvCell.m
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDHistoryCvCell.h"
#import "WDDigitModel.h"

@implementation WDHistoryCvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (void)setModel:(WDDigitModel *)model {
    _model = model;
    
    self.titleLab.text = model.title?:@"";
    
    if (model.isSelect) {
        self.backImgView.image = [UIImage imageNamed:@"history_select_img"];
        self.arrowImgView.hidden = NO;

    }else {
        self.backImgView.image = [UIImage imageNamed:@"history_nomal_img"];
        self.arrowImgView.hidden = YES;
    }
}

@end
