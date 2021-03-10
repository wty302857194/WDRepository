//
//  WDWifiVCTvC.m
//  WDMap
//
//  Created by wbb on 2021/3/9.
//

#import "WDWifiVCTvC.h"

@interface WDWifiVCTvC ()
@property (weak, nonatomic) IBOutlet UILabel *huancunLab;

@end

@implementation WDWifiVCTvC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = main_background_color;
    self.tableView.backgroundColor = main_background_color;
    [self getCacheSize];
}
- (IBAction)chooseWifi:(UIButton *)sender {
    
    [WDUtil setInfo:@(sender.selected) forKey:WD_SELECTWIFI];
    sender.selected = !sender.selected;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        
        [self tapAvatar];
        
    }
}
- (void)tapAvatar {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要清除缓存？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cleanCache];
    }];
    
    
    [alert addAction:camera];
    [alert addAction:album];
    
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)getCacheSize{
    //得到缓存路径
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager * manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    //首先判断是否存在缓存文件
    if ([manager fileExistsAtPath:path]) {
        NSArray * childFile = [manager subpathsAtPath:path];
        for (NSString * fileName in childFile) {
            //缓存文件绝对路径
            NSString * absolutPath = [path stringByAppendingPathComponent:fileName];
            size = size + [manager attributesOfItemAtPath:absolutPath error:nil].fileSize;
        }
        //计算sdwebimage的缓存和系统缓存总和
        size = size + [[SDImageCache sharedImageCache] totalDiskSize];
    }
    NSString *cacheStr = [self fileSizeWithInterge:size];

    self.huancunLab.text = cacheStr;
}

-(void)cleanCache{
    
    [MBProgressHUD promptMessage:@"正在清理缓存" inView:kWindow];
    //获取缓存路径
    NSString * path = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSFileManager * manager = [NSFileManager defaultManager];
    //判断是否存在缓存文件
    if ([manager fileExistsAtPath:path]) {
        NSArray * childFile = [manager subpathsAtPath:path];
        //逐个删除缓存文件
        for (NSString *fileName in childFile) {
            NSString * absolutPat = [path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:absolutPat error:nil];
        }
        //删除sdwebimage的缓存
        [[SDImageCache sharedImageCache] clearMemory];
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            [MBProgressHUD hideHUDForView:kWindow animated:YES];
        }];
    }
    //这里是又调用了得到缓存文件大小的方法，是因为不确定是否删除了所有的缓存，所以要计算一遍，展示出来
    [self getCacheSize];
}
- (NSString *)fileSizeWithInterge:(NSInteger)size {
      // 1k = 1024, 1m = 1024k
      if (size < 1024) { //小于1k
          return [NSString stringWithFormat:@"%ldB",(long)size];

      } else if (size < 1024 * 1024) { //小于1M
          CGFloat cFloat = size / 1024;
          return [NSString stringWithFormat:@"%.1fK",cFloat];

      } else if (size < 1024 * 1024 * 1024) { //小于1G
          CGFloat cFloat = size / (1024 * 1024);
          return [NSString stringWithFormat:@"%.1fM",cFloat];
      } else { //大于1G
          CGFloat cFloat = size / (1024 * 1024 * 1024);
          return [NSString stringWithFormat:@"%.1fG",cFloat];
      }
}
@end
