//
//  UITextField+common.m
//  xiaoanLoan
//
//  Created by YXY on 2017/6/6.
//  Copyright © 2017年 YXY. All rights reserved.
//

#import "UITextField+common.h"

@interface UIView (common)
@property(nonatomic,copy) ButtonBlock targetBlock;

@end

@implementation UITextField (common)

-(void)setUpLeftViewWithLabelText:(NSString *)text attributedText:(NSMutableAttributedString *)attributedText rect:(CGRect)rect font:(NSInteger)font{
    
    UILabel *labelText = [[UILabel alloc]initWithFrame:rect];
    labelText.text = text;
    labelText.attributedText = attributedText;
    labelText.font = [UIFont systemFontOfSize:font];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = labelText;
}

-(void)setUpLeftViewWithLabelText:(NSString *)text rect:(CGRect)rect font:(NSInteger)font{
    
    UILabel *labelText = [[UILabel alloc]initWithFrame:rect];
    labelText.text = text;
    labelText.textColor = [UIColor grayColor];
    labelText.font = [UIFont systemFontOfSize:font];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = labelText;    
}

-(void)setUpLeftViewWithImgName:(NSString *)imgName rect:(CGRect)rect{
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:rect];
    imgV.contentMode = UIViewContentModeLeft;
//    UIImageView *imgV = [[UIImageView alloc]init];

    imgV.image = [UIImage imageNamed:imgName];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = imgV;
}

-(void)setUpRightViewWithButtonImageName:(NSString *)imageName rect:(CGRect)rect state:(UIControlState)state{
    
    // 设置密码明文按钮
    UIButton *secureEnableBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    secureEnableBtn.frame = rect;
    [secureEnableBtn setImage: [UIImage imageNamed:imageName] forState:state] ;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = secureEnableBtn;
   // 密码明文控制
    [secureEnableBtn addTarget:self action:@selector(secureEnableBtnDidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
}


-(void)setUpRightImageViewWithImageName:(NSString *)imageName rect:(CGRect)rect backgroundViewRect:(CGRect)backgroundViewRect{
    // 设置密码明文按钮
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageName]];
    imageView.frame = rect;
    self.rightViewMode = UITextFieldViewModeAlways;
    UIView *backgroundView = [[UIView alloc]init];
    if (CGRectIsNull(backgroundViewRect)) {
        backgroundView.frame = CGRectMake(0, 0, 30, 35);
    }else{
        backgroundView.frame = backgroundViewRect;
    }
    backgroundView.backgroundColor = [UIColor clearColor];
    backgroundView.layer.cornerRadius = 10;
    backgroundView.layer.masksToBounds = YES;
    [backgroundView addSubview:imageView];
    self.rightView = backgroundView;
}

-(void)setUpRightViewTargetBtnWithButtonImageName:(NSString *)imageName rect:(CGRect)rect state:(UIControlState)state targetBlock:(ButtonBlock)targetBlock{
    UIButton *targetBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    targetBtn.frame = rect;
    [targetBtn setImage: [UIImage imageNamed:imageName] forState:state] ;
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = targetBtn;
    [targetBtn addTarget:self action:@selector(targetBtnDidClicked:) forControlEvents:(UIControlEventTouchUpInside)];
}
-(void)targetBtnDidClicked:(UIButton *)sender{
    if (self.targetBlock) {
        self.targetBlock(sender);
    }
}

#pragma mark- 设置密码明文控制
-(void)secureEnableBtnDidClicked:(UIButton *)sender {
   
    NSString *imageName = ((sender.selected = !sender.selected) ? @"icon_secure_visible" :@"icon_secure_close");
    UITextField * secure = (UITextField *)sender.superview;
    secure.secureTextEntry = sender.selected ? NO : YES;
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

}
@end
