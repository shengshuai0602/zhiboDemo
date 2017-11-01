//
//  DragView.m
//  ZhiBo
//
//  Created by AntSailNet on 2017/10/31.
//  Copyright © 2017年 Befiv. All rights reserved.
//

#import "DragView.h"
#import "RCDLiveKitCommonDefine.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "PlayViewController.h"

@interface DragView ()
@property (nonatomic,strong) IJKFFMoviePlayerController *player;
@end

@implementation DragView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = RGBACOLOR(0, 0, 0, 0.5);
        UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGRDidAction:)];
        [self addGestureRecognizer:panGR];
        //添加点击手势
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGRDidAction:)
                                         ];
        [self addGestureRecognizer:tapGR];
    }
    return self;
}
//点击手势响应方法
- (void) tapGRDidAction:(UITapGestureRecognizer *)tapGR{
    if (self.tapBlock) {
        self.tapBlock(_playUrl);
    }
}
//拖动手势
- (void)panGRDidAction:(UIPanGestureRecognizer *)panGR{
    
    CGPoint translation = [panGR translationInView:self];
    CGFloat centerX=panGR.view.center.x+ translation.x;
    panGR.view.center=CGPointMake(centerX,panGR.view.center.y+ translation.y);
    [panGR setTranslation:CGPointZero inView:self];
    //设置移动的区域
    // Bound movement into parent bounds
    float halfx = CGRectGetMidX(self.bounds);
    CGPoint newcenter = panGR.view.center;
    newcenter.x = MAX(halfx, newcenter.x);
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy, newcenter.y);
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
    
    // Set new location
    self.center = newcenter;
    
}

#pragma mark -- 视频播放器
- (void)addPlayerWithurl:(NSString *)url{
    _playUrl = url;   //将播放链接复制全局变量 便于传值
    // 创建player
    //bilibili 播放器
    IJKFFOptions *options = [IJKFFOptions optionsByDefault]; //使用默认配置
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url] withOptions:options]; //初始化播放器，播放在线视频或直播(RTMP)
    //准备播放 （哔哩哔哩）
    [self.player prepareToPlay];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeFill; //缩放模式
    self.player.shouldAutoplay = YES; //开启自动播放
    self.autoresizesSubviews = YES;
    [self addSubview:self.player.view];
}

- (void)dragViewHidden{
    //销毁播放器
    [self.player shutdown];
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIViewController *)getViewController{
    //获取当前view的superView对应的控制器
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    
    return nil;

}
@end
