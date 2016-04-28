//
//  UNIAuthorizationManager.m
//  Uni
//  微信授权管理
//  Created by apple on 16/4/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIAuthorizationManager.h"
#import "UNIShopManage.h"
#import "AccountManager.h"
#import "UNIHttpUrlManager.h"
#import "UNITouristRequest.h"
@implementation UNIAuthorizationManager
-(id)init{
    self = [super init];
    if (self) {
         [WXApiManager sharedManager].delegate = self;
    }
    return self;
}

-(void)AuthorizationManager:(UIViewController*)viewC{
    
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123456" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req];
    }else{
        [WXApi sendAuthReq:req
            viewController:viewC
                  delegate:[WXApiManager sharedManager]];
    }
}

#pragma mark 授权成功 调用微信接口获取 unionid
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    
    //NSLog(@"%@",[NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode]);
    NSString* URL =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WECHATAPPID,WECHATAPPSecret,response.code];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain"]];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject  %@",responseObject);
        NSString* str = [responseObject objectForKey:@"openid"];
        NSString* str1 = [responseObject objectForKey:@"unionid"];
        if (str&&str1) {
            self->wxOpenid = str;
            self->wxUnionid = str1;
            [AccountManager setOpenid:str];
            [AccountManager setUnionid:str1];
            [self setupCustomInfoAPI];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
}

#pragma mark 调用设置游客信息
-(void)setupCustomInfoAPI{
    UNITouristRequest* rq = [[UNITouristRequest alloc]init];
    rq.setTouristBlock=^(int code,int userId,int shopId,NSString* token,NSString* tel,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (code == 0) {
                [AccountManager setToken:token];
                [AccountManager setShopId:@(shopId)];
                
            }
            else {
                [UIAlertView showWithTitle:@"提示" message:tips cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    //  [[NSNotificationCenter defaultCenter]postNotificationName:@"setupLoginController" object:nil];
                }];
            }
        });
    };
    [rq postWithSerCode:@[API_URL_SetCustomInfo] params:@{@"openId":wxOpenid,@"unionId":wxUnionid}];
    
}

@end
