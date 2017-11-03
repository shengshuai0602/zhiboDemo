//
//  RootViewController.m
//  ZhiBo
//
//  Created by AntSailNet on 2017/10/23.
//  Copyright © 2017年 Befiv. All rights reserved.
//

#import "RootViewController.h"
#import "PlayViewController.h"
#import <MBProgressHUD.h>
#import "AFNetworking.h"
#import <CommonCrypto/CommonDigest.h>
#import "DragView.h"
#import "KongViewController.h"
#import <HYBLoopScrollView/HYBLoopScrollView.h>

#import "DSCacheManager.h"

@interface RootViewController ()
@property (nonatomic, strong) DragView *dragView;

@property (nonatomic, strong) HYBLoopScrollView *scrollView;
@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.scrollView startTimer];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.scrollView pauseTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(100, 300, 150, 60);
    btn.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn];
    [btn setTitle:@"进入聊天室" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    //添加轮播图
    [self addLoopScrollView];
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(500);
        make.size.mas_equalTo(CGSizeMake(200, 60));
    }];
    [button setBackgroundColor:[UIColor lightGrayColor]];
    NSString *title = [NSString stringWithFormat:@"缓存大小：%@",[DSCacheManager getCacheSizeWithFilePath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]]];
    [button setTitle:title forState:UIControlStateNormal];
   // [button setTitle:@"进入另一界面" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(otherBtnDidAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}
//添加轮播图
- (void)addLoopScrollView{
    // 这个图片会找不到，而显示默认图
    NSString *url = @"http://test.meirongzongjian.com/imageServer/user/3/42ccb9c75ccf5e910cd6f5aaf0cd1200.jpg";
    NSArray *images = @[@"http://s0.pimg.cn/group5/M00/5B/6D/wKgBfVaQf0KAMa2vAARnyn5qdf8958.jpg?imageMogr2/strip/thumbnail/1200%3E/quality/95",
                        @"http://7xrs9h.com1.z0.glb.clouddn.com/wp-content/uploads/2016/03/QQ20160322-0@2x.png",
                        @"h1.jpg",
                       
                        @"http://s0.pimg.cn/group6/M00/45/84/wKgBjVZVjYCAEIM4AAKYJZIpvWo152.jpg?imageMogr2/strip/thumbnail/1200%3E/quality/95",
                        url,
                        @"http://7xrs9h.com1.z0.glb.clouddn.com/wp-content/uploads/2016/03/QQ20160322-5@2x-e1458635879420.png"
                        ];

    _scrollView = [HYBLoopScrollView loopScrollViewWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 200) imageUrls:images timeInterval:2.5 didSelect:^(NSInteger atIndex) {
        NSLog(@"点击了% ld",(long)atIndex);
    } didScroll:^(NSInteger toIndex) {
        NSLog(@"滚动到%ld",(long)toIndex);
    }];
    _scrollView.shouldAutoClipImageToViewSize = YES;
    _scrollView.placeholder = [UIImage imageNamed:@"login_background"];
    _scrollView.alignment = kPageControlAlignCenter;
//    loop.adTitles = titles;  图片下方文字
    [self.view addSubview:_scrollView];
}

//点击进入另一个界面  验证小窗播放是否可以跨界面、
- (void)otherBtnDidAction:(UIButton *)sender{
    ///清除缓存
    [DSCacheManager clearCacheWithFilePath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]];
    NSString *title = [NSString stringWithFormat:@"缓存大小：%@",[DSCacheManager getCacheSizeWithFilePath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]]];
    [sender setTitle:title forState:UIControlStateNormal];
    KongViewController *kongVC = [[KongViewController alloc]init];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:kongVC animated:YES];
}

//点击进入聊天室
- (void)btnDidClicked:(UIButton *)sender{
    PlayViewController *playVC = [[PlayViewController alloc]init];
    NSString *userId = @"1230";
    NSString *userName = @"moni机";
 
    playVC.backBlock = ^(BOOL isBiliPlay, NSString *url) {
        //palyVC（播放界面返回时调用此block）
        if (!isBiliPlay) {   //如果是暂停状态就不小窗播放
            return ;
        }
      [self.dragView addPlayerWithurl:url];
    };
    [self loginRongCloudWithUserDict:@{@"userId":userId, @"name":userName, @"protraitUrl":@""} WithUrl:@"rtmp://live.hkstv.hk.lxdns.com/live/hks" ViewController:playVC];
    if (_dragView) {
        [_dragView dragViewHidden];
    }
    
}

//登录融云获取token 并通过token获取用户信息
- (void)loginRongCloudWithUserDict:(NSDictionary *)userDict WithUrl:(NSString *)zhibourl ViewController:(PlayViewController *)playVC{
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"登录中...";
    NSString *url = @"http://api.cn.ronghub.com/user/getToken.json";
    //获得请求管理者
    AFHTTPRequestOperationManager* mgr = [AFHTTPRequestOperationManager manager];
    
    NSString *nonce = [NSString stringWithFormat:@"%d", rand()];
    
    long timestamp = (long)[[NSDate date] timeIntervalSince1970];
    
    NSString *unionString = [NSString stringWithFormat:@"%@%@%ld", RONGCLOUD_IM_APPSECRET, nonce, timestamp];
    const char *cstr = [unionString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:unionString.length];
    uint8_t digest[20];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:20 * 2];
    
    for(int i = 0; i < 20; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    
    NSString *timestampStr = [NSString stringWithFormat:@"%ld", timestamp];
    [mgr.requestSerializer setValue:RONGCLOUD_IM_APPKEY forHTTPHeaderField:@"App-Key"];
    [mgr.requestSerializer setValue:nonce forHTTPHeaderField:@"Nonce"];
    [mgr.requestSerializer setValue:timestampStr forHTTPHeaderField:@"Timestamp"];
    [mgr.requestSerializer setValue:output forHTTPHeaderField:@"Signature"];
    
    __weak __typeof(&*self)weakSelf = self;
    [mgr POST:url parameters:userDict
      success:^(AFHTTPRequestOperation* operation, NSDictionary* responseObj) {
          NSLog(@"success");
          NSNumber *code = responseObj[@"code"];
          if (code.intValue == 200) {
              NSString *token = responseObj[@"token"];
              NSString *userId = responseObj[@"userId"];
              
              [[RCDLive sharedRCDLive] connectRongCloudWithToken:token success:^(NSString *loginUserId) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      RCUserInfo *user = [[RCUserInfo alloc]init];
                      user.userId = userId;
                      user.portraitUri = @"";
                      user.name = userDict[@"name"];
                      [RCIMClient sharedRCIMClient].currentUserInfo = user;
                      //播放界面
                      playVC.conversationType = ConversationType_CHATROOM;
                      playVC.targetId = @"1234";
                      //self.contentURL = videoUrl;   //流网址
                      playVC.playURL  = zhibourl; 
                      //[self.navigationController setNavigationBarHidden:YES];
                      [self.navigationController setNavigationBarHidden:YES animated:NO];
                      [self.navigationController pushViewController:playVC animated:YES];
                      
                  });
              } error:^(RCConnectErrorCode status) {
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                  });
                  
              } tokenIncorrect:^{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      
                  });
              }];
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                  
              });
              
          } else {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                  
              });
          }
          
      } failure:^(AFHTTPRequestOperation* operation, NSError* error) {
          NSLog(@"==========%@",error);
          dispatch_async(dispatch_get_main_queue(), ^{
              [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
              
          });
      }];
    
}

#pragma mark -- 添加可拖动view
- (DragView *)dragView{
    __weak __typeof(self)weakSelf = self;
    if (!_dragView) {
        _dragView = [[DragView alloc]initWithFrame:CGRectMake(0,200, 200, 100)];
        [[[UIApplication sharedApplication] windows].lastObject addSubview:_dragView];
        _dragView.tapBlock = ^(NSString *playurl) {
          //点击悬浮视图进入播放房间
            [weakSelf btnDidClicked:nil];
        };
    }
    _dragView.hidden = NO;
    return _dragView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
