//
//  WDMusicPlayView.h
//  WDMap
//
//  Created by wbb on 2021/3/1.
//

#import "WDBaseView.h"

NS_ASSUME_NONNULL_BEGIN
@class WDPlayMusicListModel;


@interface WDMusicPlayView : WDBaseView
@property (nonatomic, assign) MusicRunLoopType runLoopType;



+(instancetype)musicPlayView;
/// 释放单利类
- (void)clear;
- (void)currrentFenleiid:(NSString *)fenleiid currentMusicId:(NSString *)musicId;
/// 播放
- (void)play;
/// 暂停
- (void)pause;
@end

NS_ASSUME_NONNULL_END
