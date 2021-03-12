//
//  WDMineSettingVC.m
//  WDMap
//
//  Created by wbb on 2021/2/24.
//

#import "WDMineSettingVC.h"
#import "WDMineSettingTVCell.h"
#import "WDEditProfileVC.h"
#import "WDWifiVCTvC.h"
#import "WDWKWebVC.h"

@interface WDMineSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, copy) NSArray * dataArr;
@end

@implementation WDMineSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.tableView];
}

#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDMineSettingTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Identifier"];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"WDMineSettingTVCell" owner:nil options:nil].lastObject;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell cellForInfo:self.dataArr atIndex:indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            WDEditProfileVC *vc = [[WDEditProfileVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            WDWifiVCTvC *vc = [storyboard instantiateViewControllerWithIdentifier:@"WDWifiVCTvC"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            WDWKWebVC *vc = [[WDWKWebVC alloc] init];
            vc.navigationItem.title = @"关于文都";
            vc.htmlString = @"https://wxdt.vqune.com/mobile/guanyuwendu/show-1.html";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = main_background_color;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@"个人信息设置", @"手机号", @"通用", @"帮助与反馈", @"关于文都", @"退出登录"];
    }
    return _dataArr;
}
@end
