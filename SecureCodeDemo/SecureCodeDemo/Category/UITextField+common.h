//
//  UITextField+common.h
//  xiaoanLoan
//
//  Created by YXY on 2017/6/6.
//  Copyright © 2017年 YXY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton *);

@interface UITextField (common)
/* 设置UITextField的LeftView为文本文案样式
 * 参数text：文案
 * 参数rect：位置
 * 参数font： 字体大小
 */
-(void)setUpLeftViewWithLabelText:(NSString *)text attributedText:(NSMutableAttributedString *)attributedText rect:(CGRect)rect font:(NSInteger)font;

-(void)setUpLeftViewWithLabelText:(NSString *)text rect:(CGRect)rect font:(NSInteger)font;

//设置左侧图片
-(void)setUpLeftViewWithImgName:(NSString *)imgName rect:(CGRect)rect;


/* 设置UITextField的rightView为密码明文按钮
 * 参数imageName：图片名称
 * 参数rect：位置
 * 参数state：按钮状态
 */
-(void)setUpRightViewWithButtonImageName:(NSString *)imageName rect:(CGRect)rect state:(UIControlState)state;

-(void)setUpRightViewTargetBtnWithButtonImageName:(NSString *)imageName rect:(CGRect)rect state:(UIControlState)state targetBlock:(ButtonBlock)targetBlock;
-(void)setUpRightImageViewWithImageName:(NSString *)imageName rect:(CGRect)rect backgroundViewRect:(CGRect)backgroundViewRect;
@end
