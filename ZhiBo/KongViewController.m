//
//  KongViewController.m
//  ZhiBo
//
//  Created by AntSailNet on 2017/11/1.
//  Copyright © 2017年 Befiv. All rights reserved.
//

#import "KongViewController.h"

@interface KongViewController ()<UIGestureRecognizerDelegate> //声明侧滑手势的delegate

@end

@implementation KongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor  whiteColor];
    //开启iOS7及以上的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
       // self.navigationController.interactivePopGestureRecognizer.delaysTouchesBegan=NO;
        
        
    }
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//UIGestureRecognizerDelegate 重写侧滑协议

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    return  YES;

    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
