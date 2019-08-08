//
//  SecureCodeTimerManager.m
//  PrivilegeGo
//
//  Created by YXY on 2019/3/28.
//  Copyright © 2019 Techwis. All rights reserved.
//
#define kMaxCountDownTime 60//倒计时时间，可自定义

#import "SecureCodeTimerManager.h"

@interface SecureCodeTimerManager ()
@property (nonatomic, assign) kCountDownType countDonwnType;
@property (nonatomic, nullable, strong) dispatch_source_t loginTimer;//登录界面倒计时timer
@property (nonatomic, nullable, strong) dispatch_source_t findPwdTimer;//找回密码界面倒计时timer
@property (nonatomic, nullable, strong) dispatch_source_t registerTimer;//注册界面倒计时timer
@property (nonatomic, nullable, strong) dispatch_source_t modifyPhoneTimer;//修改手机号界面倒计时timer
@property (nonatomic, nullable, strong) dispatch_source_t PwdManagerTimer;//忘记密码界面倒计时timer

@end

@implementation SecureCodeTimerManager

IMP_SINGLETON(SecureCodeTimerManager)

- (void)timerCountDownWithType:(kCountDownType)countDownType {
    
    
    self.countDonwnType = countDownType;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t tempTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(tempTimer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    
    NSTimeInterval seconds = kMaxCountDownTime;
    NSDate *endTime = [NSDate dateWithTimeIntervalSinceNow:seconds];
    
    dispatch_source_set_event_handler(tempTimer, ^{
        
        int interval = [endTime timeIntervalSinceNow];
        if (interval <= 0) {
            dispatch_source_cancel(tempTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([tempTimer isEqual:self.loginTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCountDownCompletedNotification object:@(interval)];
                } else if ([tempTimer isEqual:self.findPwdTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kFindPasswordCountDownCompletedNotification object:@(interval)];
                } else if ([tempTimer isEqual:self.registerTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterCountDownCompletedNotification object:@(interval)];
                } else if ([tempTimer isEqual:self.modifyPhoneTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kModifyPhoneCountDownCompletedNotification object:@(interval)];
                } else if ([tempTimer isEqual:self.PwdManagerTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPwdManagerCountDownCompletedNotification object:@(interval)];
                }
                
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([tempTimer isEqual:self.loginTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCountDownExecutingNotification object:@(interval)];
                } else if ([tempTimer isEqual:self.findPwdTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kFindPasswordCountDownExecutingNotification object:@(interval)];
                } else if ([tempTimer isEqual: self.registerTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterCountDownExecutingNotification object:@(interval)];
                } else if ([tempTimer isEqual:self.modifyPhoneTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kModifyPhoneCountDownExecutingNotification object:@(interval)];
                }else if ([tempTimer isEqual:self.PwdManagerTimer]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kPwdManagerCountDownExecutingNotification object:@(interval)];
                }
                
            });
        }
    });
    
    if (self.countDonwnType == kCountDownTypeLogin) {
        self.loginTimer = tempTimer;
    } else if (self.countDonwnType == kCountDownTypeFindPassword) {
        self.findPwdTimer = tempTimer;
    } else if (self.countDonwnType == kCountDownTypeRegister) {
        self.registerTimer = tempTimer;
    } else if (self.countDonwnType == kCountDownTypeModifyPhone) {
        self.modifyPhoneTimer = tempTimer;
    }else if (self.countDonwnType == kCountDownTypePwdManager) {
        self.PwdManagerTimer = tempTimer;
    }
    dispatch_resume(tempTimer);
}

- (void)cancelTimerWithType:(kCountDownType)countDownType {
    
    switch (countDownType) {
        case kCountDownTypeLogin:
            if (self.loginTimer) {
                dispatch_source_cancel(self.loginTimer);
                self.loginTimer = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:kLoginCountDownCompletedNotification object:nil];
            }
            
            break;
        case kCountDownTypeRegister:
            if (self.registerTimer) {
                dispatch_source_cancel(self.registerTimer);
                self.registerTimer = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:kRegisterCountDownCompletedNotification object:nil];
            }
            
            break;
        case kCountDownTypeModifyPhone:
            if (self.modifyPhoneTimer) {
                dispatch_source_cancel(self.modifyPhoneTimer);
                self.modifyPhoneTimer = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:kModifyPhoneCountDownCompletedNotification object:nil];
            }
            
            break;
        case kCountDownTypeFindPassword:
            if (self.findPwdTimer) {
                dispatch_source_cancel(self.findPwdTimer);
                self.findPwdTimer = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:kFindPasswordCountDownCompletedNotification object:nil];
            }
            
            break;
        case kCountDownTypePwdManager:
            if (self.PwdManagerTimer) {
                dispatch_source_cancel(self.PwdManagerTimer);
                self.PwdManagerTimer = nil;
                [[NSNotificationCenter defaultCenter] postNotificationName:kPwdManagerCountDownCompletedNotification object:nil];
            }
            break;
            
        default:
            break;
    }
}

@end
