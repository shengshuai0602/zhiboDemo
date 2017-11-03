//
//  ClearFullView.m
//  ZhiBo
//
//  Created by AntSailNet on 2017/11/3.
//  Copyright © 2017年 Befiv. All rights reserved.
//

#import "ClearFullView.h"
#import <MediaPlayer/MediaPlayer.h>
/*
 透明视图 ：全屏播放时通过滑动控制音量和屏幕亮度
 */
@interface ClearFullView ()<UIGestureRecognizerDelegate>
{
    CGPoint  _currentPoint;
}
///控制声音亮度手势
@property (nonatomic,strong) UIPanGestureRecognizer *panGR;
///控制音量的view
@property (nonatomic,strong) MPVolumeView *volumeView;

@end

@implementation ClearFullView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //给控制音量，亮度的透明视图添加滑动手势
        _panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
        [self addGestureRecognizer:_panGR];
        _panGR.delegate = self;
        //监听手机是横竖屏
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doRotateAction:) name:UIDeviceOrientationDidChangeNotification object:nil];

    }
    return self;
}

- (MPVolumeView *)volumeView{
    if (!_volumeView) {
        _volumeView = [[MPVolumeView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
        [self addSubview:_volumeView];
        self.volumeView.hidden = YES;    //隐藏音量控制视图
    }
    
    return _volumeView;
}

- (void)doRotateAction:(NSNotification *)notification {
    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
        self.hidden = YES;
    } else if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIDeviceOrientationLandscapeRight) {
        self.hidden = NO;
    }
}

#pragma mark -- 全屏手势获取起始点坐标
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _currentPoint = [[touches anyObject] locationInView:self];
}

///全屏控制手势
- (void)panGestureRecognizerAction:(UIPanGestureRecognizer *)sender{
    ///手势在_clearFullView上
    CGPoint velocity = [sender velocityInView:self];  //拖动的速度
    BOOL isVerticalGesture = fabs(velocity.x) < fabs(velocity.y);
    if (isVerticalGesture) {
        if (_currentPoint.x < self.frame.size.width/2) {
            //竖直方向移动
            if (velocity.y > 0) {
                //向下移动  亮度减小
                [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness - 0.01;
                NSLog(@"亮度减");
            }else{
                [UIScreen mainScreen].brightness = [UIScreen mainScreen].brightness + 0.01;
                NSLog(@"亮度+");
            }
        }else{
           
            if(velocity.y < 0){
                NSLog(@"增大声音");
                [self getVoumeViewSlider].value += 0.005;
                // [MPMusicPlayerController applicationMusicPlayer].volume += 0.005;
            }else{
                NSLog(@"减少声音");
               //   [MPMusicPlayerController applicationMusicPlayer].volume -= 0.005;
               [self getVoumeViewSlider].value -= 0.005;
            }
        }
    }
}

//获取音量控制视图的滑动控件
- (UISlider *) getVoumeViewSlider{
    for (UIView *view in [self.volumeView subviews]){
        if ([[view.class description] isEqualToString:@"MPVolumeSlider"]){
            return (UISlider*)view;
             break;
        }
    }
    return nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
