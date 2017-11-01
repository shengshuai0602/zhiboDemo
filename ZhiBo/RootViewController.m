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


@interface RootViewController ()
@property (nonatomic, strong) DragView *dragView;
@end

@implementation RootViewController

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [[UIButton alloc]init];
    btn.frame = CGRectMake(100, 100, 150, 60);
    btn.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:btn];
    [btn setTitle:@"进入聊天室" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button = [[UIButton alloc]init];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(200, 60));
    }];
    [button setTitle:@"进入另一界面" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(otherBtnDidAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // Do any additional setup after loading the view.
}

//点击进入另一个界面  验证小窗播放是否可以跨界面、
- (void)otherBtnDidAction:(UIButton *)sender{
    KongViewController *kongVC = [[KongViewController alloc]init];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController pushViewController:kongVC animated:YES];
}

//点击进入聊天室
- (void)btnDidClicked:(UIButton *)sender{
    PlayViewController *playVC = [[PlayViewController alloc]init];
    NSString *userId = @"1230";
    NSString *userName = @"moni机";
    
    playVC.backBlock = ^(NSString *url) {
        //palyVC（播放界面返回时调用此block）
      
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
