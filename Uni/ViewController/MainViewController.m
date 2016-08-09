//
//  MainViewController.m
//  Uni
//  首页界面
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewController.h"
//#import "MainMidController.h"
//#import "MainBottomController.h"
//#import "MainMoveTransition.h"
#import "MainViewRequest.h"
#import "AccountManager.h"
#import "UNIAppointController.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIGoodsDeatilController.h"
#import "MainViewCell.h"
#import "UNIMainProView.h"
#import "UNIGoodsWeb.h"
#import "UNIHttpUrlManager.h"
#import "UNITouristController.h"

#import "ViewController.h"
#import "UNIWalletController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UNIGoodsWebDelegate>{
    UITableView* myTable;
    float cellHight;
    int appointTotal;
    int type1;
    int goodId1;
    int bottomPage;//底部数据加载页数
    
    int cellNumber; //Cell的数量
    
    UILabel* progessLab; //9/10
    UILabel* goods1;
    UILabel* goods2;
   // UILabel* goods3;
    UILabel* goodsLab; //约满奖励商品名称
    UILabel* numLab; //再预约次数
    UNIMainProView* progessView;//进度条
    UIImageView* goodsImg; //奖励产品图片
    UIImageView* headerImg;
    
    NSArray* sellGoods;
    UILabel* sell1;
    UILabel* sell2;
    UILabel* sell3;
    UILabel* sell4;
    UIButton* sellBtn;
    UIButton* alphBtn;
    
    NSArray* couponArr;
}
@property(nonatomic,strong) NSArray* midData;
@property(nonatomic,strong) NSMutableArray* bottomData;
@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    [self changeNavigationBarAlpha:0];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"首页"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}
-(void)viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
    [self changeNavigationBarAlpha:1];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"首页"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupScroller];
    [self setupNotification];//注册通知
    [self requestBackGroundUrl];
}
#pragma mark 获取后台动态URL
-(void)requestBackGroundUrl{
    __weak id myself = self;
     MainViewRequest* request = [[MainViewRequest alloc]init];
    request.rqfirstUrl=^(int code){
        dispatch_async(dispatch_get_main_queue(), ^{
            [myself startRequestMain];
            [myself requestActivityShowOrNot];
        });
    };
    [request firstRequestUrl];
}
#pragma mark 获取后台动态URL 下拉刷新
-(void)requestBackGroundUrl1{
    __weak id myself = self;
    MainViewRequest* request = [[MainViewRequest alloc]init];
    request.rqfirstUrl=^(int code){
        dispatch_async(dispatch_get_main_queue(), ^{
            [myself startRequestMain];
        });
    };
    [request firstRequestUrl];
}

-(void)startRequestMain{
    [self requestAppTips];
    [self startRequestShopInfo];//请求商家信息
    [self startRequestReward];//请求约满信息
    [self startRequestAppointInfo];//请求我已预约
    [self getBgImageAndGoodsImage];//请求背景图片 和 奖励商品图片
    [self getSellInfo]; //获取首页销售商品
    [self requestCouponInfo];
}

-(void)requestCouponInfo{
   // __weak id myself = self;
    MainViewRequest* request = [[MainViewRequest alloc]init];
    [request postWithSerCode:@[API_URL_GetNewestCoupon]
                      params:nil];
    request.rqCouponBlock=^(NSArray* array,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
                self->couponArr = array;
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:0];
                [self->myTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        });
    };

}

#pragma mark 审核期间 是否显示活动页面
-(void)requestActivityShowOrNot{
    __weak id myself = self;
    MainViewRequest* request = [[MainViewRequest alloc]init];
    [request postWithSerCode:@[API_URL_RetCode]
                      params:nil];
    request.rqshowAcitivityOrNot=^(int code,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (code != INAUDIT)
                [myself requestActivityInfo];
            else
                [myself showGuideView:MAINGUIDE];
        });
    };

}

#pragma mark 请求活动信息
-(void)requestActivityInfo{
    __weak id myself = self;
    MainViewRequest* request = [[MainViewRequest alloc]init];
    [request postWithSerCode:@[API_URL_HasActivity]
                       params:nil];
    request.rqactivity=^(int hasActivity,int activityId,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (activityId>0 && hasActivity < 2)
               [myself performSelector:@selector(setupActivityController:) withObject:@[@(hasActivity),@(activityId)] afterDelay:1];
               //[self setupActivityController:@[@(hasActivity),@(activityId)]];
            else
                [myself showGuideView:MAINGUIDE];
        });
    };
}
#pragma mark 有活动就弹出活动界面
-(void)setupActivityController:(NSArray*)Activity{
    UNITouristController* tourist = [[UNITouristController alloc]init];
    tourist.hasActivity = [Activity[0] intValue];
    tourist.activityId = [Activity[1] intValue];
    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:tourist];
    [self presentViewController:nav animated:YES completion:^{}];
}

#pragma mark
-(void)setupNavigation{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"main_img_function1"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn addTarget:self action:@selector(navigationControllerLeftBarAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureRecognizerAction:)];
   // swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:pan];

}
-(void)panGestureRecognizerAction:(UIPanGestureRecognizer*)x{
    CGPoint point = [x translationInView:self.view];
    if (x.state == UIGestureRecognizerStateChanged) {
        if (point.x>1){
            [self showViewController];}
    }
    
}

#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    [self showViewController];
}
-(void)showViewController{
  //  ViewController* view = [[ViewController alloc]init];
   UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController* view = [story instantiateViewControllerWithIdentifier:@"ViewController"];
    view.tv = self;
    view.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    if (IOS_VERSION>=8.0)
        view.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    else
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    
    [self presentViewController:view animated:NO completion:^{
        //  view.view.superview.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.3 animations:^{
            [view showViewAnimation];
        }];
        
    }];

}

#pragma mark 设置Scroller
-(void)setupScroller{
    
    bottomPage = 0;
    _bottomData = [NSMutableArray array];
    float tabX = 0;
    float tabY =0;
    float tabW = KMainScreenWidth ;
    float tabH = KMainScreenHeight - tabY;
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.backgroundColor = [UIColor clearColor];
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tabview];
    if (IOS_VERSION>8.0)
        tabview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    myTable =tabview;
    
   // float imgH = tabH*0.6-20;
    float imgH = KMainScreenWidth;
    CGRect topRe =CGRectMake(0,0,tabW,imgH);
    UIImageView* topImg = [[UIImageView alloc]initWithFrame:topRe];
    topImg.image = [UIImage imageNamed:@"main_img_goodsBg"];
    topImg.userInteractionEnabled = YES;
    tabview.tableHeaderView = topImg;
    headerImg = topImg;
    
    if (KMainScreenHeight<568)
        cellHight =(568-KMainScreenWidth)/3;
    else
        cellHight =(KMainScreenHeight-KMainScreenWidth)/3;
   // cellHight =KMainScreenWidth*101/414;
    
    [self setupTabViewHeader:topImg];
   
    __weak MainViewController* myself = self;
    tabview.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->bottomPage = 0;
        [myself requestBackGroundUrl1];
    }];
    
    tabview = nil;
    topImg=nil;
    
//    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, KMainScreenHeight)];
//    view.userInteractionEnabled = NO;
//    [self.view addSubview:view];
}

#pragma mark 创建  tableHeaderView
-(void)setupTabViewHeader:(UIImageView*)imageView{
    float imgW = imageView.frame.size.width;
    float imgH = imageView.frame.size.height;
    
    float proX =KMainScreenWidth*12/320;
    float proW = imgW/2 - proX;
    float proY =KMainScreenWidth*30/320;
    UNIMainProView* proView = [[UNIMainProView alloc]initWithFrame:CGRectMake(proX, proY, proW, proW)];
    proView.backgroundColor =[UIColor clearColor];
    proView.shapeColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.1];
    proView.progessColor = [UIColor colorWithHexString:kMainThemeColor];
    [proView setupProgreaa:0 and:0];
    [imageView addSubview:proView];
    progessView = proView;
    
    UIImage* fu =[UIImage imageNamed:@"main_img_shuang"];
    float img2H = proW*0.7;
    float img2W = img2H *fu.size.width / fu.size.height;
    UIImageView * shuangfu = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img2W, img2H)];
    shuangfu.userInteractionEnabled=YES;
   // shuangfu.image = fu;
    shuangfu.center =CGPointMake(proView.center.x, proView.center.y+10) ;
    [imageView addSubview:shuangfu];
    goodsImg = shuangfu;
    
    UIButton* proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proBtn.frame = progessView.frame;
    __weak MainViewController* myself = self;
    [[proBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         if (self->goodId1<1)
             return ;
         NSString* str1 = [NSString stringWithFormat:@"%d",self->goodId1];
         NSString* str2 = [NSString stringWithFormat:@"%d",self->type1];
         //[self UNIGoodsWebDelegateMethodAndprojectId:str1 Andtype:str2];
         [myself UNIGoodsWebDelegateMethodAndprojectId:str1 Andtype:str2 AndIsHeaderShow:0];
         str1=nil;
         str2=nil;
         [[BaiduMobStat defaultStat]logEvent:@"btn_main_bottle" eventLabel:@"首页瓶子礼品点击"];
     }];
    [imageView addSubview:proBtn];

    float lab1W = proW;
    float lab1H = 25;
    float lab1Y = CGRectGetMaxY(proView.frame)-lab1H/2 -5;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(proX, lab1Y, lab1W, lab1H)];
//    lab1.text = @"9/10";
    lab1.textColor = [UIColor whiteColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>400?20:15];
    lab1.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:lab1];
    progessLab = lab1;
    
    
    float lab2W = imgH/2-8;
    float lab2H = 25;
    float lab2Y =KMainScreenWidth>400?85:60;
    float lab2X = imgW/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab2Y, lab2W, lab2H)];
//    lab2.text = @"再预约次数";
    lab2.textColor = [UIColor whiteColor];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab2.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:lab2];
    goods1 = lab2;
    
    float lab3H =KMainScreenWidth>400?50:40;
    float lab3Y =CGRectGetMaxY(lab2.frame)+2;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab3Y, lab2W, lab3H)];
//    lab3.text = @"1";
    lab3.textColor = [UIColor whiteColor];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth>400?45:35];
    lab3.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:lab3];
    numLab = lab3;
    
    float lab4H = KMainScreenWidth>400?20:17;
    float lab4Y =CGRectGetMaxY(lab3.frame)+2;
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab4Y, lab2W, lab4H)];
//    lab4.text = @"可获得一支";
    lab4.textColor = [UIColor whiteColor];
    lab4.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab4.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:lab4];
    goods2 = lab4;
    
    float lab5H = lab4H;
    float lab5Y =CGRectGetMaxY(lab4.frame)+2;
    UILabel* lab5 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab5Y, lab2W, lab5H)];
//    lab5.text = @"300ml ALBION 爽肤精萃液";
    lab5.textColor = [UIColor whiteColor];
    lab5.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab5.textAlignment = NSTextAlignmentCenter;
    lab5.numberOfLines = 0;
    lab5.lineBreakMode = 0;
    [imageView addSubview:lab5];
    goodsLab = lab5;
    
    float layX = 10;
    float layY = imgH/4*3;
    float layW = imgW - layX*2;
    CALayer* lay =[CALayer layer];
    lay.frame = CGRectMake(layX, layY, layW, 0.5);
    lay.backgroundColor = [UIColor whiteColor].CGColor;
    [imageView.layer addSublayer:lay];
   
    
    UIImage* iage = [UIImage imageNamed:@"main_img_kezhuang"];
    //float imgVX = KMainScreenWidth>400?20:15;
    float imgVX = 20;
    float imgVH = cellHight/3.5;
    float imgVW = iage.size.width * imgVH / iage.size.height;
//    float imgVW = KMainScreenWidth>400?50:40;
//    float imgVH = (iage.size.height* imgVW / iage.size.width);
    float imgVY = imgH/4*3+ ((imgH/4 - imgVH)/2);
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgVX, imgVY, imgVW, imgVH)];
    img.image = iage;
    [imageView addSubview:img];
    
    float lab6H = 20;
   // float lab6Y = CGRectGetMaxY(lay.frame)+(KMainScreenWidth>400?30:25);
    float lab6Y = img.center.y - lab6H - 2;
    float lab6X = 16+20+cellHight/3.5;
    float lab6W = imgW - lab6X - proX*2;
    UILabel* lab6 = [[UILabel alloc]initWithFrame:CGRectMake(lab6X, lab6Y, lab6W, lab6H)];
//    lab6.text = @"ALBION清新莹润滋养护理（五次）";
    lab6.textColor = [UIColor whiteColor];
    lab6.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:14];
    [imageView addSubview:lab6];
    sell1 = lab6;
    
    //float lab7Y =CGRectGetMaxY(lab6.frame)+11;
    float lab7Y =img.center.y+5;
    float lab7W = KMainScreenWidth*80/320;
    UILabel* lab7 = [[UILabel alloc]initWithFrame:CGRectMake(lab6X, lab7Y, lab7W, lab6H)];
    lab7.text = @"活动价";
    lab7.textColor = [UIColor whiteColor];
    lab7.font = [UIFont systemFontOfSize:KMainScreenWidth>400?13:12];
    [lab7 sizeToFit];
    [imageView addSubview:lab7];
    sell3 = lab7;
    
//    float lab8Y =CGRectGetMaxY(lab6.frame)+4;
    float lab8Y =img.center.y+2;
    float lab8W = KMainScreenWidth*100/320;
    float lab8X = CGRectGetMaxX(lab7.frame);
    UILabel* lab8 = [[UILabel alloc]initWithFrame:CGRectMake(lab8X, lab8Y, lab8W, lab6H)];
//    lab8.text = @"￥899";
    lab8.textColor = [UIColor whiteColor];
    lab8.font = [UIFont systemFontOfSize:(KMainScreenWidth>400?19:17)];
    [imageView addSubview:lab8];
    sell2 = lab8;
    
    lab7.center = CGPointMake(lab7.center.x, lab8.center.y);
    
    UILabel* lab9 = [[UILabel alloc]initWithFrame:CGRectMake(lab6X, lab6Y, lab6W, lab6H*2)];
    lab9.text =[UNIHttpUrlManager sharedInstance].MORE_YH_TIPS;
    lab9.hidden=YES;
    lab9.textColor = [UIColor whiteColor];
    //lab9.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
    [imageView addSubview:lab9];
    sell4 = lab9;
    
    UIButton* alpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    alpBtn.frame = CGRectMake(0, imgH/4*3, KMainScreenWidth, imgH/4);
    [alpBtn setBackgroundColor: [UIColor clearColor]];
    [imageView addSubview:alpBtn];
    [[alpBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        UNIGoodsWeb* web = [[UNIGoodsWeb alloc]init];
        web.delegate = myself;
        [myself.navigationController pushViewController:web animated:YES];
        web=nil;
    }];
    alphBtn = alpBtn;
    
    alpBtn=nil; lab2=nil;lab3=nil;lab4=nil;lab5=nil;lab6=nil;lab7=nil;lab8=nil;lab9=nil;lay=nil; img=nil;shuangfu = nil;fu=nil;proView=nil;
}

#pragma mark
-(void)UNIGoodsWebDelegateMethodAndprojectId:(NSString *)ProjectId Andtype:(NSString *)Type AndIsHeaderShow:(int)isH{
    UIStoryboard* kz = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
    UNIGoodsDeatilController* good = [kz instantiateViewControllerWithIdentifier:@"UNIGoodsDeatilController"];
    good.projectId = ProjectId;
    good.type = Type;
    good.isHeadShow = isH;
    [self.navigationController pushViewController:good animated:YES];
    kz=nil; good=nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 0)
        return 1;
    if (section == 1)
        return _midData.count;
    if (section == 2)
        return _bottomData.count;
    if (section == 3)
        return 1;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"name"];
    if (!cell){
         __weak MainViewController* myself = self;
        cell = [[MainViewCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:@"name"];
                    [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
                     subscribeNext:^(UIButton* x) {
                         if (x.tag == -1){ //最后一个cell 自定义预约
                             [myself mainMidViewDelegataButton:nil];
                             return ;}
                         
                         id model = myself.bottomData[x.tag-1];
                         [myself mainMidViewDelegataButton:model];
                         
                     }];

    }
    
    if (indexPath.section == 0) {
        [cell setupCouponCell:couponArr];
    }
    if (indexPath.section == 1) {
        [cell setupCellWithData:_midData type:1 andTotal:appointTotal];
    }
    if (indexPath.section == 2) {
        cell.handleBtn.tag =indexPath.row+1;
        if (_bottomData.count>0)
            [cell setupCellWithData:_bottomData[indexPath.row] type:2 andTotal:-1];
    }
    if (indexPath.section == 3) {
        cell.handleBtn.tag = -1;
       [cell setupCustomCell];
    }
    
    
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0 ) {
        //[[NSNotificationCenter defaultCenter]postNotificationName:@"mainToMyCoupon" object:nil];
        UNIWalletController* view = [[UNIWalletController alloc]init];
        [self.navigationController pushViewController:view animated:YES];
    }
    if (indexPath.section==1 ) {
       
        if (_midData.count<1)
                return;
        UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController* midController = [main instantiateViewControllerWithIdentifier:@"MainMidController"];
        [self.navigationController pushViewController:midController animated:YES];
    }

    if (indexPath.section==2 ) {
        if (_bottomData.count<1)
            return;
        id model = self.bottomData[indexPath.row];
        [self mainMidViewDelegataButton:model];
    }

    if (indexPath.section==3) {
         [self mainMidViewDelegataButton:nil];
    }

    
}

#pragma mark  mainMidView代理方法 点击 mainMidView 的Cell
-(void)mainMidViewDelegataCell:(int)type{
    UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (type == 1) {
        UINavigationController* midController = [main instantiateViewControllerWithIdentifier:@"MainMidController"];
       // self.midController.myData = [NSMutableArray arrayWithArray:self.midData];
        [self.navigationController pushViewController:midController animated:YES];
    }
}

#pragma mark  mainMidView代理方法 点击 mainMidView 的button
-(void)mainMidViewDelegataButton:(id)model{
    
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNIAppointController* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointController"];
    appoint.model = model;
    [self.navigationController pushViewController:appoint animated:YES];
     [[BaiduMobStat defaultStat]logEvent:@"btn_appoint_main" eventLabel:@"首页预约按钮"];
}

#pragma mark 请求店铺信息
-(void)startRequestShopInfo{
 //__weak MainViewController* myself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //AccountManager* manager = [AccountManager shared];
      
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_URL_ShopInfo]
                          params:nil];
        request.reshopInfoBlock=^(UNIShopManage* manager,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    if (manager) {
//                        if (manager.shortName.length>0)
//                            myself.title =[NSString stringWithFormat:@"欢迎来到%@",manager.shortName];
//                        else
//                            myself.title =[NSString stringWithFormat:@"欢迎来到%@",manager.shopName];
                    }
                     if (!manager.shopName)
                        //检测不到店铺信息 需要重新登录
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"setupLoginController" object:nil];
                    
                }else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
            
        };
    });
}

#pragma mark 请求约满信息
-(void)startRequestReward{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //请求约满奖励
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_URL_MRInfo]
                           params:nil];
        request1.rerewardBlock=^(int nextRewardNum,int num,int type,int goodid,NSString* url,NSString* projectName,NSString* title,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    if (nextRewardNum>0) {
                        self->type1 = type;
                        self->goodId1 = goodid;
                        
                        if (num>nextRewardNum)
                            self->progessLab.text = [NSString stringWithFormat:@"%d/%d",nextRewardNum,nextRewardNum];
                        else
                            self->progessLab.text = [NSString stringWithFormat:@"%d/%d",num,nextRewardNum];
                        
                        [self->progessView setupProgreaa:num and:nextRewardNum];
                        // NSString* usrl = [NSString stringWithFormat:@"%@%@",API_IMG_URL,url];
                        [self->goodsImg sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (!image)
                                return ;
                            CGPoint center = self->goodsImg.center;
                            CGRect goodsRect = self->goodsImg.frame;
                            goodsRect.size.width = self->goodsImg.frame.size.height * image.size.width / image.size.height;
                            self->goodsImg.frame = goodsRect;
                            self->goodsImg.center = center;
                            
                        }];
                        if (nextRewardNum>num) {
                            self->numLab.text = [NSString stringWithFormat:@"%d",nextRewardNum - num];
                            self->numLab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?45:35];
                            self->goods1.hidden=NO;
                            self->goods1.text = @"再预约次数";
                        }if (nextRewardNum <= num) {
                            self->numLab.text = @"恭喜您!";
                            self->numLab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?17:15];
                            self->goods1.hidden=YES;
                        }
                        self->goods2.text = title;
                        self->goodsLab.text = projectName;
//                        NSRange yuan = [projectName rangeOfString:@"元"];
//                        if (yuan.length>0) {
//                            self->goods2.text=[NSString stringWithFormat:@"可获得%@",[projectName substringToIndex:yuan.location+1]];
//                            self->goodsLab.text = [projectName substringFromIndex:yuan.location+1];
//                        }
                    }else{
                        self->numLab.text = nil;
                        self->goods1.text= nil;
                        self->progessLab.text = nil;
                        self->goods2.text=nil;
                        self->goodsLab.text = nil;
                        [self->progessView setupProgreaa:0 and:0];
                    }
                }else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
    });

}

#pragma mark 开始请求我已预约项目
-(void)startRequestAppointInfo{
    __weak MainViewController* myself = self;
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_URL_Appoint]
                          params:@{@"page":@(0),@"size":@(1)}];
        request.reappointmentBlock =^(int count,NSArray* myAppointArr,NSString* tips,NSError* err){
            [self startRequestProjectInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->myTable.header endRefreshing];
                if (!err) {
                    self->appointTotal = count;
                    myself.midData = nil;
                    myself.midData = myAppointArr;
                    [self->myTable reloadData];
                       // [self.midView startReloadData:myAppointArr andType:1];
                   
//                    else
//                        [YIToast showText:tips];
                }else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
}
#pragma mark 开始请求我的项目
-(void)startRequestProjectInfo{
    __weak MainViewController* myself = self;
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_URL_MyProjectInfo]
                           params:@{@"page":@(bottomPage),@"size":@(10)}];
        request1.remyProjectBlock =^(NSArray* myProjectArr,int count,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!err) {
                    [self->myTable.footer endRefreshing];
                    //刷新侧边栏我的礼包的数量
                    myself.giftNum = count;
                    
                    if (self->bottomPage<1)
                        [myself.bottomData removeAllObjects];
                    
                    if (myProjectArr.count<10)
                        [self->myTable.footer endRefreshingWithNoMoreData];
                    
                    [myself.bottomData addObjectsFromArray: myProjectArr];
                
                    [self->myTable reloadData];
                    [myself addTableViewReflashFootView];
                
                }
                else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
}
#pragma mark 判断是否添加上拉加载
-(void)addTableViewReflashFootView{
    if (myTable.footer){
        return;}
        __weak MainViewController* myself = self;
        myTable.footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self->bottomPage++;
            [myself startRequestProjectInfo];
        }];

}

#pragma mark 获取背景图片 和 奖励商品图片
-(void)getBgImageAndGoodsImage{
   
    MainViewRequest* request1 = [[MainViewRequest alloc]init];
    int shopId =[[AccountManager shopId]intValue];
    NSString* code = [NSString stringWithFormat:@"%d_prize_shop,%d_index_bg",shopId,shopId];
    [request1 postWithSerCode:@[API_URL_GetImgByshopIdCode]
                       params:@{@"code":code}];
    request1.reMainBgBlock =^(NSArray* result,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!err) {
                for (NSDictionary* dic in result) {
                    NSString* code = [dic valueForKey:@"code"];
                    NSString* url = [dic valueForKey:@"url"];
                   // NSString* usrl = [NSString stringWithFormat:@"%@%@",API_IMG_URL,url];
                    if ([code hasSuffix:@"_bg"]) {
                        [self->headerImg sd_setImageWithURL:[NSURL URLWithString:url]
                                           placeholderImage:[UIImage imageNamed:@"main_img_goodsBg"]];
                    }
                    code=nil; url = nil;
                }
            }
            else
                [YIToast showText:NETWORKINGPEOBLEM];
        });
    };
}
#pragma mark 获取首页销售商品信息
-(void)getSellInfo{
    MainViewRequest* request1 = [[MainViewRequest alloc]init];
    [request1 postWithSerCode:@[API_URL_GetSellInfo2]
                       params:@{@"projcetId":@"",@"type":@"2",@"isHeadShow":@(1)}];
    request1.resellInfoBlock =^(NSArray* arr,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!err) {
                if (arr.count>0) {
                    self->sellGoods = arr;
                    UNIGoodsModel* info = arr[0];
                    self->sell1.text = info.projectName;
//                    if (info.shopPrice>1)
//                        self->sell2.text = [NSString stringWithFormat:@"￥%.f",info.shopPrice];
//                    else
                        self->sell2.text = [NSString stringWithFormat:@"￥%.f",info.shopPrice];
                    self->sell3.hidden=NO;
                    self->sell4.hidden=YES;
                    self->sellBtn.hidden=NO;
                    self->alphBtn.enabled=YES;
                }else{
                    self->sell1.text = @"";
                    self->sell2.text = @"";
                    self->sell3.hidden=YES;
                    self->sell4.text = [UNIHttpUrlManager sharedInstance].MORE_YH_TIPS;
                    self->sell4.hidden=NO;
                    self->sellBtn.hidden=YES;
                    self->alphBtn.enabled=NO;
                }
            }
            else
                [YIToast showText:NETWORKINGPEOBLEM];
        });
    };
}

#pragma mark 获取APP提示信息
-(void)requestAppTips{
    MainViewRequest* request1 = [[MainViewRequest alloc]init];
    [request1 postWithSerCode:@[API_URL_GetAppTips]
                       params:nil];
    request1.rqAppTips=^(NSDictionary* dic,NSString* tips,NSError* err){
        UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
        [manager initHttpUrlManager:dic];
    };
}


#pragma mark 注册通知
-(void)setupNotification{
    //预约成功后 刷新 列表 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appointSuccessAndReflash) name:APPOINTANDREFLASH object:nil];
}

-(void)appointSuccessAndReflash{
    if ([AccountManager token]) {
        [myTable.header beginRefreshing];
        [self showGuideView:MAINGUIDE];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"setupLoginController" object:nil];
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:APPOINTANDREFLASH object:nil];
}

-(void)changeNavigationBarAlpha:(CGFloat)alp{
    //导航栏颜色渐变透明
    [[[self.navigationController.navigationBar subviews]objectAtIndex:0] setAlpha:alp];
}

#pragma mark 颜色转图片
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
