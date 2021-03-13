//
//  AppDelegate.m
//  WDMap
//
//  Created by wbb on 2021/1/29.
//

#import "AppDelegate.h"
#import "WDLoginViewController.h"
#import "WDBaseTabBarController.h"
#import "WDBaseNavigationController.h"
#import "WDHomeVC.h"
#import "WDLaunchViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    [[WDGlobal shareInstance] initData];
    
    [self setRootVC];
    
    [self.window makeKeyAndVisible];
    
    
    [QMapServices sharedServices].APIKey = WD_apiKey;
    /// 后台播放
    [self addAudioSession];
    /// 点击屏幕隐藏键盘
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [[UITextField appearance] setTintColor:hexColor(32FAE6)];

    return YES;
}

- (void)setRootVC {
    if (![WDGlobal isFirstComed]) {
        [self rootLunchVC];
    }else {
        if([WDGlobal isLogin]) {
            [self rootHomeVC];
        } else {
            [self rootLoginVC];
        }
    }
}

- (void)rootLoginVC {
    [WDGlobal removeMusicPlayView];
    WDBaseNavigationController *nav = [[WDBaseNavigationController alloc] initWithRootViewController:[[WDLoginViewController alloc] init]];
    
    self.window.rootViewController = nav;
}
- (void)rootTabBarVC:(NSInteger)index {
    [WDGlobal removeMusicPlayView];
    self.isRootTabBarVC = YES;
    WDBaseTabBarController *tabVC = [[WDBaseTabBarController alloc] init];
    [tabVC setSelectedIndex:index];
    self.window.rootViewController = tabVC;
}

- (void)rootHomeVC {
    [WDGlobal removeMusicPlayView];
    WDBaseNavigationController *nav = [[WDBaseNavigationController alloc] initWithRootViewController:[[WDHomeVC alloc] init]];
    self.window.rootViewController = nav;
}
- (void)rootLunchVC {
    self.window.rootViewController = [[WDLaunchViewController alloc] init];
}
/// 后台播放
- (void)addAudioSession {
    // 1.创建会话
      AVAudioSession *session = [AVAudioSession sharedInstance];
      
      // 2.设置类别为后台播放 AVAudioSessionCategoryPlayback: 类别为后台播放,该常量字符串在AVAudioSession.h中
      [session setCategory:AVAudioSessionCategoryPlayback error:nil];
      
      // 3.激活会话
      [session setActive:YES error:nil];
}

@end
