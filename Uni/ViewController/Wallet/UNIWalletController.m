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

@end

@implementation UNIWalletController
-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
     [self BaiduStatBegin:@"我的优惠"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    [self BaiduStatEnd:@"我的优惠"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    
     NSString* str1 = [UNIHttpUrlManager sharedInstance].MY_YH_URL;
    [self setupUI:str1];

}

-(void)setupNavigation{
    self.title = @"我的优惠";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
//    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_function"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];

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
