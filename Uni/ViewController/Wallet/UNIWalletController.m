//
//  UNIWalletController.m
//  Uni
//  我的优惠
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIWalletController.h"
//#import "UNIWalletCell.h"
#import "UNIHttpUrlManager.h"
//#import "AccountManager.h"
//#import "UNIGoodsDeatilController.h"
//#import "UNIAppointController.h"
//#import "WebViewJavascriptBridge.h"
@interface UNIWalletController ()/*<UIWebViewDelegate,UIScrollViewDelegate>*/{
    //UIWebView* _webView;
}
//@property WebViewJavascriptBridge* bridge;
@end

@implementation UNIWalletController
-(void)viewWillAppear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    //[[BaiduMobStat defaultStat] pageviewStartWithName:@"我的优惠"];
     [self BaiduStatBegin:@"我的优惠"];
    [super viewWillAppear:animated];

}
-(void)viewWillDisappear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    //清除UIWebView的缓存
   // [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //[[BaiduMobStat defaultStat] pageviewEndWithName:@"我的优惠"];
    [self BaiduStatEnd:@"我的优惠"];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    
     NSString* str1 = [UNIHttpUrlManager sharedInstance].MY_YH_URL;
    [self setupUI:str1];

//    UIWebView* web = [[UIWebView alloc]initWithFrame:self.view.frame];
//   // web.delegate = self;
//    web.scrollView.delegate = self;
//    web.scrollView.backgroundColor =[UIColor colorWithHexString:kMainBackGroundColor];
//    [self.view addSubview:web];
//    _webView = web;
//    web.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
//    //NSString* str1 = @"http://uni.dodwow.com/uni_api/api.php?c=WX&a=gotoLibao&json={%22userId%22:%22AA%22}";
//    NSString* str1 = [UNIHttpUrlManager sharedInstance].MY_YH_URL;
//    NSURL* url = [NSURL URLWithString:str1];//创建URL
//    NSURLRequest* request = [NSURLRequest requestWithURL:url];
//    
//    [web loadRequest:request];//加载
//    
//    __weak id myself = self;
//    
//    self.bridge =[WebViewJavascriptBridge bridgeForWebView:web webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"data  %@",data);
//    }];
//    
//    [self.bridge send:@"init" responseCallback:^(id responseData) {}];
//    
//    
//    [self.bridge registerHandler:@"gotoAppoint" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"gotoAppoint %@", data);
//        NSString* str = [data objectForKey:@"projectId"];
//        [myself gotoAppoint:str :@""];
//    }];
//    
//    [self.bridge registerHandler:@"gotoGoodsDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"gotoGoodsDetail: %@", data);
//        NSString* str = [data objectForKey:@"projectId"];
//        [myself gotoGoodsDeatil:str :@"2" :0];
//        [[BaiduMobStat defaultStat]logEvent:@"btn_buy_coupon_list" eventLabel:@"我的优惠列表点击"];
//        
//    }];
//    [self.bridge registerHandler:@"gotoBuyProject" handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSLog(@"gotoBuyProject: %@", data);
//        NSString* str = [data objectForKey:@"projectId"];
//        [myself gotoBuyProject:str :@"3" :0];
//        [[BaiduMobStat defaultStat]logEvent:@"btn_buy_coupon_list" eventLabel:@"我的优惠列表点击"];
//    }];

}
//- (void)webViewDidStartLoad:(UIWebView *)webView{
//    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView1{
//    self.title =[webView1 stringByEvaluatingJavaScriptFromString:@"document.title"];//@"document.title";//获取当前页面的title
//    [LLARingSpinnerView RingSpinnerViewStop1];
//}

-(void)setupNavigation{
    self.title = @"我的优惠";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_function"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];

}




#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    if ([self.baseWebView canGoBack]) {
        [self.baseWebView goBack];
    }else{
        if (self.containController.closing)
            [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWOPEN object:nil];
        else
            [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWCLOSE object:nil];
    }
    //[LLARingSpinnerView RingSpinnerViewStop1];
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView.contentOffset.y<-170) {
//        if (self.baseWebView.loading)
//            return;
//        //清除UIWebView的缓存
//        [[NSURLCache sharedURLCache] removeAllCachedResponses];
//        [self.baseWebView reload];
//    }
//}
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    NSString* url = request.URL.absoluteString ;
//    if ([url rangeOfString:@"act=app"].location != NSNotFound && url) {
//        NSArray* array = [url componentsSeparatedByString:@"&"];
//        NSString* projectId = [array[1] componentsSeparatedByString:@"="][1];
//        NSString* type = [array[2] componentsSeparatedByString:@"="][1];
//        [self gotoUNIGoodsDeatilControllerprojectId:projectId Andtype:type AndIsHeaderShow:0];
//        
//        array=nil; projectId=nil;type=nil;
//        return NO;
//    }
//    return YES;
//}
//-(void)gotoUNIGoodsDeatilControllerprojectId:(NSString *)ProjectId Andtype:(NSString *)Type AndIsHeaderShow:(int)isH{
//    UIStoryboard* kz = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
//    UNIGoodsDeatilController* good = [kz instantiateViewControllerWithIdentifier:@"UNIGoodsDeatilController"];
//    //UNIGoodsDeatilController* good = [[UNIGoodsDeatilController alloc]init];
//    good.projectId = ProjectId;
//    good.type = Type;
//    good.isHeadShow = isH;
//    [self.navigationController pushViewController:good animated:YES];
//    kz=nil;
//    good=nil;
//}
//#pragma mark 调转预约界面
//-(void)gotoAppoint:(NSString *)ProjectId :(NSString *)Type{
//    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UNIAppointController* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointController"];
//    appoint.projectId = ProjectId;
//    [self.navigationController pushViewController:appoint animated:YES];
//    appoint=nil;
//    story=nil;
//}
//
//#pragma mark 调转客妆界面
//-(void)gotoGoodsDeatil:(NSString *)ProjectId :(NSString *)Type :(int)isH{
//    UIStoryboard* kz = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
//    UNIGoodsDeatilController* good = [kz instantiateViewControllerWithIdentifier:@"UNIGoodsDeatilController"];
//    //UNIGoodsDeatilController* good = [[UNIGoodsDeatilController alloc]init];
//    good.projectId = ProjectId;
//    good.type = Type;
//    good.isHeadShow = isH;
//    [self.navigationController pushViewController:good animated:YES];
//    kz=nil;
//    good=nil;
//}
//#pragma mark 调转客妆界面
//-(void)gotoBuyProject:(NSString *)ProjectId :(NSString *)Type :(int)isH{
//    UIStoryboard* kz = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
//    UNIGoodsDeatilController* good = [kz instantiateViewControllerWithIdentifier:@"UNIGoodsDeatilController"];
//    //UNIGoodsDeatilController* good = [[UNIGoodsDeatilController alloc]init];
//    good.projectId = ProjectId;
//    good.type = Type;
//    good.isHeadShow = isH;
//    [self.navigationController pushViewController:good animated:YES];
//    kz=nil;
//    good=nil;
//}

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
