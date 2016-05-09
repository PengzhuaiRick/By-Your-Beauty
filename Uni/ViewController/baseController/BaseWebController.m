//
//  BaseWebController.m
//  Uni
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseWebController.h"

@interface BaseWebController ()
@property WebViewJavascriptBridge* bridge;
@end

@implementation BaseWebController
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    self.baseWebView.scrollView.delegate = nil;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.baseWebView.scrollView.delegate = self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    // Do any additional setup after loading the view.
}


-(void)setupUI:(NSString*)urlString{
   
      NSURL* url = [NSURL URLWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    _progressView = [[NJKWebViewProgressView alloc]init];
    _progressView.frame = CGRectMake(0, 44, mainSize.width, 2);
    [self.navigationController.navigationBar addSubview:_progressView];
    
    _progressProxy = [[NJKWebViewProgress alloc]init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    __weak BaseWebController* myself = self;
    _progressProxy.progressBlock = ^(float progress) {
        [myself.progressView setProgress:progress animated:YES];
    };
    
    self.baseWebView = [[UIWebView alloc]initWithFrame:self.view.frame];
    //self.baseWebView.delegate = _progressProxy;
    
    self.baseWebView.scrollView.scrollsToTop=YES;
    self.baseWebView.backgroundColor = [UIColor clearColor];
    self.baseWebView.scrollView.backgroundColor = [UIColor clearColor];
    self.baseWebView.scalesPageToFit = YES;
    [self.baseWebView loadRequest:request];
    [self.view addSubview:self.baseWebView];
    
    
    self.bridge =[WebViewJavascriptBridge bridgeForWebView:self.baseWebView webViewDelegate:_progressProxy handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"data  %@",data);
    }];
    
    [self.bridge send:@"init" responseCallback:^(id responseData) {}];
    
    [self.bridge registerHandler:@"gotoAppoint" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"gotoAppoint %@", data);
        NSString* str = [data objectForKey:@"projectId"];
        [myself gotoAppoint:str :@""];
    }];
    
    [self.bridge registerHandler:@"gotoGoodsDetail" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"gotoGoodsDetail: %@", data);
        NSString* str = [data objectForKey:@"projectId"];
        [myself gotoGoodsDeatil:str :@"2" :0];
        [[BaiduMobStat defaultStat]logEvent:@"btn_buy_product_list" eventLabel:@"产品列表购买按钮"];
        
    }];
    [self.bridge registerHandler:@"gotoBuyProject" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"gotoBuyProject: %@", data);
        NSString* str = [data objectForKey:@"projectId"];
        [myself gotoBuyProject:str :@"3" :0];
        [[BaiduMobStat defaultStat]logEvent:@"btn_buy_product_list" eventLabel:@"产品列表购买按钮"];
    }];
}


#pragma mark 调转预约界面
-(void)gotoAppoint:(NSString *)ProjectId :(NSString *)Type{
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNIAppointController* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointController"];
    appoint.projectId = ProjectId;
    [self.navigationController pushViewController:appoint animated:YES];
    appoint=nil;
    story=nil;
}

#pragma mark 调转客妆界面
-(void)gotoGoodsDeatil:(NSString *)ProjectId :(NSString *)Type :(int)isH{
    UIStoryboard* kz = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
    UNIGoodsDeatilController* good = [kz instantiateViewControllerWithIdentifier:@"UNIGoodsDeatilController"];
    //UNIGoodsDeatilController* good = [[UNIGoodsDeatilController alloc]init];
    good.projectId = ProjectId;
    good.type = Type;
    good.isHeadShow = isH;
    [self.navigationController pushViewController:good animated:YES];
    kz=nil;
    good=nil;
}
#pragma mark 调转客妆界面
-(void)gotoBuyProject:(NSString *)ProjectId :(NSString *)Type :(int)isH{
    UIStoryboard* kz = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
    UNIGoodsDeatilController* good = [kz instantiateViewControllerWithIdentifier:@"UNIGoodsDeatilController"];
    //UNIGoodsDeatilController* good = [[UNIGoodsDeatilController alloc]init];
    good.projectId = ProjectId;
    good.type = Type;
    good.isHeadShow = isH;
    [self.navigationController pushViewController:good animated:YES];
    kz=nil;
    good=nil;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    // [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.title =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
   
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    float y = scrollView.contentOffset.y;
    if (y< -130) {
        if ([self.baseWebView isLoading])
            return;
        //清除UIWebView的缓存
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [self.baseWebView reload];
    }
    
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    //[self.progressView setProgress:progress animated:YES];
    if (progress == NJKInteractiveProgressValue) {
        // The web view has finished parsing the document,
        // but is still loading sub-resources
    }
}



#pragma mark 百度统计开始
-(void)BaiduStatBegin:(NSString*)text{
    [[BaiduMobStat defaultStat] pageviewStartWithName:text];
}

#pragma mark 百度统计结束
-(void)BaiduStatEnd:(NSString*)text{
    [[BaiduMobStat defaultStat] pageviewEndWithName:text];
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
