//
//  SomeButtonView.m
//  ZhiBo
//
//  Created by AntSailNet on 2017/10/25.
//  Copyright © 2017年 Befiv. All rights reserved.
//

#import "SomeButtonView.h"
#import "RCDLiveKitCommonDefine.h"

@implementation SomeButtonView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self  firstBtn];
        [self secondBtn];
        [self thirdBtn];
    }
    return self;
}

- (UIButton *)firstBtn{
    if (!_firstBtn) {
        _firstBtn  = [[UIButton alloc]init];
        [self addAndSetButton:_firstBtn WithTitle:@"直播间"];
        [_firstBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(SCREEN_WIDTH/3);
        }];
      
    }
    return _firstBtn;
}
- (UIButton *)secondBtn{
    if (!_secondBtn) {
        _secondBtn = [[UIButton alloc]init];
        [self addAndSetButton:_secondBtn WithTitle:@"私聊"];
        [_secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_firstBtn.mas_right);
            make.centerY.height.width.width.equalTo(_firstBtn);
        }];
    }
    return _secondBtn;
}

- (UIButton *)thirdBtn{
    if (!_thirdBtn) {
        _thirdBtn = [[UIButton alloc]init];
        [self addAndSetButton:_thirdBtn WithTitle:@"排行榜"];
        [_thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_secondBtn.mas_right);
            make.centerY.width.height.equalTo(_secondBtn);
        }];
    }
    return _thirdBtn;
}

//添加并设置button
- (void)addAndSetButton:(UIButton *)button WithTitle:(NSString *)title{
    [self addSubview:button];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
