//
//  WDRoadTableViewCell.h
//  WDMap
//
//  Created by wbb on 2021/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN



@class WDRoadChildModel;
@interface WDRoadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, strong) WDRoadChildModel * model;
@end

NS_ASSUME_NONNULL_END
