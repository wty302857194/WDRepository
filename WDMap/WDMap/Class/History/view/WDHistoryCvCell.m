//
//  WDHistoryCvCell.m
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDHistoryCvCell.h"

@implementation WDHistoryCvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setIsSelect:(BOOL)isSelect {
    if (isSelect) {
        self.backImgView.image = [UIImage imageNamed:@"history_select_img"];
        self.arrowImgView.hidden = NO;

    }else {
        self.backImgView.image = [UIImage imageNamed:@"history_nomal_img"];
        self.arrowImgView.hidden = YES;
    }
}
@end
