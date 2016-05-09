//
//  BaseWebController.h
//  Uni
//
//  Created by apple on 16/5/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobStat.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

#import "WebViewJavascriptBridge.h"
#import "UNIGoodsDeatilController.h"
#import "UNIAppointController.h"
@interface BaseWebController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,NJKWebViewProgressDelegate>
@property (strong, nonatomic)  UIWebView *baseWebView;
@property (strong, nonatomic)  NJKWebViewProgress* progressProxy;
@property (strong, nonatomic)  NJKWebViewProgressView* progressView;


-(void)setupUI:(NSString*)urlString;

#pragma mark 百度统计开始
-(void)BaiduStatBegin:(NSString*)text;

#pragma mark 百度统计结束
-(void)BaiduStatEnd:(NSString*)text;
@end
