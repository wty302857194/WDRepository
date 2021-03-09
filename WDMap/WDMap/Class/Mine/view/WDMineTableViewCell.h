//
//  WDMineTableViewCell.h
//  WDMap
//
//  Created by wbb on 2021/2/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^MoreBlock)(void);
@interface WDMineTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, copy) MoreBlock moreBlock;

- (void)cellForDataSource:(NSDictionary *)dic indexPath:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
