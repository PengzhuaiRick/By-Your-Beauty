//
//  UNIGiftController.m
//  Uni
//  我的礼包
//  Created by apple on 16/1/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIGiftController.h"
#import "AccountManager.h"
#import "WXApiManager.h"
#import "UNIShopManage.h"
#import "UNIHttpUrlManager.h"
@interface UNIGiftController ()<UIWebViewDelegate,UIScrollViewDelegate>{
    UIView* shareView;
    UIView* bgView;
    UIWebView* webView;
    
    NSString* shareTitle;
    NSString* shareDesc;
    NSString* shareImg;
    NSString* shareUrl;
}

@end

@implementation UNIGiftController
-(void)viewWillAppear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    
    UIWebView* web = [[UIWebView alloc]initWithFrame:self.view.frame];
    web.delegate = self;
    web.scrollView.delegate = self;
    web.scrollView.backgroundColor =[UIColor colorWithHexString:kMainBackGroundColor];
    [self.view addSubview:web];
    web.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    //NSString* str1 = @"http://uni.dodwow.com/uni_api/api.php?c=WX&a=gotoLibao&json={%22userId%22:%22AA%22}";
    NSString* str1 = [UNIHttpUrlManager sharedInstance].WX_LIBAO_URL;
    NSString* str2 = [[AccountManager userId]stringValue];
    NSString* str3 =@"&json={%22userId%22:%22AA%22}";
    NSString* str4 = [NSString stringWithFormat:@"%@%@",str1,str3];
    NSString* str5 = [str4 stringByReplacingOccurrencesOfString:@"AA" withString:str2];
    NSString* urlString = [self URLEncodedString:str5];
    NSURL* url = [NSURL URLWithString:urlString];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];

    [web loadRequest:request];//加载
    webView = web;
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
//self.title = @"我的礼包";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"gift_bar_share"] style:0 target:self action:@selector(navigationControllerRightBarAction:)];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = request.URL.absoluteString ;
    NSLog(@"request.URL.absoluteString  %@",url);
    if([url rangeOfString:@"id=2"].location !=NSNotFound){
        UNIHttpUrlManager* urlManager = [UNIHttpUrlManager sharedInstance];
        shareTitle = urlManager.APP_BWHL_SHARE_TITLE;
        shareDesc =urlManager.APP_BWHL_SHARE_DESC;
        shareImg =urlManager.APP_BWHL_SHARE_IMG;
        shareUrl = urlManager.MY_LIBAO_SHARE_URL;
    }
    if([url rangeOfString:@"id=11"].location !=NSNotFound){
        UNIHttpUrlManager* urlManager = [UNIHttpUrlManager sharedInstance];
        shareTitle = urlManager.APP_HB_SHARE_TITLE;
        shareDesc =urlManager.APP_HB_SHARE_DESC;
        shareImg =urlManager.APP_HB_SHARE_IMG;
        shareUrl = urlManager.WX_HB_URL;
    }
    return YES;
}
#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    if ([webView canGoBack]) {
        [webView goBack];
    }else{
        if (self.containController.closing)
            [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWOPEN object:nil];
        else
            [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWCLOSE object:nil];
    }
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
            
            //UNIHttpUrlManager* urlManager = [UNIHttpUrlManager sharedInstance];
            
            WXMediaMessage* message = [WXMediaMessage message];
            UNIShopManage* shop =[UNIShopManage getShopData];
            NSString * shopName = nil;
            if (shop.shortName.length>0)
                shopName =shop.shortName;
            else
                shopName =shop.shopName;
            //message.title =[NSString stringWithFormat:@"亲爱的，我已经参加动静界%@“百万豪礼快点点”活动，让我心动的都在这儿，是时候验证我们友情了！快帮我抢！",shopName];
//            message.title = urlManager.APP_BWHL_SHARE_TITLE;
//            message.description =urlManager.APP_BWHL_SHARE_DESC;
            message.title = self->shareTitle;
            message.description =self->shareDesc;
            [message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self->shareImg]]]];
            //[message setThumbImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://uni.dodwow.com/images/logo.jpg"]]]];
            
            WXWebpageObject* web = [WXWebpageObject object];
            //NSString* str1 =@"https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxa800a6e6210b0f6e&redirect_uri=http%3a%2f%2funi.dodwow.com%2funi_api%2fapi.php%3fc%3dWX%26a%3dgotoLibaoShare&response_type=code&scope=snsapi_userinfo&state={###}#wechat_redirec";
            NSString* str1 =self->shareUrl;
            NSString* str2 = [[AccountManager userId]stringValue];
            NSString* str3 = [str1 stringByReplacingOccurrencesOfString:@"###" withString:str2];
            web.webpageUrl = [self URLEncodedString:str3];
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
        float labW = btnWH+10;
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


- (NSString *)URLEncodedString:(NSString*)STR
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)STR,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8));
    return encodedString;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<-170) {
        if (webView.loading)
            return;
        [webView reload];
    }
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
