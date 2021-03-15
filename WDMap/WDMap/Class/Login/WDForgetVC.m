//
//  WDForgetVC.m
//  WDMap
//
//  Created by wbb on 2021/1/31.
//

#import "WDForgetVC.h"

static NSInteger const edge = 20;

@interface WDForgetVC ()
@property (nonatomic, strong) UIButton *codeBtn;
@property (nonatomic, strong) UITextField *eyeTF;

@property (nonatomic, copy) NSString *nameStr;
@property (nonatomic, copy) NSString *phoneStr;
@property (nonatomic, copy) NSString *passwordStr;
@property (nonatomic, strong) UILabel *currentTimeLab;

@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WDForgetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.time = 60;
    
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.frame = CGRectMake(edge, 150, self.view.frame.size.width - edge * 2, 30);
    titleLab.text = @"忘记密码";
    titleLab.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:titleLab];
    
    UIView *nameBackView = [[UIView alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(titleLab.frame)+20, self.view.frame.size.width - edge * 2, 48)];
    nameBackView.backgroundColor = [UIColor whiteColor];
    [nameBackView setBorderWidth:1];
    nameBackView.borderColor = [UIColor blackColor];
    nameBackView.layer.cornerRadius = 24;
    [self.view addSubview:nameBackView];
    
    UITextField *nametf = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, CGRectGetWidth(nameBackView.frame)-20, 30)];
    nametf.placeholder = @"请输入您的号码";
    nametf.tag = 100;
    nametf.clearButtonMode = UITextFieldViewModeAlways;
    nametf.font = [UIFont systemFontOfSize:15];
    [nametf addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [nameBackView addSubview:nametf];
    
    
    UIView *nameBackView1 = [[UIView alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(nameBackView.frame) + 30, self.view.frame.size.width - edge * 2, 48)];
    nameBackView1.backgroundColor = [UIColor whiteColor];
    [nameBackView1 setBorderWidth:1];
    nameBackView1.borderColor = [UIColor blackColor];
    nameBackView1.backgroundColor = [UIColor whiteColor];
    nameBackView1.layer.cornerRadius = 24;
    [self.view addSubview:nameBackView1];
    
//    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(nameBackView1.width - 150-10, 12, 150, 30)];
//    time.text = @"";
//    time.textColor = hexColor(F550CD);
//    time.userInteractionEnabled = YES;
//    [time addTarget:self action:@selector(sendMesssage)];
//    time.textAlignment = NSTextAlignmentRight;
//    time.font = [UIFont systemFontOfSize:15];
//    [nameBackView1 addSubview:time];
//    self.currentTimeLab = timeLab;
    
    UILabel *timeLab = [[UILabel alloc] initWithFrame:CGRectMake(nameBackView1.width - 150-10, 9, 150, 30)];
    timeLab.text = @"获取验证码";
    timeLab.textColor = hexColor(F550CD);
    timeLab.userInteractionEnabled = YES;
    [timeLab addTarget:self action:@selector(sendMesssage)];
    timeLab.textAlignment = NSTextAlignmentRight;
    timeLab.font = [UIFont systemFontOfSize:15];
    [nameBackView1 addSubview:timeLab];
    self.timeLab = timeLab;
    
    UITextField *nametf1 = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, timeLab.x - 10, 30)];
    nametf1.placeholder = @"请输入验证码";
    nametf1.tag = 101;
    nametf1.font = [UIFont systemFontOfSize:15];
//    nametf1.clearButtonMode = UITextFieldViewModeWhileEditing;
    [nametf1 addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [nameBackView1 addSubview:nametf1];
    
    UIView *nameBackView2 = [[UIView alloc] initWithFrame:CGRectMake(edge, CGRectGetMaxY(nameBackView1.frame) + 30, self.view.frame.size.width - edge * 2, 48)];
    nameBackView2.backgroundColor = [UIColor whiteColor];
    [nameBackView2 setBorderWidth:1];
    nameBackView2.borderColor = [UIColor blackColor];
    nameBackView2.layer.cornerRadius = 24;
    [self.view addSubview:nameBackView2];
    
    UIButton *deletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deletBtn setImage:[UIImage imageNamed:@"login_eye_open"] forState:UIControlStateNormal];
    [deletBtn setImage:[UIImage imageNamed:@"login_eye_close"] forState:UIControlStateSelected];
    deletBtn.frame = CGRectMake(CGRectGetWidth(nameBackView2.frame) - 25, 16.5, 15, 15);
    [deletBtn addTarget:self action:@selector(eyeClick:) forControlEvents:UIControlEventTouchUpInside];
    [nameBackView2 addSubview:deletBtn];
    
    UITextField *nametf2 = [[UITextField alloc] initWithFrame:CGRectMake(10, 9, CGRectGetWidth(nameBackView.frame) - 20 - 15 - 10, 30)];
    nametf2.placeholder = @"请您重设密码";
    nametf2.secureTextEntry = YES;
    nametf2.tag = 103;
    nametf2.font = [UIFont systemFontOfSize:15];
    [nametf2 addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [nameBackView2 addSubview:nametf2];
    self.eyeTF = nametf2;
    
    
    
    UIButton *codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.backgroundColor = hexColor(befff0);
    [codeBtn setBorderWidth:1];
    codeBtn.borderColor = main_color;
    [codeBtn setTitleColor:main_color forState:UIControlStateNormal];
    [codeBtn setTitle:@"确认" forState:UIControlStateNormal];
    codeBtn.layer.cornerRadius = 24;
    codeBtn.enabled = NO;
    [codeBtn addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    
    self.codeBtn = codeBtn;

}
- (void)sendMesssage {
    [self addTimer];
}
- (void)addTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (self.time<=0) {
            self.timeLab.text = @"重发发送";
            [timer invalidate];
            self.timeLab.userInteractionEnabled = YES;

        }else {
            self.time--;
            self.timeLab.text = [NSString stringWithFormat:@"获取验证码%lds",(long)self.time];
            self.timeLab.userInteractionEnabled = NO;

        }
    }];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 设置视图frame
- (void)viewWillLayoutSubviews { /**
     layoutFrame.size.width 安全区域宽度
     layoutFrame.size.height 安全区域高度 */
    CGRect layoutFrame = self.view.safeAreaLayoutGuide.layoutFrame;
    NSLog(@"self.view - layoutFrame - %@", NSStringFromCGRect(layoutFrame)); /**
     inset.left 安全区域距离屏幕最左边的大小
     inset.right 安全区域距离屏幕最右边的大小
     inset.top 安全区域距离屏幕最上边的大小
     inset.bottom 安全区域距离屏幕最下边的大小 */
    UIEdgeInsets insets = self.view.safeAreaInsets;
    NSLog(@"self.view - insets - %@", NSStringFromUIEdgeInsets(insets));

    self.codeBtn.frame = CGRectMake(edge, self.view.frame.size.height - 20 -self.view.safeAreaInsets.bottom- 48, self.view.frame.size.width - edge * 2, 48);

}
- (void)textChange:(UITextField *)textField {
    if(textField.tag == 101) {
        self.phoneStr = textField.text;
    }else if(textField.tag == 102){
        self.passwordStr = textField.text;
    }else {
        self.nameStr = textField.text;
    }
    if (self.phoneStr.length>0 && self.passwordStr.length > 0 && self.nameStr.length > 0) {
        self.codeBtn.enabled = YES;
        self.codeBtn.backgroundColor = main_color;
        [self.codeBtn setBorderWidth:1];
        self.codeBtn.borderColor = [UIColor blackColor];
        [self.codeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }else {
        self.codeBtn.enabled = NO;
        self.codeBtn.backgroundColor = hexColor(befff0);
        [self.codeBtn setBorderWidth:1];
        self.codeBtn.borderColor = main_color;
        [self.codeBtn setTitleColor:main_color forState:UIControlStateNormal];
    }
}
- (void)getCode:(UIButton *)btn {
//    if (self.nameStr.length<=0) {
//        [MBProgressHUD promptMessage:@"请输入您的昵称" inView:self.view];
//        return;
//    }
//
//    if (self.phoneStr.length<=0) {
//        [MBProgressHUD promptMessage:@"请输入电话号" inView:self.view];
//        return;
//    }
//
//    if (![WDGlobal isValidateMobile:self.phoneStr]) {
//        [MBProgressHUD promptMessage:@"请输入正确的电话号" inView:self.view];
//        return;
//    }
//
//    if (self.passwordStr.length<=0) {
//        [MBProgressHUD promptMessage:@"请输入密码" inView:self.view];
//        return;
//    }
    
//    WDVerificationVC *vc = [[WDVerificationVC alloc] init];
//    vc.phoneStr = self.phoneStr;
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)eyeClick:(UIButton *)btn {
    self.eyeTF.secureTextEntry = btn.selected;
    btn.selected = !btn.selected;
}
/*
 action:czmima
 mobile：手机号码   （手机号码和用户ID必须传递其中一个）
 uid：用户ID   （手机号码和用户ID必须传递其中一个）
 pwd：密码

 */
- (void)czmimaRequestData {
    NSDictionary *dic = @{
        @"mobile" : self.phoneStr,
        @"uid" : [WDGlobal userID]
    };
    [TYNetworkTool getRequest:WDczmimaAPI parameters:dic successBlock:^(id  _Nonnull data, NSString * _Nonnull msg) {
        if ([data[@"status"] integerValue] == 1) {
        }else {
            [MBProgressHUD promptMessage:msg inView:self.view];
        }
    } failureBlock:^(NSString * _Nonnull description) {
        [MBProgressHUD promptMessage:description inView:self.view];
    }];
}
@end
