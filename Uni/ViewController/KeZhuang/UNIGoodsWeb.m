//
//  UNIGoodsWeb.m
//  Uni
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIGoodsWeb.h"
#import "UNIHttpUrlManager.h"
#import "WebViewJavascriptBridge.h"
#import "UNIGoodsDeatilController.h"
#import "UNIAppointController.h"
#import "UNIShopCarRequest.h"
@interface UNIGoodsWeb ()<UIWebViewDelegate,UIScrollViewDelegate>
{
    UIWebView* webView;
    UILabel* shopNumLab;
}
@property WebViewJavascriptBridge* bridge;
@end


@implementation UNIGoodsWeb
-(void)viewWillAppear:(BOOL)animated{
   // webView.delegate = self;
   // webView.scrollView.delegate = self;
   // [[BaiduMobStat defaultStat] pageviewStartWithName:@"商品列表"];
    
    [super viewWillAppear:animated];
     [self BaiduStatBegin:@"商品列表"];
    [self requestShopCarNum];
}
-(void)viewWillDisappear:(BOOL)animated{
   // webView.delegate = nil;
   // webView.scrollView.delegate = nil;
    //清除UIWebView的缓存
    //[[NSURLCache sharedURLCache] removeAllCachedResponses];
    // [[BaiduMobStat defaultStat] pageviewEndWithName:@"商品列表"];
    [self BaiduStatEnd:@"商品列表"];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    
    
     UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
    [self setupUI:manager.APP_KZ_URL];
}


-(void)setupNavigation{
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
   //  self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    __weak UNIGoodsWeb* myself = self;
    [self addPanGesture:^(id model) {
        [myself navigationControllerLeftBarAction:nil];
    }];

    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = view.bounds;
    [btn setImage:[UIImage imageNamed:@"function_img_car"] forState:UIControlStateNormal];
    [view addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [self.navigationController popViewControllerAnimated:NO];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"gotoShopCarController" object:nil];
     }];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(15, -10, 15, 15)];
    lab.textColor = [UIColor whiteColor];
    lab.backgroundColor = [UIColor colorWithHexString:kMainPinkColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font =kWTFont(10);
    lab.layer.masksToBounds = YES;
    lab.layer.cornerRadius = 7.5;
    [view addSubview:lab];
    shopNumLab = lab;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];

}
#pragma mark 获取购物车类型数量
-(void)requestShopCarNum{
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_GetKindOfShopCar] params:nil];
    rq.getCartGoodsCount=^(int count,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (count == -1)
            [YIToast showText:tips];
        else
            self->shopNumLab.text = [NSString stringWithFormat:@"%d",count];
    };
}

-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
   [LLARingSpinnerView RingSpinnerViewStop1];
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [webView removeFromSuperview];
    webView = nil;
    [self.navigationController popViewControllerAnimated:YES];
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
