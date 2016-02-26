//
//  UNIGoodsWeb.m
//  Uni
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIGoodsWeb.h"

@interface UNIGoodsWeb ()<UIWebViewDelegate>
{
     UIActivityIndicatorView *testActivityIndicator;
}
@end

@implementation UNIGoodsWeb

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    
    UIWebView* web = [[UIWebView alloc]initWithFrame:self.view.frame];
    web.delegate = self;
    [self.view addSubview:web];
    web.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    NSURL* url = [NSURL URLWithString:@"http://uni.dodwow.com/uni_api/product/productlist.html"];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [web loadRequest:request];//加载
}
-(void)setupNavigation{
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    testActivityIndicator.center = CGPointMake(KMainScreenWidth/2, KMainScreenHeight/2);
    [self.view addSubview:testActivityIndicator];
    // testActivityIndicator.color = [UIColor redColor]; // 改变圈圈的颜色为红色； iOS5引入
    [testActivityIndicator startAnimating]; // 开始旋转
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [testActivityIndicator stopAnimating];
    [testActivityIndicator removeFromSuperview];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    NSLog(@"%@",error);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString* url = request.URL.absoluteString ;
    
    if ([url rangeOfString:@"act=app"].location != NSNotFound) {
        NSArray* array = [url componentsSeparatedByString:@"&"];
        NSString* projectId = [array[1] componentsSeparatedByString:@"="][1];
        NSString* type = [array[2] componentsSeparatedByString:@"="][1];
        [self.navigationController popViewControllerAnimated:YES];
        [self.delegate UNIGoodsWebDelegateMethodAndprojectId:projectId Andtype:type AndIsHeaderShow:0];
        
    }
    return YES;
}

-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    [self.navigationController popViewControllerAnimated:YES];
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
