//
//  FullPlayBottomView.h
//  ZhiBo
//
//  Created by AntSailNet on 2017/10/25.
//  Copyright © 2017年 Befiv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^STOPBTNBLOCK)(BOOL isSelected);
typedef void(^HALFBTNBLOCKL)();
typedef void(^INPUTBLOCK)();   //点击输入框
typedef void(^DANMUBLOCK)(BOOL isSelected);

@interface FullPlayBottomView : UIView

@property (nonatomic,copy) STOPBTNBLOCK stopBtnBlock;

@property (nonatomic,copy) HALFBTNBLOCKL halfBtnBlock;

@property (nonatomic,copy) INPUTBLOCK inputBlock;
//管理弹幕
@property (nonatomic,copy) DANMUBLOCK danmuBlock;

@end
