//
//  UNILawViewController.m
//  Uni
//  法律声明
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNILawViewController.h"
#import "UNILawRequest.h"
@interface UNILawViewController ()

@end

@implementation UNILawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self startRequest];
    
}
-(void)setupNavigation{
    self.title = @"法律声明";
    [self preferredStatusBarStyle];
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
        if (url) {
            [self setupUI:url];
        }
    };
    [req postWithSerCode:@[API_PARAM_UNI,API_URL_GetTextInfo] params:@{@"type":@"flsm"}];
}
-(void)setupUI:(NSString*)url{
    UIWebView* web = [[UIWebView alloc]initWithFrame:CGRectMake(0,64,KMainScreenWidth, KMainScreenHeight-64)];
    NSString* urlString = [NSString stringWithFormat:@"%@/%@",API_IMG_URL,url];
   // NSLog(@"urlString %@",urlString);
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [web loadRequest:request];
    [self.view addSubview:web];
}
-(void)navigationControllerLeftBarAction{
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
