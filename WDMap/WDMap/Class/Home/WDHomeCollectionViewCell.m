//
//  WDHomeCollectionViewCell.m
//  WDMap
//
//  Created by wbb on 2021/1/31.
//

#import "WDHomeCollectionViewCell.h"

@implementation WDHomeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)indexPath:(NSInteger )index {
    
    NSString *indexStr = @"";
    if (kiPhone6) {
        indexStr = @"1";
    }else if(kiPhone6Plus) {
        indexStr = @"2";
    }else if(IS_IPHONE_Xs) {
        indexStr = @"3";
    }else if(IS_IPHONE_Xs_Max) {
        indexStr = @"4";
    }else if(IS_IPHONE_Xr) {
        indexStr = @"5";
    }else if(IS_IPHONE_12_Pro) {
        indexStr = @"6";
    }
    
    
    NSString *normalStr = @"";
    NSString *selectStr = @"";
    switch (index) {
        case 0:
        {
            normalStr = @"home_digit_normal";
            selectStr = @"home_digit_select";
        }
            break;
        case 1:
        {
            normalStr = @"home_voice_normal";
            selectStr = @"home_voice_select";
        }
            break;
        case 2:
        {
            normalStr = @"home_map_normal";
            selectStr = @"home_map_select";
        }
            break;
        case 3:
        {
            normalStr = @"home_dynamic_normal";
            selectStr = @"home_dynamic_select";
        }
            break;
        case 4:
        {
            normalStr = @"home_about_nomal";
            selectStr = @"home_about_select";
        }
            break;
        case 5:
        {
            normalStr = @"home_ar_normal";
            selectStr = @"home_ar_select";
        }
            break;
        default:
            break;
    }
    normalStr = [NSString stringWithFormat:@"%@%@",normalStr,indexStr];
    selectStr = [NSString stringWithFormat:@"%@%@",selectStr,indexStr];
    
    [self.clickBtn setBackgroundImage:[UIImage imageNamed:normalStr] forState:UIControlStateNormal];
    [self.clickBtn setBackgroundImage:[UIImage imageNamed:selectStr] forState:UIControlStateHighlighted];
}
- (IBAction)btnClick:(UIButton *)sender {
    if (self.buttnClickBlcok) {
        self.buttnClickBlcok();
    }
}
@end
