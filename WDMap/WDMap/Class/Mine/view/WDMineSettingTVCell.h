//
//  WDMineSettingTVCell.h
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDMineSettingTVCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;
@property (weak, nonatomic) IBOutlet UIImageView *goImgView;

- (void)cellForInfo:(NSArray *)dataArr atIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
