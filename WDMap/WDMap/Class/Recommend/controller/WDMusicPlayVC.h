//
//  WDMusicPlayVC.h
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import "WDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class WDPlayMusicListModel;
@interface WDMusicPlayVC : WDBaseViewController


- (void)musicArray:(NSArray *)musicArr index:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
