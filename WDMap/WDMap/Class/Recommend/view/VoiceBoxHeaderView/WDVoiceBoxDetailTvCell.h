//
//  WDVoiceBoxDetailTvCell.h
//  WDMap
//
//  Created by wbb on 2021/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WDHotMusicModel;
@interface WDVoiceBoxDetailTvCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (nonatomic, strong) WDHotMusicModel * model;

@property (nonatomic, assign) BOOL isCorner;
@end

NS_ASSUME_NONNULL_END
