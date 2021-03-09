//
//  WDRoadDetailCell.h
//  WDMap
//
//  Created by wbb on 2021/2/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WDRoadjingdiandataModel;
@interface WDRoadDetailCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) WDRoadjingdiandataModel * model;
@end

NS_ASSUME_NONNULL_END
