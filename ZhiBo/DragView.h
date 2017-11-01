//
//  DragView.h
//  ZhiBo
//
//  Created by AntSailNet on 2017/10/31.
//  Copyright © 2017年 Befiv. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TAPBLOCK)(NSString *playurl);

@interface DragView : UIView
//小视图在播放的视频流地址
@property (nonatomic,strong) NSString *playUrl;

@property (nonatomic,copy) TAPBLOCK tapBlock;

- (void)addPlayerWithurl:(NSString *)url;

- (void)dragViewHidden;

@end
