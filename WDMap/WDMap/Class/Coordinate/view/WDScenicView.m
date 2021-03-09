//
//  WDScenicView.m
//  WDMap
//
//  Created by wbb on 2021/2/3.
//

#import "WDScenicView.h"
#import "WDPaoMaView.h"
#import "WDScenicTableViewController.h"
#import "WDScenicModel.h"
#import "WDHotLineVC.h"
#import "WDVideoVC.h"

@interface WDScenicView()
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIView *shadeView;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *authorLab;
@property (weak, nonatomic) IBOutlet UILabel *sceneryLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *roadBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arImageView;
@property (weak, nonatomic) IBOutlet UIButton *clockBtn;
@property (weak, nonatomic) IBOutlet UIView *paomaBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutHeight;
@property (weak, nonatomic) IBOutlet UITextField *textFild;

@property (nonatomic, strong) WDPaoMaView * paomaView;
@property (nonatomic, strong) NSMutableArray * paoMaArr;
@property (nonatomic, copy) NSString * tfString;

@property (nonatomic, strong) WDRelevancePersonModel * personModel;
@end
@implementation WDScenicView

- (IBAction)tfChange:(UITextField *)sender {
    self.tfString = sender.text;
}

- (IBAction)deletClick:(UIButton *)sender {
    [self click];
}
- (IBAction)collectClick:(UIButton *)sender {
    [self User_shoucangRequestData];
}
- (IBAction)switchClick:(UIButton *)sender {
    if (!sender.isSelected) {
        if (!self.paomaView) {
            [self addPaoMaView];
        }
        self.paomaBackView.hidden = NO;
        self.layoutHeight.constant = 40;
    }else {
        [self removePaoMaView];
        self.paomaBackView.hidden = YES;
        self.layoutHeight.constant = 0;
        
    }
    
    
    sender.selected = !sender.selected;
}
- (IBAction)clockClick:(UIButton *)sender {
    [self User_dakaRequestData];
}
- (IBAction)roadClick:(UIButton *)sender {
    WDHotLineVC *vc = [[WDHotLineVC alloc] init];
    vc.model = self.model;
    vc.personModel = self.personModel;
    [[WDGlobal getCurrentViewController].navigationController pushViewController:vc animated:YES];
}
- (IBAction)sendMessageClick:(UIButton *)sender {
    if (self.tfString.length <= 0) {
        [MBProgressHUD promptMessage:@"请输入弹幕内容" inView:self];
        return;
    }
    
    [self User_danmuRequestData];
}
- (IBAction)detailClick:(UIButton *)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    WDScenicTableViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"WDScenicTableViewController"];
    vc.scenicModel = self.model;
    vc.userName = self.authorLab.text;
    [[WDGlobal getCurrentViewController].navigationController pushViewController:vc animated:YES];
}
- (void)click {
    if (self.touchHiddenBlock) {
        self.touchHiddenBlock();
    }
}
- (void)arClick {
    WDVideoVC *vc = [[WDVideoVC alloc] init];
    vc.urlString = self.model.shipin;
    [[WDGlobal getCurrentViewController].navigationController pushViewController:vc animated:YES];
}
- (void)removePaoMaView {
    [self.paomaView removeFromSuperview];
    self.paomaView = nil;
}
- (void)addPaoMaView {
    if (![self.paomaBackView.subviews containsObject:self.paomaView]) {
        self.paomaView = [WDPaoMaView paoMaViewWithList:self.paoMaArr];
        [self.paomaBackView addSubview:self.paomaView];
        [self.paomaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.offset(0);
        }];
    }
   
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.shadeView.backgroundColor = [UIColor colorWithHexColorString:@"000000" alpha:0.0];
    
    [self.shadeView addTarget:self action:@selector(click)];
    [self.arImageView addTarget:self action:@selector(arClick)];
    self.layoutHeight.constant = 0;
    
    self.paomaBackView.hidden = YES;
    self.paoMaArr = [NSMutableArray arrayWithCapacity:0];

    
}
- (void)layoutSubviews {
    [super layoutSubviews];

    [WDGlobal addCorners:self.backView];
}

#pragma mark - datasource
- (void)setModel:(WDScenicModel *)model {
    _model = model;
    self.sceneryLab.text = model.title?:@"";
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:model.img_url] placeholderImage:PLACE_HOLDER_IMAGE];
    self.addressLab.text = model.xiangxidizhi?:@"";
    self.moneyLab.text = model.canguanfeiyong?:@"";
    self.timeLab.text = model.kaifangshijian?:@"";
    if (model.shipin.length>0) {
        self.arImageView.hidden = NO;
    }else {
        self.arImageView.hidden = YES;
    }
    
    self.roadBtn.hidden = YES;
    if ([model.wenxuerexianshifouxianshi isEqualToString:@"1"]) {
        if (model.yinpin.length > 0) {
            self.roadBtn.hidden = NO;
        }
    }
    
    [self GetsfshoucangRequestData];
    [self GetguanlianrenwuRequestData];
    [self GetdanmuRequestData];
    [self GetsfxianluRequestData];
}
- (void)GetsfshoucangRequestData {
    NSDictionary *dic = @{
        @"openid" : @"",
        @"jdid" : self.model.ID,
        @"uid" : [WDGlobal userID]
    };
    [TYNetworkTool getRequest:WDGetsfshoucangAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            self.collectBtn.selected = YES;
        } else if ([data[@"status"] integerValue] == 0) {
            self.collectBtn.selected = NO;
        } else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
- (void)User_shoucangRequestData {
    NSDictionary *dic = @{
        @"openid" : @"",
        @"jdid" : self.model.ID,
        @"uid" : [WDGlobal userID]
    };
    [TYNetworkTool getRequest:WDUser_shoucangAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            [self GetsfshoucangRequestData];
        }
            
        [MBProgressHUD promptMessage:msg inView:self];
        
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
/// Getsfxianlu
- (void)GetsfxianluRequestData {
    NSDictionary *dic = @{
        @"jdid" : self.model.ID,
    };
    [TYNetworkTool getRequest:WDGetsfxianluAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 0) {
            [self.clockBtn removeFromSuperview];
        }else if ([data[@"status"] integerValue] == 1) {
            
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
/// 打卡：User_daka
- (void)User_dakaRequestData {
    NSDictionary *dic = @{
        @"openid" : @"",
        @"jdid" : self.model.ID,
        @"uid" : [WDGlobal userID]
    };
    [TYNetworkTool getRequest:WDUserDakaAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            [MBProgressHUD showDakaSuccess:self];
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}

/// 获取景点关联人物
- (void)GetguanlianrenwuRequestData {
    NSDictionary *dic = @{
        @"id" : self.model.ID,
    };
    [TYNetworkTool getRequest:WDGetguanlianrenwuAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray * arr = [WDRelevancePersonModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            NSString *personStr = @"";
            if (arr&&arr.count>0) {
                for (WDRelevancePersonModel *model in arr) {
                    if ([model.shifoutuijian isEqualToString:@"是"]) {
                        self.personModel = model;
                    }
                    personStr = [NSString stringWithFormat:@"%@ %@",personStr, model.xingming];
                }
            }
            self.authorLab.text = personStr;
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
/// Getdanmu
- (void)GetdanmuRequestData {
    NSDictionary *dic = @{
        @"id" : self.model.ID,
        @"pageSize" : @"9999",
        @"pageIndex" : @"0"
    };
    [TYNetworkTool getRequest:WDGetdanmuAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            [self.paoMaArr removeAllObjects];
            [self removePaoMaView];
            
            NSArray * arr = [NSArray arrayWithArray:data[@"data"]];
            [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dic = (NSDictionary *)obj;
                NSString *reply_content = dic[@"reply_content"]?:@"";
                if (reply_content.length>0) {
                    [self.paoMaArr addObject:dic[@"reply_content"]];
                }
            }];
            [self addPaoMaView];
        }else {
            [MBProgressHUD promptMessage:msg inView:self];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}
/// User_danmu
- (void)User_danmuRequestData {
    NSDictionary *dic = @{
        @"openid" : @"",
        @"jdid" : self.model.ID,
        @"uid" : [WDGlobal userID],
        @"content" : self.tfString
    };
    [TYNetworkTool getRequest:WDUserDanmuAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            [self GetdanmuRequestData];
        }
        [MBProgressHUD promptMessage:msg inView:self];
        
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self];
    }];
}

//- (WDPaoMaView *)paomaView {
//    if (!_paomaView) {
//        _paomaView = [WDPaoMaView paoMaViewWithList:self.paoMaArr];
//    }
//    return _paomaView;
//}
@end
