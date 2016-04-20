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
//#import "UNILoginViewRequest.h"
#import "UNIHttpUrlManager.h"
#import "UNITouristRequest.h"
#import "AccountManager.h"
@interface UNITouristController ()<WXApiManagerDelegate,UIScrollViewDelegate,UIWebViewDelegate>{
    UIView* shareView;
    UIView* bgView;
//    int shopId;
//    int projectId;
    NSString* wxUnionid;
    UIWebView* _webView;
    int shareStyle;
    UNITouristModel* myModel;
}

@end

@implementation UNITouristController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"UNITouristController.h"];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"wxShareResult" object:nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"UNITouristController.h"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self startRequest];
    //[self setupUI];
   // [self setupWX];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(wxShareResult:) name:@"wxShareResult" object:nil];
}
-(void)startRequest{
    UNITouristRequest* rq = [[UNITouristRequest alloc]init];
    rq.getTouristinfo=^(UNITouristModel* model,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (model) {
                self->myModel = model;
                [self setupUI];
            }
        });
    };
    [rq postWithSerCode:@[API_URL_ActivityShare] params:@{@"activityId":@(_activityId)}];
// [rq postWithSerCode:@[API_PARAM_UNI,API_URL_ActivityShare] params:@{@"activityId":@(2)}];
}
-(void)setupUI{
    UIWebView* web = [[UIWebView alloc]initWithFrame:self.view.frame];
    web.delegate = self;
    web.scrollView.delegate = self;
    web.scrollView.backgroundColor=[UIColor colorWithHexString:kMainBackGroundColor];
    [self.view addSubview:web];
    web.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    NSString* urlString = myModel.activityUrl;
    NSURL* url = [NSURL URLWithString:urlString];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [web loadRequest:request];//加载
    _webView = web;
    web = nil;
}

#pragma mark 微信授权登录
-(void)setupWX{
    if (!self->myModel) {
        return;
    }
     wxUnionid=[AccountManager unionid];
    if (wxUnionid) {
        [self startShare];
        return;
    }
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
#pragma mark 授权成功 调用微信接口获取 unionid
- (void)managerDidRecvAuthResponse:(SendAuthResp *)response {
   
    //NSLog(@"%@",[NSString stringWithFormat:@"code:%@,state:%@,errcode:%d", response.code, response.state, response.errCode]);
    NSString* URL =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WECHATAPPID,WECHATAPPSecret,response.code];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"text/plain"]];
    [manager GET:URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject  %@",responseObject);
       // NSString* str = [responseObject objectForKey:@"openid"];
        NSString* str = [responseObject objectForKey:@"unionid"];
        if (str) {
            self->wxUnionid = str;
            [AccountManager setUnionid:str];
            [self setupCustomInfoAPI];
            [self startShare];
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
                [AccountManager setUserId:@(userId)];
                [AccountManager setShopId:@(shopId)];
    
            }
            else {
                [UIAlertView showWithTitle:@"提示" message:tips cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                      [[NSNotificationCenter defaultCenter]postNotificationName:@"setupLoginController" object:nil];
                }];
            }
        });
    };
    [rq postWithSerCode:@[API_URL_SetCustomInfo] params:@{@"openId":wxUnionid}];
 
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
    
   if(_hasActivity>0)
        self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gift_bar_share"] style:0 target:self action:@selector(navigationControllerRightBarAction:)];
    
}

#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
     [LLARingSpinnerView RingSpinnerViewStop1];
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter]postNotificationName:APPOINTANDREFLASH object:nil];
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
//             if (!self->wxUnionid) {
//                 return ;
//             }
             //UNIHttpUrlManager* urlManager =[UNIHttpUrlManager sharedInstance];
             
             self->shareStyle = (int)x.tag;
             [self setupWX];
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

#pragma mark 设置分享内容
-(void)startShare{
    WXMediaMessage* message = [WXMediaMessage message];
    message.title =self->myModel.shareTitle;
    message.description =self->myModel.shareDetail;
    [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self->myModel.logoUrl]]]];//正式图片
    
    WXWebpageObject* web = [WXWebpageObject object];
    //              NSString* str1 = @"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxa800a6e6210b0f6e&redirect_uri=http%3a%2f%2funi.dodwow.com%2funi_api%2fapi.php%3fc%3dWXHB%26a%3dcustomShareCallback&response_type=code&scope=snsapi_userinfo&state=$shopId***$openId***$projectId#wechat_redirect";
    NSString* str1 = self->myModel.shareUrl;
    //              NSString* str2 = [str1 stringByReplacingOccurrencesOfString:@"$shopId" withString:[NSString stringWithFormat:@"%d",[[AccountManager shopId] intValue]]];
    //             NSString* str3 = [str2 stringByReplacingOccurrencesOfString:@"$openId" withString:self->wxUnionid];
    //             NSString* str4 = [str3 stringByReplacingOccurrencesOfString:@"$projectId" withString:[NSString stringWithFormat:@"%d",self.activityId]];
    
    web.webpageUrl =str1 ; //[self URLEncodedString:str4];
    message.mediaObject = web;
    SendMessageToWXReq* rep = [[SendMessageToWXReq alloc]init];
    rep.bText = NO;
    if (shareStyle == 1)
        rep.scene = WXSceneSession;
    if (shareStyle == 2)
        rep.scene = WXSceneTimeline;
    rep.message = message;
    [WXApi sendReq:rep];
    [self hidenShareView];
    
    [self wxShareResult:nil];//显示返回按钮
    
    str1= nil;
    //             str2 = nil;
    //             str3 = nil;
    //             str4=nil;
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
     self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
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
