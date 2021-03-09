//
//  WDAlbumTableViewCell.h
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WDPlayMusicListModel;
@interface WDAlbumTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *indexLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentlab;

@property (nonatomic, strong) WDPlayMusicListModel * model;
@end

NS_ASSUME_NONNULL_END
