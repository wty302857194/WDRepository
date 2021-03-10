//
//  WDVideoVC.m
//  WDMap
//
//  Created by wbb on 2021/3/4.
//

#import "WDVideoVC.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVPlayerViewController.h>

@interface WDVideoVC ()
@property (weak, nonatomic) IBOutlet UIView *playerBackView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLab;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *quanPingBtn;

@property (nonatomic, strong) id timeObserve;
@property (nonatomic, strong) AVPlayerLayer *playLayer;
@property (nonatomic, strong) AVPlayer *player;

@end

@implementation WDVideoVC
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[WDMusicPlayView musicPlayView] play];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"3D坐标";
    self.view.backgroundColor = [UIColor blackColor];
    self.currentTimeLab.text = @"00:00";
    self.totalTimeLab.text = @"00:00";
    
    [self.slider setThumbImage:[UIImage imageNamed:@"voice_box_slider"] forState:UIControlStateNormal];
    [self.slider addTarget:self action:@selector(sliderTouch:)];
    [self.slider addTarget:self action:@selector(playSliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
    [self initPlayer];
}
- (void)viewDidAppear:(BOOL)animated {
    [self playState:YES];
}
- (IBAction)playClick:(UIButton *)sender {
    
    [self playState:sender.isSelected];
        
}

- (void)playState:(BOOL)isPlay {
    if (isPlay) {
        [self play];
    }else {
        [self pause];
    }
    self.playBtn.selected = !isPlay;
}
- (IBAction)quanpingClick:(UIButton *)sender {
    NSString *webVideoPath = self.urlString;
    NSURL *webVideoUrl = [NSURL URLWithString:webVideoPath];
    //步骤2：创建AVPlayer
    AVPlayer *avPlayer = [[AVPlayer alloc] initWithURL:webVideoUrl];
    //步骤3：使用AVPlayer创建AVPlayerViewController，并跳转播放界面
    AVPlayerViewController *avPlayerVC =[[AVPlayerViewController alloc] init];
    avPlayerVC.player = avPlayer;
    [self presentViewController:avPlayerVC animated:YES completion:^{
        [avPlayer play];
        [self playState:NO];
    }];
}
/// 6.用户拖动进度条，修改播放进度
- (void)playSliderValueChange:(UISlider *)sender
{
    //根据值计算时间
    float time = sender.value * CMTimeGetSeconds(self.player.currentItem.duration);
    //跳转到当前指定时间
    [self.player seekToTime:CMTimeMake(time, 1)];
    [self.player play];
}
- (void)sliderTouch:(UITapGestureRecognizer *)sender {
    // 1.获取当前点的位置
    CGPoint curPoint = [sender locationInView:sender.view];
    
    // 2.获取当前点与总进度的比例
    CGFloat ratio = curPoint.x / self.slider.bounds.size.width;
    
    // 3.更新当前播放器的播放时间
    float time = ratio * CMTimeGetSeconds(self.player.currentItem.duration);
    [self.player seekToTime:CMTimeMake(time, 1)];
    [self.player play];
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
    
    [TYNetworkTool monitorNetWorking:^(WDNetWorkStatus status) {
        if (status == ReachableViaWWAN) {
            if ([WDGlobal isSelectWiFi]) {
                [MBProgressHUD promptMessage:@"当前不是Wi-Fi环境，若要播放请到设置-通用中设置" inView:kWindow];
                return;
            }
        }else if (status == ReachableViaWiFi) {
            
        }else {
            [MBProgressHUD promptMessage:@"当前网络无效" inView:kWindow];
            return;
        }
    }];
    
    if (self.urlString.length == 0) {
        [MBProgressHUD promptMessage:@"暂无视频资源" inView:self.view];
        return;
    }
    
    [[WDMusicPlayView musicPlayView] pause];

    NSURL * url  = [NSURL URLWithString:self.urlString];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    AVPlayer * player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    self.player = player;
    
    AVPlayerLayer *playLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [self.playerBackView.layer addSublayer:playLayer];
    self.playLayer = playLayer;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];

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
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.playLayer.frame = self.playerBackView.bounds;
}
/// 播放完成通知
- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"播放完成");

    [self playState:YES];
}

- (void)play {
    if (self.slider.value == 1) {
        [self.player.currentItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [self.player play];
        }];
    }else {
        [self.player play];
    }
    
    [[WDMusicPlayView musicPlayView] pause];

}
- (void)pause {
    [self.player pause];
    [[WDMusicPlayView musicPlayView] play];
}
@end
