//
//  ViewController.m
//  SecureCodeDemo
//
//  Created by YXY on 2019/3/29.
//  Copyright © 2019 Techwis. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import <ReactiveObjC.h>
#import "LoginVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *loginBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [loginBtn setTitle:@"跳转登录" forState:(UIControlStateNormal)];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    loginBtn.backgroundColor = [UIColor blueColor];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [[loginBtn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        LoginVC *vc = [[LoginVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 40));
        make.center.equalTo(self.view);
    }];

}



@end
