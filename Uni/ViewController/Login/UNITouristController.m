//
//  UNITouristController.m
//  Uni
//
//  Created by apple on 16/2/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNITouristController.h"
#import "WXApiManager.h"
#import "UNIShopManage.h"
#import "AccountManager.h"
#import "UNILoginViewRequest.h"
#import "UNIHttpUrlManager.h"
#import "AppDelegate.h"
@interface UNITouristController ()<WXApiManagerDelegate,UIScrollViewDelegate,UIWebViewDelegate>{
    UIView* shareView;
    UIView* bgView;
    int shopId;
    int projectId;
    NSString* wxOpenId;
    UIWebView* _webView;
}

@end

@implementation UNITouristController
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wxShareResult" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxShareResult:) name:@"wxShareResult" object:nil];
    
    UIWebView* web = [[UIWebView alloc]initWithFrame:self.view.frame];
    web.delegate = self;
    web.scrollView.delegate = self;
    web.scrollView.backgroundColor=[UIColor colorWithHexString:kMainBackGroundColor];
    [self.view addSubview:web];
    web.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    //NSString* str1 = @"http://uni.dodwow.com/uni_api/api.php?c=WXHB&a=test";
    NSString* str1 =[UNIHttpUrlManager sharedInstance].WX_HB_URL;
    NSString* urlString = [self URLEncodedString:str1];
    NSURL* url = [NSURL URLWithString:urlString];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [web loadRequest:request];//加载
    
    _webView = web;
    
    UNILoginViewRequest* rq = [[UNILoginViewRequest alloc]init];
    rq.rqTouristBlock=^(int shopId1,int projectId1,NSString* tips,NSError* er){
        if (er) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (shopId1>-1) {
             self->shopId = shopId1;
            self->projectId = projectId1;
        }
       
    };
    [rq postWithSerCode:@[API_PARAM_UNI,API_URL_GetCustomInfo] params:nil];
    
     [WXApiManager sharedManager].delegate = self;
    
    SendAuthReq* req =[[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"123456" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    if ([WXApi isWXAppInstalled]) {
        [WXApi sendReq:req];
    }else{
    [WXApi sendAuthReq:req
        viewController:self
              delegate:[WXApiManager sharedManager]];
    }
}
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
    wxOpenId=@"";
    //NSLog(@"%@",[NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode]);
    NSString* URL =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WECHATAPPID,WECHATAPPSecret,response.code];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain"]];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject  %@",responseObject);
        NSString* str = [responseObject objectForKey:@"openid"];
        if (str) {
            self->wxOpenId = str;
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    
    }];

}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView1{
    self.title =[webView1 stringByEvaluatingJavaScriptFromString:@"document.title"];//@"document.title";//获取当前页面的title
    [LLARingSpinnerView RingSpinnerViewStop1];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"%@",error);
}

-(void)setupNavigation{
    self.title = @"参与活动";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gift_bar_share"] style:0 target:self action:@selector(navigationControllerRightBarAction:)];
    
}

#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(void)navigationControllerRightBarAction:(UIBarButtonItem*)bar{
    
    bar.enabled=NO;
    
    UIView* bg = [[UIView alloc]initWithFrame:self.view.frame];
    bg.backgroundColor = [UIColor blackColor];
    bg.alpha = 0;
    [self.view addSubview:bg];
    bgView = bg;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizerAction:)];
    [bg addGestureRecognizer:tap];
    
    float viewH = KMainScreenWidth* 100/320;
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, KMainScreenHeight, KMainScreenWidth,viewH)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    shareView = view;
    
    UILabel* label= [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 40,15)];
    label.text = @"分享到";
    label.font = [UIFont systemFontOfSize:(KMainScreenWidth>400?12:10)];
    label.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [view addSubview:label];
    
    float btnWH = KMainScreenWidth*45/320;
    float btnY = 30;
    //float btnX =(view.frame.size.width/2 - btnWH)/2;
    NSArray* arr=@[@"微信好友",@"微信朋友圈"];
    NSArray* imgArr = @[@"KZ_img_weixin",@"gift_btn_pyq"];
    for (int i=0 ; i<arr.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        float btnxx = 0;
        if (i == 0 )
            btnxx  = view.frame.size.width/2 - btnWH - 10;
        else
            btnxx  = view.frame.size.width/2 +10;
        btn.frame = CGRectMake(btnxx, btnY, btnWH, btnWH);
        [btn setBackgroundImage:[UIImage imageNamed:imgArr[i]] forState:UIControlStateNormal];
        btn.tag = i+1;
        [view addSubview:btn];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             
             UNIHttpUrlManager* urlManager =[UNIHttpUrlManager sharedInstance];
             
             WXMediaMessage* message = [WXMediaMessage message];
             message.title =urlManager.APP_HB_SHARE_TITLE;
             message.description =urlManager.APP_HB_SHARE_DESC;
             //[message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://uni.dodwow.com/images/logo.jpg"]]]];//测试图片
            [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://uni.dodwow.com/images/hb.jpg"]]]];//正式图片
             
             WXWebpageObject* web = [WXWebpageObject object];
//              NSString* str1 = @"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxa800a6e6210b0f6e&redirect_uri=http%3a%2f%2funi.dodwow.com%2funi_api%2fapi.php%3fc%3dWXHB%26a%3dcustomShareCallback&response_type=code&scope=snsapi_userinfo&state=$shopId***$openId***$projectId#wechat_redirect";
              NSString* str1 = urlManager.WX_SHARE_URL;
              NSString* str2 = [str1 stringByReplacingOccurrencesOfString:@"$shopId" withString:[NSString stringWithFormat:@"%d",self->shopId]];
             NSString* str3 = [str2 stringByReplacingOccurrencesOfString:@"$openId" withString:self->wxOpenId];
             NSString* str4 = [str3 stringByReplacingOccurrencesOfString:@"$projectId" withString:[NSString stringWithFormat:@"%d",self->projectId]];
             
            
             web.webpageUrl =str4 ; //[self URLEncodedString:str4];
             message.mediaObject = web;
             
             
             SendMessageToWXReq* rep = [[SendMessageToWXReq alloc]init];
             rep.bText = NO;
             if (btn.tag == 1)
                 rep.scene = WXSceneSession;
             if (btn.tag == 2)
                 rep.scene = WXSceneTimeline;
             rep.message = message;
             [WXApi sendReq:rep];
             [self hidenShareView];
         }];
        
        float labX =btnxx-5;
        float labY = CGRectGetMaxY(btn.frame);
        float labW =  btnWH+10;;
        float labH = KMainScreenWidth*20/320;
        UILabel * lab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
        lab.text = arr[i];
        lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?12:10];
        lab.textAlignment = NSTextAlignmentCenter;
        [view addSubview:lab];
        
    }
    
    CGRect viRe = view.frame;
    viRe.origin.y = KMainScreenHeight - viRe.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        bg.alpha = 0.5;
        view.frame = viRe;
    }];
}

-(void)tapGestureRecognizerAction:(UIGestureRecognizer*)ge{
    [self hidenShareView];
}

-(void)hidenShareView{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self->bgView.alpha = 0;
        [self->bgView removeFromSuperview];
        self->shareView.alpha = 0;
        [self->shareView removeFromSuperview];
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<-170) {
        if (_webView.loading)
            return;
        [_webView reload];
    }
}

#pragma mark 微信分享成功后
-(void)wxShareResult:(NSNotification*)notifi{
    UNILoginViewRequest* rq = [[UNILoginViewRequest alloc]init];
    rq.setTouristBlock=^(int code,NSString* tel,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (code == 0) {
                self.view.window.backgroundColor = [UIColor whiteColor];
                AppDelegate* app = [UIApplication sharedApplication].delegate;
                [app setupViewController];
            }else if (code == 7){
                NSString* message = [NSString stringWithFormat:@"%@已经在微信上注册过，请使用此号码登录",tel];
                [UIAlertView showWithTitle:@"提示" message:message cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                }];
            }
        });
    };
    [rq postWithSerCode:@[API_PARAM_UNI,API_URL_SetCustomInfo] params:nil];
    
   

}

- (NSString *)URLEncodedString:(NSString*)STR
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                                    (CFStringRef)STR,
                                                                                                    (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                                                                    NULL,
                                                                                                    kCFStringEncodingUTF8));
    return encodedString;
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
