//
//  WDLoginViewController.m
//  WDDmap
//
//  Created by wbb on 2021/1/28.
//

#import "WDLoginViewController.h"
#import "WDRegisterViewController.h"
#import "WDForgetVC.h"
#import "WDWebViewController.h"
#import "WDWKWebVC.h"

static NSInteger const edge = 20;
static NSInteger const edge1 = 20;
#define KWidth self.view.frame.size.width - edge * 2
#define KHeight KWidth * 105 / 120
@interface WDLoginViewController ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *loginBtn;
@property (nonatomic, copy) NSString *phoneStr;
@property (nonatomic, copy) NSString *passwordStr;

@property (nonatomic, strong) UITextField *eyeTF;

@property (nonatomic, strong) UIButton * agreeBtn;
/// 隐私协议
@property (nonatomic, copy) NSString * urlString;
@end

@implementation WDLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.barTintColor = [UIColor blackColor]; // 把导航栏设为绿色
    //    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];



    [self initWithData];
    [self initUI];
        
}


- (void)initWithData {
    self.phoneStr = @"";
    self.passwordStr = @"";
}
#pragma mark - 设置视图frame
- (void)viewWillLayoutSubviews {

    self.backView.frame = CGRectMake(edge, self.view.safeAreaInsets.top + 50, KWidth, KHeight);

}
- (void)initUI {
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(edge, 50, KWidth, KHeight)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 10;
    [WDGlobal addShadow:backView];
    [self.view addSubview:backView];
    self.backView = backView;
    
//    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelBtn setImage:[UIImage imageNamed:@"login_cancel"] forState:UIControlStateNormal];
//    cancelBtn.frame = CGRectMake(CGRectGetWidth(backView.frame) - 40, 20, 20, 20);
//    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
//    [backView addSubview:cancelBtn];
    
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(edge1, 50, CGRectGetWidth(backView.frame), 30)];
    titleLab.text = @"登录文都坐标";
    titleLab.font = [UIFont systemFontOfSize:20];
    [backView addSubview:titleLab];
    
    float print_width = CGRectGetWidth(backView.frame) - edge1*2;
    float print_height = 50;
    UIView *phoneBackView1 = [[UIView alloc] initWithFrame:CGRectMake(edge1, CGRectGetMaxY(titleLab.frame) +20, print_width, 50)];
    [backView addSubview:phoneBackView1];
    
    {
        UIImageView *phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (50 - (16*22/16.f))/2.f, 16, 16*22/16.f)];
        phoneIcon.image = [UIImage imageNamed:@"login_phone"];
        [phoneBackView1 addSubview:phoneIcon];
        
        UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deletBtn setImage:[UIImage imageNamed:@"login_delet"] forState:UIControlStateNormal];
        deletBtn.frame = CGRectMake(CGRectGetWidth(phoneBackView1.frame) - 15, 17.5, 15, 15);
        [deletBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [phoneBackView1 addSubview:deletBtn];
        
        UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneIcon.frame) + 5, 10, CGRectGetMinX(deletBtn.frame) - CGRectGetMaxX(phoneIcon.frame) - 5, 30)];
        phoneTF.placeholder = @"请输入您的电话号";
        phoneTF.tag = 10;
        phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        phoneTF.font = [UIFont systemFontOfSize:15];
        [phoneTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [phoneBackView1 addSubview:phoneTF];
        
        UILabel *linelab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, print_height-1, print_width, 1)];
        linelab1.backgroundColor = main_color;
        [phoneBackView1 addSubview:linelab1];
    }
    
    UIView *phoneBackView2 = [[UIView alloc] initWithFrame:CGRectMake(edge1, CGRectGetMaxY(phoneBackView1.frame) +20, print_width, 50)];
    [backView addSubview:phoneBackView2];
    
    {
        UIImageView *phoneIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, (50 - (16*22/16.f))/2.f, 16, 16*22/16.f)];
        phoneIcon.image = [UIImage imageNamed:@"login_password"];
        [phoneBackView2 addSubview:phoneIcon];
        
        UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deletBtn setImage:[UIImage imageNamed:@"login_eye_open"] forState:UIControlStateNormal];
        [deletBtn setImage:[UIImage imageNamed:@"login_eye_close"] forState:UIControlStateSelected];
        deletBtn.frame = CGRectMake(CGRectGetWidth(phoneBackView2.frame) - 15, 17.5, 15, 15);
        [deletBtn addTarget:self action:@selector(eyeClick:) forControlEvents:UIControlEventTouchUpInside];
        [phoneBackView2 addSubview:deletBtn];
        
        UITextField *phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneIcon.frame) + 5, 10, CGRectGetMinX(deletBtn.frame) - CGRectGetMaxX(phoneIcon.frame) - 5, 30)];
        phoneTF.placeholder = @"请输入您的密码";
        phoneTF.secureTextEntry = YES;
        phoneTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        phoneTF.tag = 11;
        phoneTF.font = [UIFont systemFontOfSize:15];
        [phoneTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        [phoneBackView2 addSubview:phoneTF];
        self.eyeTF = phoneTF;
        
        UILabel *linelab1 = [[UILabel alloc] initWithFrame:CGRectMake(0, print_height-1, print_width, 1)];
        linelab1.backgroundColor = main_color;
        [phoneBackView2 addSubview:linelab1];
        
    }

    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [registBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    registBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [registBtn addTarget:self action:@selector(registClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:registBtn];
    [registBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(edge1);
        make.top.mas_equalTo(phoneBackView2.mas_bottom).offset(10);
    }];
    
    
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetBtn setTitleColor:hexColor(898989) forState:UIControlStateNormal];
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    [forgetBtn addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-edge1);
        make.top.mas_equalTo(phoneBackView2.mas_bottom).offset(10);
    }];
    
    
    
    
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.layer.cornerRadius = 24;
    loginBtn.enabled = NO;
    loginBtn.backgroundColor = hexColor(befff0);
    [loginBtn setBorderWidth:1];
    loginBtn.borderColor = main_color;
    [loginBtn setTitleColor:main_color forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:loginBtn];
    self.loginBtn = loginBtn;
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(phoneBackView2.mas_width);
        make.top.mas_equalTo(forgetBtn.mas_bottom).offset(20);
        make.centerX.equalTo(backView.mas_centerX);
        make.height.offset(48);
    }];
    

    
   
    
    UIButton *agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    [agreeBtn setImage:[UIImage imageNamed:@"login_no_choose"] forState:UIControlStateNormal];
    [agreeBtn setImage:[UIImage imageNamed:@"login_choose"] forState:UIControlStateSelected];

    [agreeBtn setTitleColor:hexColor(898989) forState:UIControlStateNormal];
    [agreeBtn setTitle:@"登录后表示你同意文都坐标的" forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.agreeBtn = agreeBtn;
    
    
    UIButton *privacyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    privacyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [privacyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [privacyBtn setTitle:@"<隐私政策>" forState:UIControlStateNormal];
    [privacyBtn addTarget:self action:@selector(pushWebVC) forControlEvents:UIControlEventTouchUpInside];

    
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[agreeBtn,privacyBtn]];
    stackView.distribution = UIStackViewDistributionFillProportionally;
    stackView.userInteractionEnabled = YES;
    stackView.alignment = UIStackViewAlignmentCenter;
    [backView addSubview:stackView];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(10);
        make.centerX.equalTo(backView.mas_centerX);
        make.height.offset(30);
    }];
    
    
    
    
    UILabel *tagLab = [[UILabel alloc] init];
    tagLab.text = @"你还可以用以下方式登录";
    tagLab.font = [UIFont systemFontOfSize:12];
    tagLab.textColor = [UIColor whiteColor];
    [self.view addSubview:tagLab];
    [tagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backView.mas_bottom).offset(20);
        make.centerX.equalTo(backView.mas_centerX);
    }];
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tagLab.mas_left).offset(-10);
        make.centerY.equalTo(tagLab.mas_centerY);
        make.height.offset(0.5);
        make.left.equalTo(backView.mas_left).offset(10);
    }];
    
    UILabel *line2 = [[UILabel alloc] init];
    line2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tagLab.mas_right).offset(10);
        make.centerY.equalTo(tagLab.mas_centerY);
        make.height.offset(0.5);
        make.right.equalTo(backView.mas_right).offset(-10);
    }];
    
    
    
    UIButton *wechatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [wechatBtn setBackgroundImage:[UIImage imageNamed:@"WeChat"] forState:UIControlStateNormal];
    [wechatBtn addTarget:self action:@selector(privacyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sinaBtn setBackgroundImage:[UIImage imageNamed:@"Sina"] forState:UIControlStateNormal];
    [sinaBtn addTarget:self action:@selector(privacyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqBtn setBackgroundImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    [qqBtn addTarget:self action:@selector(privacyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIStackView *shareStackView = [[UIStackView alloc] initWithArrangedSubviews:@[wechatBtn, qqBtn, sinaBtn]];
    shareStackView.axis = UILayoutConstraintAxisHorizontal;
    shareStackView.spacing = 40;
    shareStackView.userInteractionEnabled = YES;
    [self.view addSubview:shareStackView];
    [shareStackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tagLab.mas_bottom).offset(10);
        make.centerX.equalTo(backView.mas_centerX);
    }];
    [wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(50);
    }];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(50);
    }];
    [sinaBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(50);
    }];
}


#pragma mark - 事件
/// textfield
- (void)textChange:(UITextField *)textField {
    if(textField.tag == 10) {
        self.phoneStr = textField.text;
    }else {
        self.passwordStr = textField.text;
    }

    [self changeLoginBtnState];
}


//- (void)cancelClick {
//
//}
- (void)eyeClick:(UIButton *)btn {
    self.eyeTF.secureTextEntry = btn.selected;
    btn.selected = !btn.selected;
}
/// 注册
- (void)registClick {
    WDRegisterViewController *vc =[[WDRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 忘记密码
- (void)forgetClick {
    WDForgetVC *vc = [[WDForgetVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
// 去登陆
- (void)loginBtnClick {
    if (self.phoneStr.length<=0) {
        [MBProgressHUD promptMessage:@"请输入电话号" inView:self.view];
        return;
    }
    
    if (![WDGlobal isValidateMobile:self.phoneStr]) {
        [MBProgressHUD promptMessage:@"请输入正确的电话号" inView:self.view];
        return;
    }
    if (self.passwordStr.length<=0) {
        [MBProgressHUD promptMessage:@"请输入密码" inView:self.view];
        return;
    }
    if (!self.agreeBtn.isSelected) {
        [MBProgressHUD promptMessage:@"您未同意隐私政策" inView:self.view];
        return;
    }
    
    [self LoginRequestData];
}

- (void)agreeBtnClick:(UIButton *)btn {
    btn.selected = !btn.selected;
    NSLog(@"agreeBtnClick");
    
    [self changeLoginBtnState];
}
- (void)changeLoginBtnState {
    if (self.phoneStr.length>0 && self.passwordStr.length > 0 && self.agreeBtn.isSelected) {
        self.loginBtn.enabled = YES;
        self.loginBtn.backgroundColor = main_color;
        [self.loginBtn setBorderWidth:1];
        self.loginBtn.borderColor = [UIColor blackColor];
        [self.loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        self.loginBtn.enabled = NO;
        self.loginBtn.backgroundColor = hexColor(befff0);
        [self.loginBtn setBorderWidth:1];
        self.loginBtn.borderColor = main_color;
        [self.loginBtn setTitleColor:main_color forState:UIControlStateNormal];
    }
}

/// 隐私政策
- (void)privacyBtnClick {
    
}
- (void)pushWebVC {
    WDWKWebVC *vc = [[WDWKWebVC alloc] init];
    vc.navigationItem.title = @"隐私政策";
    vc.htmlString = @"https://wxdt.vqune.com/mobile/zcxy.html";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveUserInfo:(NSDictionary *)dic {
    NSString *idStr = [NSString stringWithFormat:@"%@",dic[@"id"]];
    NSString *mobileStr = [NSString stringWithFormat:@"%@",dic[@"mobileStr"]];
    NSString *user_nameStr = [NSString stringWithFormat:@"%@",dic[@"user_name"]];
    NSString *passwordStr = [NSString stringWithFormat:@"%@",dic[@"password"]];

    [WDUtil setInfo:idStr forKey:WD_USERID];
    [WDUtil setInfo:mobileStr forKey:WD_MOBILE];
    [WDUtil setInfo:user_nameStr forKey:WD_USERNAME];
    [WDUtil setInfo:passwordStr forKey:WD_PASSWORD];

}
#pragma mark - natework
- (void)LoginRequestData {
    NSDictionary *dic = @{
        @"mobile" : self.phoneStr?:@"",
        @"password" : self.passwordStr?:@""
    };
    [TYNetworkTool getRequest:WDLoginAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
            [self saveUserInfo:data[@"data"]];
            [kDelegate setRootVC];
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}

@end
