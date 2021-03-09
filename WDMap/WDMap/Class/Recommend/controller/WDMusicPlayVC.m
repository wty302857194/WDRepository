//
//  WDMusicPlayVC.m
//  WDMap
//
//  Created by wbb on 2021/2/18.
//

#import "WDMusicPlayVC.h"
#import "WDMusicModel.h"
#import <AVFoundation/AVFoundation.h>
#import "WDMusicMenuView.h"

//static NSInteger const cell_height = 40;
@interface WDMusicPlayVC ()
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
@property (nonatomic, copy) NSArray * musicArr;
/// 播放器
@property (nonatomic, strong) AVPlayer * player;

@property (nonatomic, strong) id timeObserve;
/// 音乐索引
@property (nonatomic, assign) NSInteger musicIndex;

/// 是否单曲循环
@property (nonatomic, assign) BOOL isLoop;
@end

@implementation WDMusicPlayVC
- (void)dealloc {
    [self removeCurrentObserver];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.slider setThumbImage:[UIImage imageNamed:@"voice_box_slider"] forState:UIControlStateNormal];
    
    [self.slider addTarget:self action:@selector(sliderTouch:)];
    [self.slider addTarget:self action:@selector(playSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self initWordView];
    [self initPlayer];
}
- (void)musicArray:(NSArray *)musicArr index:(NSInteger)index {
    self.musicArr = musicArr;
    self.model = musicArr[index];
    self.musicIndex = index;
}

- (void)initWithData {
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:self.model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
    
}
#pragma mark - 歌词
- (void)initWordView {
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
    [self initWithData];

}
/// 更新音乐item显示
- (void)updateWorkLayout {
    self.wordLab.attributedText = [WDGlobal getHtmlStringWithString:self.model.content];
    [self.wordLab sizeToFit];
    
    self.scrollView.contentSize = CGSizeMake(kSCREEN_WIDTH, self.wordLab.height);
    
    [self.wordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.offset(0);
        make.height.offset(self.wordLab.height);
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
    
    NSURL * url  = [NSURL URLWithString:self.model.yinpin];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    AVPlayer * player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    self.player = player;
    
    
    [self addCurrentObserver];
}
/// 添加监听
- (void)addCurrentObserver{
    [self.player play];
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
    if (self.loopBtn.isSelected) {
        AVPlayerItem*item = [notice object];

        [item seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [self.player play];
        }];
        
    }else {
        [self playNextMusic];

    }
}
#pragma mark - TODO：暂时不做缓冲
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    AVPlayerItem * songItem = object;

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
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (btn == self.saveBtn) {/// 收藏
        
    }else if (btn == self.shareBtn) {/// 分享
        
    }else if (btn == self.menuBtn) {/// 菜单
        self.menuView.hidden = NO;
        [self.menuView musicArray:self.musicArr index:self.musicIndex];

    }else if (btn == self.lastBtn) {/// 上一曲
        
        [self playLastMusic];
    }else if (btn == self.playBtn) {/// 播放
        if (btn.isSelected) {
            [self.player play];
        }else {
            [self.player pause];
        }
        btn.selected = !btn.selected;

    }else if (btn == self.nextBtn) {/// 下一曲
        [self playNextMusic];
    }else if (btn == self.loopBtn) {/// 循环
        btn.selected = !btn.selected;
    }
}
- (void)playNextMusic {
    if (self.musicIndex == self.musicArr.count) {
        [MBProgressHUD promptMessage:@"已经是最后一首了" inView:self.view];
        return;
    }
    self.musicIndex ++;
    [self changePlayItem];
}
- (void)playLastMusic {
    if (self.musicIndex == 0) {
        [MBProgressHUD promptMessage:@"已经是第一首了" inView:self.view];
        return;
    }
    self.musicIndex --;
    [self changePlayItem];
}
/// 上一首 下一首
- (void)changePlayItem {
    [self removeCurrentObserver];

    self.model = self.musicArr[self.musicIndex];
    NSURL *url  = [NSURL URLWithString:self.model.yinpin];
    AVPlayerItem *songItem = [[AVPlayerItem alloc]initWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:songItem];
    
    [self.menuView musicArray:self.musicArr index:self.musicIndex];

    [self updateWorkLayout];
    [self addCurrentObserver];
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataArr.count;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Identifier"];
//
//        UILabel *lab = [[UILabel alloc] init];
//        lab.textAlignment = NSTextAlignmentCenter;
//        lab.font = [UIFont systemFontOfSize:15];
//        lab.textColor = hexColor(898989);
//        lab.tag = indexPath.row + 1000;
//        [cell.contentView addSubview:lab];
//        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(cell.contentView.mas_centerX);
//            make.centerY.equalTo(cell.contentView.mas_centerY);
//
//        }];
//    }
//    UILabel *lab = [cell.contentView viewWithTag:indexPath.row+1000];
//    if (self.dataArr.count>indexPath.row) {
//        lab.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
//    }
//    return cell;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return cell_height;
//}

#pragma mark - lazy
- (WDMusicMenuView *)menuView {
    if (!_menuView) {
        _menuView = [WDMusicMenuView shareInstance];
        [self.view addSubview:_menuView];
        [_menuView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
    return _menuView;
}
@end
