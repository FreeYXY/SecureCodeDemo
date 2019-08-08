//
//  LoginVC.m
//  AnTrader
//  登录
//  Created by YXY on 2018/12/17.
//  Copyright © 2018 Techwis. All rights reserved.
//

#import "LoginVC.h"
#import "RegisterVC.h"
#import "UITextField+common.h"
#import "NSString+Additions.h"
#import <Masonry.h>
#import <ReactiveObjC.h>
#import "SecureCodeTimerManager.h"

@interface LoginVC ()<UITextFieldDelegate>
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UITextField *phoneNumTF;
@property (nonatomic,strong) UITextField *passwordTF;
@property (nonatomic,strong) UIButton *secureBtn;
@property (nonatomic,strong) UILabel *phoneTipLabel;
@property (nonatomic,strong) UILabel *passwordTipLabel;
@end

#define  KSectionHeight  48


@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTimerCountDownExecutingWithTimeOut:) name:kLoginCountDownExecutingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTimerCountDownCompleted) name:kLoginCountDownCompletedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGRAction:)];
    [self.view addGestureRecognizer:tapGR];
    [self setupView];
}

-(void)tapGRAction:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}
-(void)setupView{
    
    NSInteger leftspace = 28;
    NSInteger tipFontSize = 12;
    NSInteger tipSpace = 5;

    UITextField *phoneNumTF = [[UITextField alloc]init];
    self.phoneNumTF = phoneNumTF;
    phoneNumTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumTF.keyboardType = UIKeyboardTypeDefault;
    phoneNumTF.font = [UIFont systemFontOfSize:14];
    phoneNumTF.attributedPlaceholder = [self placeholderAttributesStr:@"请输入手机号"];
    phoneNumTF.tag = 210;
    phoneNumTF.delegate = self;
    phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneNumTF];
    [phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(leftspace);
        make.right.equalTo(self.view).offset(-leftspace);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(KSectionHeight);
    }];
    [phoneNumTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        // 限制手机号11位
        if (x.length > 11) {
            phoneNumTF.text = [x substringToIndex:11];
        }
    }];
    
    UIView *topLine = [[UIView alloc]init];
    topLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumTF.mas_bottom);
        make.left.right.mas_equalTo(phoneNumTF);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *phoneTipLabel = [[UILabel alloc]init];
    self.phoneTipLabel = phoneTipLabel;
    phoneTipLabel.hidden = YES;
    phoneTipLabel.textColor = [UIColor grayColor];
    phoneTipLabel.font = [UIFont systemFontOfSize:tipFontSize];
    phoneTipLabel.text = @"手机号";
    [self.view addSubview: phoneTipLabel];
    [phoneTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(phoneNumTF.mas_top).offset(tipSpace);
        make.left.equalTo(phoneNumTF);
    }];
    
    UITextField *passwordTF = [[UITextField alloc]init];
    self.passwordTF = passwordTF;
   
    if (@available(iOS 11.0, *)) {
        passwordTF.textContentType = UITextContentTypePassword;
    } else {
        // Fallback on earlier versions
    }
    passwordTF.tag = 220;
    passwordTF.font = [UIFont systemFontOfSize:14];
    passwordTF.delegate = self;
    passwordTF.secureTextEntry = YES;
    passwordTF.keyboardType = UIKeyboardTypeDefault;
    passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTF.attributedPlaceholder = [self placeholderAttributesStr:@"请输入验证码"];;
    [self.view addSubview:passwordTF];
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(phoneNumTF);
        make.right.equalTo(phoneNumTF).offset(-100);
        make.top.equalTo(topLine.mas_bottom).offset(38);
        make.height.mas_equalTo(phoneNumTF);
    }];
    [passwordTF.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        if (x.length > 6) {
            passwordTF.text = [x substringToIndex:6];
        }
    }];
    
    
    UIButton *secureBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.secureBtn = secureBtn;
    [secureBtn setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [secureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    secureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    @weakify(self)
    [[secureBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self.view endEditing:YES];
        secureBtn.enabled = NO;
        [[SecureCodeTimerManager sharedInstance] timerCountDownWithType:kCountDownTypeLogin];
        // 获取验证码网络请求
        [self secureCodeRequest];
    }];
    [self.view addSubview:secureBtn];
    [secureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-leftspace);
        make.centerY.mas_equalTo(passwordTF);
    }];
    
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:bottomLine];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordTF.mas_bottom);
        make.left.right.mas_equalTo(topLine);
        make.height.mas_equalTo(0.5);
    }];
    
    UILabel *passwordTipLabel = [[UILabel alloc]init];
    self.passwordTipLabel = passwordTipLabel;
    passwordTipLabel.hidden = YES;
    passwordTipLabel.textColor = [UIColor grayColor];
    passwordTipLabel.font = [UIFont systemFontOfSize:tipFontSize];
    passwordTipLabel.text = @"验证码";
    [self.view addSubview: passwordTipLabel];
    [passwordTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(passwordTF.mas_top).offset(tipSpace);
        make.left.equalTo(topLine);
    }];
    
    CGRect leftImgRect = CGRectMake(0, 0, 30, 22);
    [self.phoneNumTF setUpLeftViewWithImgName:@"icon_phone_num" rect:leftImgRect];
    [self.passwordTF setUpLeftViewWithImgName:@"icon_security_lock" rect:leftImgRect];
    UIButton *registerBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [registerBtn setTitle:@"申请注册" forState:(UIControlStateNormal)];
    registerBtn.titleLabel.font = [UIFont systemFontOfSize:tipFontSize];
    [registerBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [[registerBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        RegisterVC *registerVC = [[RegisterVC alloc]init];
        [self.navigationController pushViewController:registerVC animated:YES];
    }];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomLine).offset(3);
        make.top.equalTo(bottomLine.mas_bottom).offset(11);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.loginBtn = loginBtn;
    loginBtn.layer.cornerRadius = 24;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.enabled = NO;
    [loginBtn setTitle:@"登录" forState:(UIControlStateNormal)];
    loginBtn.backgroundColor = [UIColor blueColor];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [[loginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[SecureCodeTimerManager sharedInstance] cancelTimerWithType:kCountDownTypeLogin];
    }];
    
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-leftspace);
        make.left.mas_equalTo(leftspace);
        make.top.equalTo(registerBtn.mas_bottom).offset(18);
        make.height.mas_equalTo(KSectionHeight);
    }];
    
    UILabel *tipLabel = [[UILabel alloc]init];
    tipLabel.textColor = [UIColor redColor];
    tipLabel.font = [UIFont systemFontOfSize:12];
    tipLabel.text = @"请先输入手机号，再点击获取验证码";
    [self.view addSubview: tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginBtn.mas_bottom).offset(20);
        make.centerX.equalTo(self.view);
    }];
    
    RAC(secureBtn,enabled) = [RACSignal combineLatest:@[phoneNumTF.rac_textSignal] reduce:^id _Nonnull{
         return @(phoneNumTF.text.length == 11);
    }];

    RAC(loginBtn,enabled) = [RACSignal combineLatest:@[phoneNumTF.rac_textSignal,passwordTF.rac_textSignal] reduce:^id _Nonnull(NSString * phoneNum, NSString * password){
        return @(phoneNum.length == 11 && password.length==6);
    }];
    RAC(loginBtn, backgroundColor) = [RACSignal combineLatest:@[phoneNumTF.rac_textSignal, passwordTF.rac_textSignal] reduce:^id _Nullable(NSString * phoneNum, NSString * password){
        return (phoneNum.length == 11 && password.length==6 ) ? [UIColor blueColor] :[UIColor grayColor];
    }];
    
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
       UITextField * tf = (UITextField *)x.first;
        if (tf.tag == 210) {
            phoneTipLabel.hidden = NO;
        }else if (tf.tag == 220){
            passwordTipLabel.hidden = NO;
        }
    }];
    [[self rac_signalForSelector:@selector(textFieldDidEndEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        UITextField * tf = (UITextField *)x.first;
        if (tf.tag == 210) {
            phoneTipLabel.hidden = YES;
        }else if (tf.tag == 220){
            passwordTipLabel.hidden = YES;
        }
    }];
}

- (void)appWillEnterForegroundNotification{
    UIApplication*   app = [UIApplication sharedApplication];
    __block    UIBackgroundTaskIdentifier bgTask;
    //申请一个后台执行的任务 大概10分钟 如果时间更长的话需要借助默认音频等
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid){
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
}

#pragma mark - NSNotification 处理倒计时事件
- (void)loginTimerCountDownExecutingWithTimeOut:(NSNotification *)notification {
    self.secureBtn.enabled = NO;
    NSInteger timeOut = [notification.object integerValue];
    [self.secureBtn setTitle: [NSString stringWithFormat:@"%lds",(long)timeOut] forState:(UIControlStateNormal)];
    [self.secureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

- (void)loginTimerCountDownCompleted {
    self.secureBtn.enabled = YES;
    [self.secureBtn setTitle:  @"重新获取" forState:(UIControlStateNormal)];
    [self.secureBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
}

#pragma mark - 获取验证码请求
-(void)secureCodeRequest{
    // 请求结束后 停止定时器
    [[SecureCodeTimerManager sharedInstance] cancelTimerWithType:kCountDownTypeLogin];
}

-(NSAttributedString *)placeholderAttributesStr:(NSString *)str{
    NSAttributedString *att = [[NSAttributedString alloc]initWithString:str attributes:@{NSForegroundColorAttributeName:[UIColor grayColor]}];
    return att;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
