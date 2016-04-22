//
//  UNIGoodsWeb.m
//  Uni
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIGoodsWeb.h"
#import "UNIHttpUrlManager.h"
@interface UNIGoodsWeb ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView* webView;
}
@end

@implementation UNIGoodsWeb
-(void)viewWillAppear:(BOOL)animated{
    webView.delegate = self;
    webView.scrollView.delegate = self;
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"UNIGoodsWeb.h"];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    webView.delegate = nil;
    webView.scrollView.delegate = nil;
     [[BaiduMobStat defaultStat] pageviewEndWithName:@"UNIGoodsWeb.h"];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    //self.title = @"由你商城";
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, KMainScreenHeight - 40,KMainScreenWidth, 30)];
    lab.text = @"已显示全部内容";
    lab.textColor = [UIColor colorWithRed:90/255.f green:90/255.f blue:90/255.f alpha:1];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:lab];
    
    UIWebView* web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight-64)];
   
    web.scrollView.scrollsToTop=YES;
    web.backgroundColor = [UIColor clearColor];
    web.scrollView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:web];
    web.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    //NSURL* url = [NSURL URLWithString:@"http://machineadmin.weeguu.com/html/active.html"];//创建URL
     UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
    if (!manager.APP_KZ_URL)
        return;
    
     NSURL* url = [NSURL URLWithString:manager.APP_KZ_URL];//创建URL
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:url];
    
    [web loadRequest:request];//加载
    webView = web;
    

    
    web=nil;lab = nil;url=nil;request=nil;
   }
-(void)setupNavigation{
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView1{
    
    [LLARingSpinnerView RingSpinnerViewStop1];
    self.title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"%@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = request.URL.absoluteString ;
    if (navigationType == UIWebViewNavigationTypeReload) {
        return YES;
    }
    if ([url rangeOfString:@"act=app"].location != NSNotFound) {
        NSArray* array = [url componentsSeparatedByString:@"&"];
        NSString* projectId = [array[1] componentsSeparatedByString:@"="][1];
        NSString* type = [array[2] componentsSeparatedByString:@"="][1];
        //[self.navigationController popViewControllerAnimated:YES];
        [self.delegate UNIGoodsWebDelegateMethodAndprojectId:projectId Andtype:type AndIsHeaderShow:0];
        
        array=nil; projectId=nil;type=nil;
        return NO;
    }
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"%f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y<-170) {
        if (webView.loading)
            return;
        [webView reload];
    }
}
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
   [LLARingSpinnerView RingSpinnerViewStop1];
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [webView removeFromSuperview];
    webView = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    //webView = nil;
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
