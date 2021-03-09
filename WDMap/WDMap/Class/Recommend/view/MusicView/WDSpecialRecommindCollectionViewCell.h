//
//  WDSpecialRecommindCollectionViewCell.h
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import <UIKit/UIKit.h>
#import "WDMusicModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WDSpecialRecommindCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) WDMusicAlbumModel * model;
@end

NS_ASSUME_NONNULL_END
