//
//  WDMusicMenuTvCell.h
//  WDMap
//
//  Created by wbb on 2021/2/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WDPlayMusicListModel;
typedef void(^DeleItemtBlock)(void);
@interface WDMusicMenuTvCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;
@property (weak, nonatomic) IBOutlet UILabel *namelab;
@property (weak, nonatomic) IBOutlet UILabel *userlab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic, strong) WDPlayMusicListModel *musicModel;
@property (nonatomic, assign) BOOL isChoose;

@property (nonatomic, copy) DeleItemtBlock deleItemtBlock;
@end

NS_ASSUME_NONNULL_END
