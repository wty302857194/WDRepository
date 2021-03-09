//
//  WDHotLineVC.m
//  WDMap
//
//  Created by wbb on 2021/2/16.
//

#import "WDHotLineVC.h"
#import "WDScenicModel.h"
#import <AVFoundation/AVFoundation.h>

@interface WDHotLineVC ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *userLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIStackView *leftStack;
@property (weak, nonatomic) IBOutlet UIStackView *rightStack;
@property (weak, nonatomic) IBOutlet UIStackView *middleStack;
@property (nonatomic, strong) AVPlayer * player;
@end

@implementation WDHotLineVC
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[WDMusicPlayView musicPlayView] play];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"文学热线";
    self.middleStack.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    [self.leftStack addTarget:self action:@selector(leftClick)];
    [self.rightStack addTarget:self action:@selector(rightClick)];
    [self.middleStack addTarget:self action:@selector(rightClick)];
    
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:self.personModel.touxiang] placeholderImage:PLACE_HOLDER_IMAGE];
    self.userLab.text = self.personModel.xingming;

}
- (void)leftClick {
    [self initPlayer];
    
    self.leftStack.hidden = YES;
    self.rightStack.hidden = YES;
    self.middleStack.hidden = NO;
}
- (void)rightClick {
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)setModel:(WDScenicModel *)model {
//    _model = model;
//    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.jingdiantouxiang] placeholderImage:PLACE_HOLDER_IMAGE];
//
//}
//- (void)setUserName:(NSString *)userName {
//    self.userLab.text = userName;
//
//}
#pragma mark - 播放器
- (void)initPlayer {
    if (self.model.yinpin.length == 0) {
        [MBProgressHUD promptMessage:@"暂无音频资源" inView:self.view];
        return;
    }
    
    [[WDMusicPlayView musicPlayView] pause];
    
    NSURL * url  = [NSURL URLWithString:self.model.yinpin];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:url];
    AVPlayer * player = [[AVPlayer alloc]initWithPlayerItem:songItem];
    self.player = player;
    [player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:songItem];

}
/// 播放完成通知
- (void)playbackFinished:(NSNotification *)notice {
    NSLog(@"播放完成");
    [[WDMusicPlayView musicPlayView] play];
}

@end
