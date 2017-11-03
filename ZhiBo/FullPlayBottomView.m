//
//  FullPlayBottomView.m
//  ZhiBo
//
//  Created by AntSailNet on 2017/10/25.
//  Copyright © 2017年 Befiv. All rights reserved.
//

#import "FullPlayBottomView.h"
#import <Masonry.h>

@implementation FullPlayBottomView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.3;
        UIButton *stopBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        stopBtn.backgroundColor = [UIColor redColor];
        [stopBtn addTarget:self action:@selector(stopButtonDidclicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:stopBtn];
        [stopBtn setTitle:@"停止" forState:UIControlStateNormal];
        [stopBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.top.equalTo(self).offset(10);
            make.size.mas_equalTo(CGSizeMake(50, 40));
        }];
        
        //输入框
//        UITextField *textField = [[UITextField alloc]init];
//        [self addSubview:textField];
//       // textField.inputAccessoryView = [[UIView alloc] init];
//        textField.layer.borderColor = [UIColor whiteColor].CGColor;
//        textField.layer.borderWidth = 1.0f;
//        textField.layer.masksToBounds = YES;
//        textField.layer.cornerRadius = 8;
        UIButton *button = [[UIButton alloc]init];
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = 1.0f;
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 8;
        [self addSubview:button];
        
        [button addTarget:self action:@selector(inputBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(300, 40));
        }];
        
        //全屏按钮
        UIButton *halfBtn = [[UIButton alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 10, 40, 40)];
        halfBtn.backgroundColor = [UIColor redColor];
        [halfBtn addTarget:self action:@selector(halfBtnDidclicked:) forControlEvents:UIControlEventTouchUpInside];
        [halfBtn setBackgroundImage:[UIImage imageNamed:@"quanping-2"] forState:UIControlStateNormal];
        [self addSubview:halfBtn];
        
        //弹幕开关button
        UIButton *danmuBtn  = [[UIButton alloc]init];
        [self addSubview:danmuBtn];
        [danmuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-150);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(40, 30));
        }];
        [danmuBtn setBackgroundImage:[UIImage imageNamed:@"danmu_open"] forState:UIControlStateNormal];
        [danmuBtn setBackgroundImage:[UIImage imageNamed:@"danmu_close"] forState:UIControlStateSelected];
        [danmuBtn addTarget:self action:@selector(danmuBtnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)stopButtonDidclicked:(UIButton *)sender{
    if (self.stopBtnBlock) {
        self.stopBtnBlock(sender.selected);
    }
    sender.selected = !sender.selected;
}

//弹幕开关
- (void)danmuBtnDidClicked:(UIButton *)danmuBtn{
    if (self.danmuBlock) {
        self.danmuBlock(danmuBtn.selected);
    }
    danmuBtn.selected = !danmuBtn.selected;
 
}

////输入框点击
- (void)inputBtnDidClicked:(UIButton  *)sender{
    if (self.inputBlock) {
        self.inputBlock();
    }
}
//半瓶按钮
- (void)halfBtnDidclicked:(UIButton *)sender{
    if (self.halfBtnBlock) {
        self.halfBtnBlock();
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
