//
//  SecureCodeTimerManager.h
//  PrivilegeGo
//
//  Created by YXY on 2019/3/28.
//  Copyright © 2019 Techwis. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kLoginCountDownCompletedNotification            @"kLoginCountDownCompletedNotification"
#define kFindPasswordCountDownCompletedNotification     @"kFindPasswordCountDownCompletedNotification"
#define kRegisterCountDownCompletedNotification         @"kRegisterCountDownCompletedNotification"
#define kModifyPhoneCountDownCompletedNotification      @"kModifyPhoneCountDownCompletedNotification"
#define kPwdManagerCountDownCompletedNotification        @"kPwdManagerCountDownCompletedNotification"

#define kLoginCountDownExecutingNotification            @"kLoginCountDownExecutingNotification"
#define kFindPasswordCountDownExecutingNotification     @"kFindPasswordCountDownExecutingNotification"
#define kRegisterCountDownExecutingNotification         @"kRegisterCountDownExecutingNotification"
#define kModifyPhoneCountDownExecutingNotification      @"kModifyPhoneCountDownExecutingNotification"
#define kPwdManagerCountDownExecutingNotification        @"kPwdManagerCountDownExecutingNotification"


#undef    DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef    IMP_SINGLETON
#define IMP_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static __class * __singleton__; \
static dispatch_once_t onceToken; \
dispatch_once( &onceToken, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, kCountDownType) {
    kCountDownTypeLogin,
    kCountDownTypeFindPassword,
    kCountDownTypeRegister,
    kCountDownTypeModifyPhone,
    kCountDownTypePwdManager,
    
};

@interface SecureCodeTimerManager : NSObject

DEF_SINGLETON(SecureCodeTimerManager)
- (void)timerCountDownWithType:(kCountDownType)countDownType;
- (void)cancelTimerWithType:(kCountDownType)countDownType;
@end

NS_ASSUME_NONNULL_END
