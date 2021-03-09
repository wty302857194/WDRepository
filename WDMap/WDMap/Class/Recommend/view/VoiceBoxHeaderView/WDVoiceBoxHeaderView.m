//
//  WDVoiceBoxHeaderView.m
//  WDMap
//
//  Created by wbb on 2021/2/19.
//

#import "WDVoiceBoxHeaderView.h"
#import "SDCycleScrollView.h"
#import "WDFavouriteMusicVC.h"
#import "WDSpecialRecommendVC.h"

@interface WDVoiceBoxHeaderView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end
@implementation WDVoiceBoxHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = hexColor(efefef);
        [self initUI];
        [self getsyhzbannerRequest];
    }
    return self;
}
- (void)getsyhzbannerRequest {
    [TYNetworkTool getRequest:WDGetsyhzbannerAPI parameters:@{} successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            NSArray *arr = [NSArray arrayWithArray:data[@"data"]];
            NSMutableArray *imgUrlStrArr = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dic in arr) {
                [imgUrlStrArr addObject:dic[@"img_url"]];
            }
            
            self.cycleScrollView.imageURLStringsGroup = imgUrlStrArr;
        }else {
            [MBProgressHUD promptMessage:msg inView:[WDGlobal getCurrentViewController].view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:[WDGlobal getCurrentViewController].view];
    }];
}
- (void)initUI {
    
    CGFloat sd_edge = 14;
    CGFloat sd_wdith = self.width - sd_edge * 2;
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(sd_edge, 20, sd_wdith, sd_wdith * 48 /121.f) delegate:self placeholderImage:[UIImage imageNamed:@""]];
    [WDGlobal addShadow:cycleScrollView];
    [WDGlobal addCorners:cycleScrollView emunType:WDAllState cornerNum:10];
    [self addSubview:cycleScrollView];
    self.cycleScrollView = cycleScrollView;
    
    UIView *leftView = [[UIView alloc] init];
    leftView.backgroundColor = [UIColor whiteColor];
    [leftView addTarget:self action:@selector(listionClick)];
    [WDGlobal addShadow:leftView];
    [self addSubview:leftView];
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cycleScrollView.mas_left);
        make.top.equalTo(cycleScrollView.mas_bottom).offset(14);
        make.width.offset((sd_wdith - sd_edge)/2.f);
        make.height.equalTo(leftView.mas_width).multipliedBy(65/165.f);
    }];
    
    {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_box_album"]];
        [leftView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
        }];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"特别推荐";
        [leftView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(10);
            make.bottom.equalTo(imgView.mas_centerY).offset(0);
        }];
        
        UILabel *taskLab = [[UILabel alloc] init];
        taskLab.text = @"听听看";
        taskLab.textColor = hexColor(898989);
        taskLab.font = [UIFont systemFontOfSize:13];
        [leftView addSubview:taskLab];
        [taskLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(10);
            make.top.equalTo(titleLab.mas_bottom).offset(5);
        }];
    }
    
    UIView *rightView = [[UIView alloc] init];
    rightView.backgroundColor = [UIColor whiteColor];
    [rightView addTarget:self action:@selector(favouriteClick)];
    [WDGlobal addShadow:rightView];
    [self addSubview:rightView];
    [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cycleScrollView.mas_right);
        make.top.equalTo(cycleScrollView.mas_bottom).offset(14);
        make.width.offset((sd_wdith - sd_edge)/2.f);
        make.height.equalTo(leftView.mas_width).multipliedBy(65/165.f);
    }];
    {
        
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice_box_favourite"]];
        [rightView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.offset(0);
        }];
        
        UILabel *titleLab = [[UILabel alloc] init];
        titleLab.text = @"我的喜欢";
        [rightView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(10);
            make.bottom.equalTo(imgView.mas_centerY).offset(0);
        }];
        
        UILabel *taskLab = [[UILabel alloc] init];
        taskLab.text = @"继续听";
        taskLab.textColor = hexColor(898989);
        taskLab.font = [UIFont systemFontOfSize:13];
        [rightView addSubview:taskLab];
        [taskLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(10);
            make.top.equalTo(titleLab.mas_bottom).offset(5);
        }];
    }
}
- (void)listionClick {
    WDSpecialRecommendVC *vc = [[WDSpecialRecommendVC alloc] init];
    [[WDGlobal getCurrentViewController].navigationController pushViewController:vc animated:YES];
}
- (void)favouriteClick {
    WDFavouriteMusicVC *vc = [[WDFavouriteMusicVC alloc] init];
    [[WDGlobal getCurrentViewController].navigationController pushViewController:vc animated:YES];
}
@end
