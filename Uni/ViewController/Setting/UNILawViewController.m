//
//  UNILawViewController.m
//  Uni
//  法律声明
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNILawViewController.h"

@interface UNILawViewController ()<UIWebViewDelegate,UIScrollViewDelegate>{
    UIWebView* webView;
}

@end

@implementation UNILawViewController
-(void)viewWillAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"法律声明"];
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"法律声明"];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self startRequest];
    
}
-(void)setupNavigation{
    self.title = @"法律声明";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction)];
    
}
-(void)startRequest{
    UNILawRequest* req = [[UNILawRequest alloc]init];
    req.getLawInfoBlock=^(NSString* url,NSString* tip,NSError* err ){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (url)
            [self setupUI:url];
        else
            [YIToast showText:tip];
    };
    [req postWithSerCode:@[API_URL_GetTextInfo] params:@{@"type":@"flsm"}];
}
-(void)setupUI:(NSString*)url{
    UIWebView* web = [[UIWebView alloc]initWithFrame:CGRectMake(0,64,KMainScreenWidth, KMainScreenHeight-64)];
    web.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    web.delegate = self;
    web.scrollView.delegate = self;
    //NSString* urlString = [NSString stringWithFormat:@"%@/%@",API_IMG_URL,url];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [web loadRequest:request];
    [self.view addSubview:web];
    webView = web;
}
-(void)navigationControllerLeftBarAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [LLARingSpinnerView RingSpinnerViewStop1];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<-170) {
        if (!webView.loading) {
            [webView reload];
        }
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
