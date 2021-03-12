//
//  WDVerificationVC.m
//  WDMap
//
//  Created by wbb on 2021/1/30.
//

#import "WDVerificationVC.h"
#import "CodeInputView.h"
#import "WDWKWebVC.h"

static NSInteger const edge = 20;
#define KWidth self.view.frame.size.width - edge * 2

@interface WDVerificationVC ()
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *phoneLab;

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *currentTimeLab;

@property (nonatomic, assign) NSInteger time;

@property (nonatomic, strong) UIButton *registBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, copy) NSString *currentVerificationStr;
@property (nonatomic, copy) NSString *rightVerificationStr;


@property (nonatomic, strong) UIButton *agreeBtn;

@property(nonatomic,strong)CodeInputView * codeView;

@property(nonatomic,strong) UILabel *verificationLab;

@property(nonatomic,strong) UIStackView *stackView;

@property (nonatomic, copy) NSString *urlString;
@end

@implementation WDVerificationVC
- (void)dealloc {
    [self.timer invalidate];
    self.timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.time = 60;
    
    [self initUI];
    
    [self SendsmscodeRequestData];
}
- (void)addTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (self.time<=0) {
            self.timeLab.text = @"重发发送";
            self.currentTimeLab.text = @"";
            self.time = 60;
            self.timeLab.userInteractionEnabled = YES;
            [timer invalidate];
        }else {
            self.time--;
            self.currentTimeLab.text = [NSString stringWithFormat:@"%lds",(long)self.time];
            self.timeLab.userInteractionEnabled = NO;

        }
    }];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}
- (void)initUI {

    UIEdgeInsets insets = self.view.safeAreaInsets;

    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(edge, insets.top + 50, KWidth, 20)];
    titleLab.text = @"输入验证码";
    titleLab.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:titleLab];
    self.titleLab = titleLab;
    
    UILabel *verificationLab = [[UILabel alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(titleLab.frame) + 30, 150, 20)];
    verificationLab.text = @"验证码已发送至";
    verificationLab.textColor = hexColor(898989);
    verificationLab.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:verificationLab];
    self.verificationLab = verificationLab;
    
    UILabel *phoneLab = [[UILabel alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(verificationLab.frame)+10, 150, 20)];
    phoneLab.text = [NSString stringWithFormat:@"+86 %@",self.phoneStr];
//    phoneLab.textColor = hexColor(FAFAC8);
    phoneLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:phoneLab];
    self.phoneLab = phoneLab;
    
    UILabel *timeLab = [[UILabel alloc] init];
    timeLab.text = @"后重发";
    timeLab.textColor = hexColor(898989);
    timeLab.userInteractionEnabled = NO;
    [timeLab addTarget:self action:@selector(sendMesssage)];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:timeLab];
    self.timeLab = timeLab;
    [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-edge);
        make.centerY.equalTo(phoneLab);
    }];
    
    UILabel *currentTimeLab = [[UILabel alloc] init];
    currentTimeLab.text = [NSString stringWithFormat:@"%lds",(long)self.time];
    currentTimeLab.textColor = hexColor(f550cd);
    currentTimeLab.textAlignment = NSTextAlignmentRight;
    currentTimeLab.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:currentTimeLab];
    self.currentTimeLab = currentTimeLab;
    [currentTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(timeLab.mas_left).offset(-5);
        make.centerY.equalTo(phoneLab);
    }];
    
    
    
    
    [self.view addSubview:self.codeView];

    
    
    
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    registBtn.frame = CGRectMake(edge, CGRectGetMaxY(self.codeView.frame) + 30, self.view.width - 2*edge, 48);
    registBtn.enabled = NO;
    registBtn.backgroundColor = hexColor(befff0);
    [registBtn setBorderWidth:1];
    registBtn.borderColor = main_color;
    [registBtn setTitleColor:main_color forState:UIControlStateNormal];
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registBtn.layer.cornerRadius = 24;
    [registBtn addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registBtn];
    self.registBtn = registBtn;
    

    
   
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    [agreeBtn setImage:[UIImage imageNamed:@"regist_no_choose"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"regist_choose"] forState:UIControlStateSelected];

    [agreeBtn setTitleColor:hexColor(898989) forState:UIControlStateNormal];
    [agreeBtn setTitle:@"登录后表示你同意文都坐标的" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.agreeBtn = agreeBtn;
    
    UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    privacyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [privacyBtn setTitleColor:hexColor(000000) forState:UIControlStateNormal];
    [privacyBtn setTitle:@"<隐私政策>" forState:UIControlStateNormal];
    [privacyBtn addTarget:self action:@selector(pushWebVC) forControlEvents:UIControlEventTouchUpInside];


    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[agreeBtn,privacyBtn]];
    stackView.frame = CGRectMake((self.view.width-250)/2.f, CGRectGetMaxY(registBtn.frame) + 10, 250, 30);
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.userInteractionEnabled = YES;
    stackView.spacing = 0;
    stackView.alignment = UIStackViewAlignmentCenter;
    [self.view addSubview:stackView];
    self.stackView = stackView;
}
#pragma mark - 设置视图frame
- (void)viewWillLayoutSubviews {
    UIEdgeInsets insets = self.view.safeAreaInsets;
    self.titleLab.frame = CGRectMake(edge, insets.top + 50, KWidth, 20);
    self.verificationLab.frame = CGRectMake(edge, CGRectGetMaxY(self.titleLab.frame) + 30, 150, 20);
    self.phoneLab.frame = CGRectMake(edge, CGRectGetMaxY(self.verificationLab.frame)+10, 150, 20);
    self.timeLab.frame = CGRectMake(self.view.width - edge - 150, CGRectGetMaxY(self.verificationLab.frame)+10, 150, 20);
    self.codeView.frame = CGRectMake(0, CGRectGetMaxY(self.timeLab.frame) + 30, self.view.width, 50);
    self.registBtn.frame = CGRectMake(edge, CGRectGetMaxY(self.codeView.frame) + 30, self.view.width - 2*edge, 48);
    self.stackView.frame = CGRectMake((self.view.width-250)/2.f, CGRectGetMaxY(self.registBtn.frame) + 10, 250, 30);

}


#pragma mark - 事件

-(void)sendMesssage {
    [self SendsmscodeRequestData];
}
- (void)registBtnClick {

    if (![self.currentVerificationStr isEqualToString:self.rightVerificationStr]) {
        [MBProgressHUD promptMessage:@"请输入正确的验证码" inView:self.view];
        return;
    }
    if (!self.agreeBtn.isSelected) {
        [MBProgressHUD promptMessage:@"您未同意隐私政策" inView:self.view];
        return;
    }
    
    [self user_registerRequestData];
}
- (void)changeLoginBtnState {
    if (self.phoneStr.length>0 && self.passwordStr.length > 0 && self.agreeBtn.isSelected && [self.currentVerificationStr isEqualToString:self.rightVerificationStr]) {
        self.registBtn.enabled = YES;
        self.registBtn.backgroundColor = main_color;
        [self.registBtn setBorderWidth:1];
        self.registBtn.borderColor = [UIColor blackColor];
        [self.registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        self.registBtn.enabled = NO;
        self.registBtn.backgroundColor = hexColor(befff0);
        [self.registBtn setBorderWidth:1];
        self.registBtn.borderColor = main_color;
        [self.registBtn setTitleColor:main_color forState:UIControlStateNormal];
    }
}
- (void)agreeBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    [self changeLoginBtnState];
}
- (void)privacyBtnClick {
    NSLog(@"test");
}
- (void)pushWebVC {
    WDWKWebVC *vc = [[WDWKWebVC alloc] init];
    vc.navigationItem.title = @"隐私政策";
    vc.htmlString = @"https://wxdt.vqune.com/mobile/zcxy.html";
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - network
- (void)SendsmscodeRequestData {
    NSDictionary *dic = @{
        @"mobile" : self.phoneStr
    };
    [TYNetworkTool getRequest:WDSendsmscodeAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            self.rightVerificationStr = data[@"code"]?:@"";
            [self addTimer];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
#pragma mark - nateWork
/*
 action:user_register
 username：用户名（可为空）
 password：密码（可为空）
 mobile：手机号码
 openid：微信授权ID（可为空）
 avatar：头像（可为空）
 */
- (void)user_registerRequestData {
    NSDictionary *dic = @{
        @"username" : self.nameStr,
        @"password" : self.passwordStr,
        @"mobile" : self.phoneStr,
        @"openid" : @"",
        @"avatar" : @"",
    };
    [TYNetworkTool getRequest:WDUserRegisterAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            [self.navigationController popToRootViewControllerAnimated:NO];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}


#pragma mark - lazy
- (CodeInputView *)codeView {
    __weak typeof(self) selfWeak = self;
    if (!_codeView) {
        _codeView = [[CodeInputView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeLab.frame) + 30, self.view.width, 50) inputType:6 selectCodeBlock:^(NSString * code) {
            NSLog(@"code === %@",code);
            selfWeak.currentVerificationStr = code;
            if(code.length == 6) {
                if (![selfWeak.currentVerificationStr isEqualToString:selfWeak.rightVerificationStr]) {
                    [MBProgressHUD promptMessage:@"请输入正确的验证码" inView:selfWeak.view];
                    return;
                }
                [selfWeak changeLoginBtnState];
            }
            
            
        }];
    }
    return _codeView;
}
@end
