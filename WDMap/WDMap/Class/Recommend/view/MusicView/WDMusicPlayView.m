//
//  WDMusicPlayView.m
//  WDMap
//
//  Created by wbb on 2021/3/1.
//

#import "WDMusicPlayView.h"
#import "WDMusicModel.h"
#import <AVFoundation/AVFoundation.h>
#import "WDMusicMenuView.h"

@interface WDMusicPlayView ()
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *wordBackView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *menuBtn;
@property (weak, nonatomic) IBOutlet UIButton *lastBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIButton *loopBtn;

@property (nonatomic, strong) WDMusicMenuView * menuView;
/// 滑动scrollview
@property (nonatomic, strong) UIScrollView * scrollView;
/// 歌词
@property (nonatomic, strong) UILabel * wordLab;
/// 当前播放音乐的数据对象
@property (nonatomic, strong) WDPlayMusicListModel *model;
/// 音乐列表
@property (nonatomic, strong) NSMutableArray * musicArr;
/// 播放器
@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, strong) id timeObserve;
/// 音乐索引
@property (nonatomic, assign) NSInteger musicIndex;

/// 循环状态
@property (nonatomic, assign) NSInteger count;

/// 当前音乐ID
@property (nonatomic, copy) NSString * musicId;
/// 当前专辑ID
@property (nonatomic, copy) NSString *flid;

/// 判断播放下一首时，是否要让索引加1（1:不需要加1，0:加1）
@property (nonatomic, assign) BOOL isPlus;


@end

@implementation WDMusicPlayView
static dispatch_once_t onceToken;
static WDMusicPlayView *_playView = nil;
+ (instancetype)musicPlayView {
    dispatch_once(&onceToken, ^{
        _playView = [WDMusicPlayView shareInstance];
    });
    return _playView;
}
- (void)clear {
    onceToken = 0;
    _playView = nil;
}
- (void)dealloc {
    [self removeCurrentObserver];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.musicArr = [NSMutableArray arrayWithCapacity:0];
    [self.slider setThumbImage:[UIImage imageNamed:@"voice_box_slider"] forState:UIControlStateNormal];
    
    [self.slider addTarget:self action:@selector(sliderTouch:)];
    [self.slider addTarget:self action:@selector(playSliderValueChange:) forControlEvents:UIControlEventValueChanged];
        
    [self addSubview:self.menuView];
    self.menuView.hidden = YES;
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];


}
- (void)play {
    if(self.player) {
        [self.player play];
        [[NSNotificationCenter defaultCenter] postNotificationName:WD_CHANGEGIFIMAGR object:@(YES)];

    }

}
- (void)pause {
    if(self.player) {
        [self.player pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:WD_CHANGEGIFIMAGR object:@(NO)];

    }
    
}
- (void)currrentFenleiid:(NSString *)fenleiid currentMusicId:(NSString *)musicId {
    self.musicId = musicId;
    self.flid = fenleiid;
    
    /// 声音详细
    [self GetyinyuetoidRequestData];
    

}

#pragma mark - network
/// 声音详细
- (void)GetyinyuetoidRequestData {
    NSDictionary *dic = @{
        @"id" : self.musicId
    };
    [TYNetworkTool getRequest:WDGetyinyuetoidAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = [WDPlayMusicListModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (arr.count>0) {
                self.model = arr.firstObject;
                
                [self initWordView];
                    
                [self initPlayer];
                
                [self getyinyueRequestData];
                /// 增加音乐播放量
                [self addbofangliangRequestData];
                /// 获取用户声音是否收藏
                [self getyysfshoucangappRequestData];
            }else {
                [MBProgressHUD promptMessage:@"暂无数据～" inView:kWindow];
                if (self.player) {
                    [self removeCurrentObserver];
                    self.player = nil;
                }
                [WDGlobal removeMusicPlayView];
            }
            

        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
/// 音乐列表
- (void)getyinyueRequestData {
    NSDictionary *dic = @{
        @"pageSize": @"9999",
        @"fenleiid" : self.flid,
        @"pageIndex" : @(0),
    };
    [TYNetworkTool getRequest:WDGetyinyueAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            [self.musicArr removeAllObjects];
            WDGetyinyueModel *model = [WDGetyinyueModel mj_objectWithKeyValues:data];
            [self.musicArr addObjectsFromArray:model.playMusicList];
            
            [self reloadDatasource];
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
        
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}

- (void)reloadDatasource {
    if (self.musicArr.count>0) {
        self.menuBtn.enabled = YES;
        for (WDPlayMusicListModel *model in self.musicArr) {
            if ([self.model.ID isEqualToString:model.ID]) {
                self.musicIndex = [self.musicArr indexOfObject:model];

                break;
            }
        }
    }else {
        self.menuBtn.enabled = NO;
    }
}
/// 增加音乐播放量
- (void)addbofangliangRequestData {
    NSDictionary *dic = @{
        @"yyid" : self.model.ID
    };
    [TYNetworkTool getRequest:WDUser_addbofangliangAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
/// 获取用户声音是否收藏
- (void)getyysfshoucangappRequestData {
    NSDictionary *dic = @{
        @"yyid" : self.model.ID,
        @"uid" : [WDGlobal userID],
        @"openid" : @""
    };
    [TYNetworkTool getRequest:WDGetyysfshoucangappAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        
        if ([data[@"status"] integerValue] == 1) {/// 已收藏
            [self.saveBtn setImage:[UIImage imageNamed:@"voice_box_save_select"] forState:UIControlStateNormal];
        }else {
            [self.saveBtn setImage:[UIImage imageNamed:@"voice_box_save_nomal"] forState:UIControlStateNormal];

        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
/// 用户声音收藏/取消
- (void)getUser_yyshoucangappRequestData {
    NSDictionary *dic = @{
        @"yyid" : self.model.ID,
        @"uid" : [WDGlobal userID],
        @"openid" : @""
    };
    [TYNetworkTool getRequest:WDUser_yyshoucangappAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            
//            NSString *str = [NSString stringWithFormat:@"%@",data[@"msg"]];
//            if ([str isEqualToString:@"收藏成功！"]) {
//                [self.saveBtn setImage:[UIImage imageNamed:@"voice_box_save_select"] forState:UIControlStateNormal];
//            }else {
//                [self.saveBtn setImage:[UIImage imageNamed:@"voice_box_save_nomal"] forState:UIControlStateNormal];
//            }
            [self getyysfshoucangappRequestData];
            [MBProgressHUD promptMessage:data[@"msg"] inView:self];
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
/// 获取上一条下一条的数据
- (void)getprevandnextRequestData {
    NSDictionary *dic = @{
        @"yyid" : self.model.ID,
        @"flid" : self.model.category_id,
    };
    [TYNetworkTool getRequest:WDgetprevandnextAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}

- (void)initWithData {
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:self.model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
    
}
#pragma mark - 歌词
- (void)initWordView {
    if(self.scrollView) {
        [self.scrollView removeFromSuperview];
        self.scrollView = nil;
        self.wordLab = nil;
    }
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.wordBackView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.offset(0);
    }];
    self.scrollView = scrollView;

    
    UILabel *wordLab = [[UILabel alloc] init];
    wordLab.numberOfLines = 0;
    wordLab.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:wordLab];
    self.wordLab = wordLab;
    
    [self updateWorkLayout];

}
/// 更新音乐item显示
- (void)updateWorkLayout {
    [self initWithData];

    self.wordLab.attributedText = [WDGlobal getHtmlStringWithString:self.model.content];
    [self.wordLab sizeToFit];
    
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, self.wordLab.height);
    
    [self.wordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.offset(0);
        make.height.offset(self.wordLab.height);
        make.width.offset(kSCREEN_WIDTH - 40);
    }];
}
/// 6.用户拖动进度条，修改播放进度
- (void)playSliderValueChange:(UISlider *)sender
{
    //根据值计算时间
    float time = sender.value * CMTimeGetSeconds(self.player.currentItem.duration);
    //跳转到当前指定时间
    [self.player seekToTime:CMTimeMake(time, 1)];
}
- (void)sliderTouch:(UITapGestureRecognizer *)sender {
    // 1.获取当前点的位置
    CGPoint curPoint = [sender locationInView:sender.view];
    
    // 2.获取当前点与总进度的比例
    CGFloat ratio = curPoint.x / self.slider.bounds.size.width;
    
    // 3.更新当前播放器的播放时间
    float time = ratio * CMTimeGetSeconds(self.player.currentItem.duration);
    [self.player seekToTime:CMTimeMake(time, 1)];

    // 4.更新当前播放时间Label,总时长Label的信息和进度条信息,因为updateProgressInfo方法使用self.currentPlayer.currentTime值,所以必须在第3步执行完才能执行updateProgressInfo方法,如果顺序反之,则不行
    [self updateProgressInfo:time totalTime:CMTimeGetSeconds(self.player.currentItem.duration)];
}
/** 实时更新播放进度信息 */
- (void)updateProgressInfo:(NSTimeInterval)current totalTime:(NSTimeInterval)allTotal {
    // 1.更新当前音乐播放时间和当前音乐总时长
    self.currentTimeLab.text = [NSString stringWithTime:current];
    self.totalTimeLab.text = [NSString stringWithTime:allTotal];
    
    // 2.更新进度条信息
    self.slider.value = current / allTotal;
}
#pragma mark - 播放器
- (void)initPlayer {
    if (self.player) {
        [self removeCurrentObserver];
        self.player = nil;
    }
    NSURL * url  = [NSURL URLWithString:self.model.yinpin];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    AVPlayer * player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    self.player = player;
    
    
    [self addCurrentObserver];
}
/// 添加监听
- (void)addCurrentObserver{
    [self play];
    AVPlayerItem *songItem = self.player.currentItem;

    /// 监听播放进度
    kWEAK_SELF;
    id timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        float current = CMTimeGetSeconds(time);
        float allTotal = CMTimeGetSeconds(songItem.duration);
        kSTRONG_SELF;
        if (current) {
            [strongSelf updateProgressInfo:current totalTime:allTotal];
            
        }
    }];
    self.timeObserve = timeObserve;
    
    /// 监听AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];
    /// 媒体加载状态
    [songItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    /// TODO:数据缓冲状态
//    [songItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}

/// 播放完成通知
- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"播放完成");

    switch (self.runLoopType) {
        case MusicRunLoopShunXun:
        {
            [self playNextMusic];
        }
            break;
        case MusicRunLoopSuiji:
        {
            [self playSuijiMusic];
        }
            break;
        case MusicRunLoopDanqu:
        {
            AVPlayerItem *item = [notice object];

            [item seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
                [self play];
            }];
        }
            break;
        default:
            break;
    }
}
#pragma mark - TODO：暂时不做缓冲
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
//    AVPlayerItem * songItem = object;

    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                NSLog(@"KVO：未知状态，此时不能播放");
                break;
            case AVPlayerStatusReadyToPlay:
//                self.status = SUPlayStatusReadyToPlay;
                NSLog(@"KVO：准备完毕，可以播放");
                break;
            case AVPlayerStatusFailed:
                NSLog(@"KVO：加载失败，网络或者服务器出现问题");
                break;
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        
//        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
//        //本次缓冲的时间范围
//        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
//        //缓冲总长度
//        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
//        //音乐的总时间
//        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
//        //计算缓冲百分比例
//        NSTimeInterval scale = totalLoadTime/duration;
        //更新缓冲进度条
//        self.slider.value = scale;
    }
}

- (void)removeCurrentObserver {
    if (self.timeObserve) {
        [self.player removeTimeObserver:self.timeObserve];
        self.timeObserve = nil;
    }

    [self.player.currentItem removeObserver:self forKeyPath:@"status"];
        
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (IBAction)touchClick:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn == self.dismissBtn) {
        [WDGlobal hiddenMusicPlayView];
    }else if (btn == self.saveBtn) {/// 收藏
        [self getUser_yyshoucangappRequestData];
    }else if (btn == self.shareBtn) {/// 分享
        
    }else if (btn == self.menuBtn) {/// 菜单
        if (self.musicArr.count == 0) {
            [MBProgressHUD promptMessage:@"当前只有一首音乐" inView:self];
            return;
        }
        self.menuView.hidden = NO;
        [self.menuView musicArray:self.musicArr index:self.musicIndex];

    }else if (btn == self.lastBtn) {/// 上一曲
        
        [self playLastMusic];
    }else if (btn == self.playBtn) {/// 播放
        if (btn.isSelected) {
            [self play];
        }else {
            [self pause];
        }
        btn.selected = !btn.selected;

    }else if (btn == self.nextBtn) {/// 下一曲
        [self playNextMusic];
    }else if (btn == self.loopBtn) {/// 循环

        [self runLoopMusic];
    }
}
#pragma mark -  TODO：这里修改图片 /// 设置循环状态
- (void)runLoopMusic {
    if (self.musicArr.count == 0) {
        [MBProgressHUD promptMessage:@"当前只有一首音乐" inView:self];
        self.runLoopType = MusicRunLoopDanqu;
        return;
    }
    self.count ++;
    NSString *imgStr = @"";
    if (self.count % 3 == 0) {
        self.runLoopType = MusicRunLoopShunXun;
        imgStr = @"voice_box_shunxu";
    }else if (self.count % 3 == 1) {
        self.runLoopType = MusicRunLoopSuiji;
        imgStr = @"voice_box_suiji";
    }else if (self.count % 3 == 2) {
        self.runLoopType = MusicRunLoopDanqu;
        imgStr = @"voice_box_danqu";
    }
    
    [self.loopBtn setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];

    self.menuView.runLoopType = self.runLoopType;
}

/// 随机播放
- (void)playSuijiMusic {
    if (self.musicArr.count == 0) {
        [MBProgressHUD promptMessage:@"当前只有一首音乐" inView:self];
        return;
    }
    self.musicIndex = arc4random() % self.musicArr.count;
    [self changePlayItem];
}
/// 播放下一首
- (void)playNextMusic {
    if (self.musicArr.count == 0) {
        [MBProgressHUD promptMessage:@"当前只有一首音乐" inView:self];
        if (self.slider.value == 1) {
            [self pause];
        }
        return;
    }
    if (self.musicIndex >= self.musicArr.count-1) {
        [MBProgressHUD promptMessage:@"已经是最后一首了" inView:self];
        return;
    }
    
    if (!self.isPlus) {
        self.musicIndex ++;
    }
    self.isPlus = NO;
    
    [self changePlayItem];
}
/// 播放上一首
- (void)playLastMusic {
    if (self.musicArr.count == 0) {
        [MBProgressHUD promptMessage:@"当前只有一首音乐" inView:self];
        return;
    }
    if (self.musicIndex == 0) {
        [MBProgressHUD promptMessage:@"已经是第一首了" inView:self];
        return;
    }
    self.musicIndex --;
    [self changePlayItem];
}
/// 上一首 下一首
- (void)changePlayItem {
    [self removeCurrentObserver];

    if (self.musicIndex < self.musicArr.count) {
        self.model = self.musicArr[self.musicIndex];
    }
    NSURL *url  = [NSURL URLWithString:self.model.yinpin];
    AVPlayerItem *songItem = [[AVPlayerItem alloc]initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:songItem];
    
    [self.menuView musicArray:self.musicArr index:self.musicIndex];

    [self initWordView];
    [self addCurrentObserver];
    
    /// 增加音乐播放量
    [self addbofangliangRequestData];
    /// 获取用户声音是否收藏
    [self getyysfshoucangappRequestData];
}

#pragma mark - lazy
- (WDMusicMenuView *)menuView {
    if (!_menuView) {
        _menuView = [WDMusicMenuView shareInstance];
        kWEAK_SELF;
        _menuView.deletItemBlock = ^(NSInteger index, BOOL isAll) {
            if (isAll) {
                if (weakSelf.player) {
                    [weakSelf removeCurrentObserver];
                    weakSelf.player = nil;
                }
                [WDGlobal removeMusicPlayView];
            }else {
                
                [weakSelf.musicArr removeObjectAtIndex:index];
                if (weakSelf.musicIndex == index) {
                    weakSelf.isPlus = YES;
                    [weakSelf playNextMusic];
                }else if(weakSelf.musicIndex > index) {
                    weakSelf.musicIndex--;
                }

                [weakSelf.menuView musicArray:weakSelf.musicArr index:weakSelf.musicIndex];
            }
            
        };
        
        _menuView.selectItemBlock = ^(NSInteger index) {
            weakSelf.musicIndex = index;
            [weakSelf changePlayItem];
            [weakSelf.menuView musicArray:weakSelf.musicArr index:weakSelf.musicIndex];
        };
        
        _menuView.currentLoopBlock = ^{
            [weakSelf runLoopMusic];
        };
    }
    return _menuView;
}
@end
