//
//  UNIWalletController.m
//  Uni
//  我的卡包
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIWalletController.h"
#import "UNIWalletCell.h"
#import "UNIHttpUrlManager.h"
#import "AccountManager.h"

@interface UNIWalletController ()<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    UIWebView* _webView;
}
@property(strong,nonatomic)UITableView* myTable;
@end

@implementation UNIWalletController
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
    //[self setupTableView];
   //[self noDataView];
    UIWebView* web = [[UIWebView alloc]initWithFrame:self.view.frame];
    web.delegate = self;
    web.scrollView.delegate = self;
    web.scrollView.backgroundColor =[UIColor colorWithHexString:kMainBackGroundColor];
    [self.view addSubview:web];
    _webView = web;
    web.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    //NSString* str1 = @"http://uni.dodwow.com/uni_api/api.php?c=WX&a=gotoLibao&json={%22userId%22:%22AA%22}";
    NSString* str1 = [UNIHttpUrlManager sharedInstance].MY_YH_URL;
    NSString* str2 = [[AccountManager userId]stringValue];
    NSString* str3 =@"&json={%22userId%22:%22AA%22}";
    NSString* str4 = [NSString stringWithFormat:@"%@%@",str1,str3];
    NSString* str5 = [str4 stringByReplacingOccurrencesOfString:@"AA" withString:str2];
    NSString* urlString = [self URLEncodedString:str5];
   //  NSString* urlString = str5;
    NSURL* url = [NSURL URLWithString:urlString];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    [web loadRequest:request];//加载
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView1{
    self.title =[webView1 stringByEvaluatingJavaScriptFromString:@"document.title"];//@"document.title";//获取当前页面的title
    [LLARingSpinnerView RingSpinnerViewStop1];
}

-(void)noDataView{
    UILabel*lab = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, KMainScreenWidth - 32, KMainScreenHeight)];
    lab.text = @"很抱歉您暂时没有可用现金券。马上开始预约服务，大把现金券等你拿！";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.lineBreakMode = 0;
    lab.numberOfLines = 0;
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [self.view addSubview:lab];
}
-(void)setupNavigation{
    self.title = @"我的优惠";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
}

-(void)setupTableView{
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+10, KMainScreenWidth,KMainScreenHeight - 64 - 10) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tabview];
    tabview.tableFooterView = [UIView new];
    if (IOS_VERSION>8.0) {
        tabview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    }
    self.myTable =tabview;
    
//    self.myTable.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        self.myScroller.contentSize = CGSizeMake(self.myScroller.frame.size.width, self.myScroller.frame.size.height*2);
//        [self.myScroller setContentOffset:CGPointMake(0,self.myScroller.frame.size.height) animated:YES];
//        self.myTable.footer = nil;
//        [self setupWebView];
//        
//    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth* 120/320;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
         static NSString* name = @"cell";
    UNIWalletCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[UNIWalletCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth* 120/320) reuseIdentifier:name];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 3) {
        [cell setupCellContent:nil];
    }
    return cell;
}


#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        if (self.containController.closing)
            [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWOPEN object:nil];
        else
            [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWCLOSE object:nil];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y<-170) {
        if (_webView.loading)
            return;
        [_webView reload];
    }
}

-(void)navigationControllerRightBarAction:(UIBarButtonItem*)bar{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UIViewController* view = [st instantiateViewControllerWithIdentifier:@"UNIWalletList"];
    [self.navigationController pushViewController:view animated:YES];

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
