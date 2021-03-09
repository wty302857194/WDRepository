//
//  WDHistoryCvCell.h
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WDHistoryCvCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
