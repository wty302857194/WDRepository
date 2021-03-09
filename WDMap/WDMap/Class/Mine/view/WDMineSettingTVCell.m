//
//  WDMineSettingTVCell.m
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDMineSettingTVCell.h"

@implementation WDMineSettingTVCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLab.text = @"";
    self.detailLab.text = @"";
}

- (void)cellForInfo:(NSArray *)dataArr atIndex:(NSInteger)index {
    NSString *titleStr = dataArr[index];
    self.titleLab.text = titleStr;
    self.detailLab.hidden = YES;
    self.goImgView.hidden = NO;
    
    
    switch (index) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            self.detailLab.hidden = NO;
            self.goImgView.hidden = YES;
            self.detailLab.text = @"点击绑定";
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
}

@end
