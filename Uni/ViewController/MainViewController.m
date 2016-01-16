//
//  MainViewController.m
//  Uni
//  首页界面
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "MainMidController.h"
#import "MainBottomController.h"
#import "MainMoveTransition.h"
#import "MainViewRequest.h"
#import "AccountManager.h"
#import "UNIAppointController.h"
#import <MJRefresh/MJRefresh.h>

#import "UNIGoodsDeatilController.h"
#import "UIAlertView+Blocks.h"
#import "MainViewCell.h"

#import "UNIMainProView.h"

@interface MainViewController ()<UINavigationControllerDelegate,MainMidViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView* myTable;
    float cellHight;
    int appointTotal;
    CGRect topRe;
    UILabel* progessLab; //9/10
    UILabel* goodsLab; //约满奖励商品名称
    UILabel* numLab; //再预约次数
    UNIMainProView* progessView;//进度条

}
@property(nonatomic,strong) NSArray* midData;
@property(nonatomic,strong) NSArray* bottomData;
@property(nonatomic,strong) MainMidController* midController ;
@property(nonatomic,strong) MainBottomController* buttomController;
@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
   self.navigationController.delegate = nil;
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
    [self setupScroller];
    //[self addChildController];
     //[self addChildController1];
    [self startRequestShopInfo];//请求商家信息
    [self startRequestReward];//请求约满信息
    [self startRequestAppointInfo];//请求我已预约
   // [self startRequestProjectInfo];//请求我的项目
    
    [self setupNotification];//注册通知
}
#pragma mark
-(void)setupNavigation{
   
    [self preferredStatusBarStyle];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]init];
    bar.image = [UIImage imageNamed:@"main_btn_function"];
    bar.style = UIBarButtonItemStyleDone;
    bar.target = self;
    bar.action=@selector(navigationControllerLeftBarAction:);
    self.navigationItem.leftBarButtonItem = bar;
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
}
#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{

    if (self.containController.closing) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWOPEN object:nil];
    }
    else{
         [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWCLOSE object:nil];
    }
}
#pragma mark 跳转客妆界面
-(void)navigationControllerRightBarAction:(UIBarButtonItem*)bar{
    UIStoryboard* kz = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
   UNIGoodsDeatilController* good = [kz instantiateViewControllerWithIdentifier:@"UNIGoodsDeatilController"];
    [self.navigationController pushViewController:good animated:YES];
    
}

#pragma mark 设置Scroller
-(void)setupScroller{
    
    float tabX = 0;
    float tabY = 64;
    float tabW = KMainScreenWidth ;
    float tabH = KMainScreenHeight - tabY;
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.backgroundColor = [UIColor clearColor];
    tabview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tabview];
    if (IOS_VERSION>8.0)
        tabview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    myTable =tabview;
    
    float imgH = tabH*0.6;
    topRe =CGRectMake(0,0,tabW,imgH);
    UIImageView* topImg = [[UIImageView alloc]initWithFrame:topRe];
    topImg.image = [UIImage imageNamed:@"main_img_top"];
    topImg.userInteractionEnabled = YES;
    tabview.tableHeaderView = topImg;
    
    [self setupTabViewHeader:topImg];

    
    if (KMainScreenHeight<568)
        cellHight =(568-64-imgH)/2;
    else
        cellHight =(KMainScreenHeight-64-imgH)/2;
    
    tabview.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
         [self startRequestReward];//请求约满信息
        [self startRequestAppointInfo];//请求我已预约
        //[self startRequestProjectInfo];//请求我的项目
    }];
}

#pragma mark 创建  tableHeaderView
-(void)setupTabViewHeader:(UIImageView*)imageView{
    float imgW = imageView.frame.size.width;
    float imgH = imageView.frame.size.height;
    
    float proX =KMainScreenWidth*12/320;
    float proW = imgW/2;
    float proY =KMainScreenWidth*20/320;
    UNIMainProView* proView = [[UNIMainProView alloc]initWithFrame:CGRectMake(proX, proY, proW, proW)];
    proView.backgroundColor =[UIColor clearColor];
    proView.shapeColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.1];
    proView.progessColor = [UIColor colorWithHexString:kMainThemeColor];
    [proView setupProgreaa:9 and:10];
    [imageView addSubview:proView];
    progessView = proView;
    
    UIImage* fu =[UIImage imageNamed:@"main_img_shuang"];
    float img2H = proW/2;
    float img2W = img2H *fu.size.width / fu.size.height;
    UIImageView * shuangfu = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img2W, img2H)];
    shuangfu.image = fu;
    shuangfu.center = proView.center;
    [imageView addSubview:shuangfu];
    
    float lab1W = proW;
    float lab1H = 25;
    float lab1Y = CGRectGetMaxY(proView.frame)-lab1H/2;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(proX, lab1Y, lab1W, lab1H)];
    lab1.text = @"9/10";
    lab1.textColor = [UIColor whiteColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    lab1.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:lab1];
    progessLab = lab1;
    
    
    float lab2W = imgH/2-8;
    float lab2H = 25;
    float lab2Y =KMainScreenWidth*50/320;
    float lab2X = imgW/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab2Y, lab2W, lab2H)];
    lab2.text = @"再预约次数";
    lab2.textColor = [UIColor whiteColor];
    lab2.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*12/320];
    lab2.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:lab2];
    
    float lab3H =45;
    float lab3Y =CGRectGetMaxY(lab2.frame);
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab3Y, lab2W, lab3H)];
    lab3.text = @"1";
    lab3.textColor = [UIColor whiteColor];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth*35/320];
    lab3.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:lab3];
    numLab = lab3;
    
    float lab4H = 25;
    float lab4Y =CGRectGetMaxY(lab3.frame);
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab4Y, lab2W, lab4H)];
    lab4.text = @"可获得一支";
    lab4.textColor = [UIColor whiteColor];
    lab4.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*12/320];
    lab4.textAlignment = NSTextAlignmentCenter;
    [imageView addSubview:lab4];
    
    float lab5H = 25;
    float lab5Y =CGRectGetMaxY(lab4.frame);
    UILabel* lab5 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab5Y, lab2W, lab5H)];
    lab5.text = @"300ml ALBION 爽肤精萃液";
    lab5.textColor = [UIColor whiteColor];
    lab5.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*12/320];
    lab5.textAlignment = NSTextAlignmentCenter;
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
    float imgVX = KMainScreenWidth*20/320;
    float imgVH = imgH/4/2;
    float imgVW = iage.size.width * imgVH / iage.size.height;
    float imgVY = imgH/4*3+ ((imgH/4 - imgVH)/2);
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgVX, imgVY, imgVW, imgVH)];
    img.image = iage;
    [imageView addSubview:img];
    
    float btnWH =  KMainScreenWidth*60/374;
    float btnY =imgH/4*3+(imgH/4 - btnWH)/2;
    float btnX = imgW - btnWH - imgVX;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.lineBreakMode = 0;
    [btn setTitle:@"马上\n购买" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*16/320];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btnWH/2;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    btn.layer.borderWidth = 1;
    [imageView addSubview:btn];
    
    
    float lab6H = 20;
    float lab6Y =imgH/4*3+(imgH/4/2-lab6H);
    float lab6X =CGRectGetMaxX(img.frame)+8;
    float lab6W = imgW - lab6X - btnWH - proX*3;
    UILabel* lab6 = [[UILabel alloc]initWithFrame:CGRectMake(lab6X, lab6Y, lab6W, lab6H)];
    lab6.text = @"ALBION清新莹润滋养护理（五次）";
    lab6.textColor = [UIColor whiteColor];
    lab6.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
    [imageView addSubview:lab6];
    
    float lab7Y =CGRectGetMaxY(lab6.frame);
    float lab7W = KMainScreenWidth*80/320;
    UILabel* lab7 = [[UILabel alloc]initWithFrame:CGRectMake(lab6X, lab7Y, lab7W, lab6H)];
    lab7.text = @"活动价";
    lab7.textColor = [UIColor whiteColor];
    lab7.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
    [lab7 sizeToFit];
    [imageView addSubview:lab7];
    
    float lab8Y =CGRectGetMaxY(lab6.frame);
    float lab8W = KMainScreenWidth*100/320;
    float lab8X = CGRectGetMaxX(lab7.frame);
    UILabel* lab8 = [[UILabel alloc]initWithFrame:CGRectMake(lab8X, lab8Y, lab8W, lab6H)];
    lab8.text = @"￥899";
    lab8.textColor = [UIColor whiteColor];
    lab8.font = [UIFont systemFontOfSize:KMainScreenWidth*15/320];
    [imageView addSubview:lab8];
    
    lab7.center = CGPointMake(lab7.center.x, lab8.center.y);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int cellNum = 2;
    return cellNum;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"name"];
    if (!cell) {
        cell = [[MainViewCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:@"name"];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
            [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
            subscribeNext:^(id x) {
                id model = self.bottomData[0];
                [self mainMidViewDelegataButton:model];
            }];
           
        }
    }
    if (indexPath.row == 0) {
            [cell setupCellWithData:_midData type:1 andTotal:appointTotal];

    }
    if (indexPath.row == 1) {
         [cell setupCellWithData:_bottomData type:2 andTotal:-1];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.row == 0) {
        self.midController = [main instantiateViewControllerWithIdentifier:@"MainMidController"];
        [self.navigationController pushViewController:self.midController animated:YES];
    }else if (indexPath.row  == 1){
        self.buttomController = [main instantiateViewControllerWithIdentifier:@"MainBottomController"];
        [self.navigationController pushViewController:self.buttomController animated:YES];
    }

}

#pragma mark  mainMidView代理方法 点击 mainMidView 的Cell
-(void)mainMidViewDelegataCell:(int)type{
    UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (type == 1) {
        self.midController = [main instantiateViewControllerWithIdentifier:@"MainMidController"];
       // self.midController.myData = [NSMutableArray arrayWithArray:self.midData];
        [self.navigationController pushViewController:self.midController animated:YES];
    }else if (type == 2){
        self.buttomController = [main instantiateViewControllerWithIdentifier:@"MainBottomController"];
        //self.buttomController.myData =  [NSMutableArray arrayWithArray:self.bottomData];;
        [self.navigationController pushViewController:self.buttomController animated:YES];
    }
}

#pragma mark  mainMidView代理方法 点击 mainMidView 的button
-(void)mainMidViewDelegataButton:(id)model{
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNIAppointController* appoint = [story instantiateViewControllerWithIdentifier:@"UNIAppointController"];
    appoint.model = model;
    [self.navigationController pushViewController:appoint animated:YES];
}

#pragma mark 请求店铺信息
-(void)startRequestShopInfo{

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //AccountManager* manager = [AccountManager shared];
      
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_PARAM_UNI,API_URL_ShopInfo]
                          params:nil];
        request.reshopInfoBlock=^(UNIShopManage* manager,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    if (manager) {
                        NSRange ra =[manager.shopName rangeOfString:@"【"];
                         self.title = [manager.shopName substringToIndex:ra.location];
                    }
//                    else
//                        [YIToast showText:tips];
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
        [request1 postWithSerCode:@[API_PARAM_UNI,API_URL_MRInfo]
                           params:nil];
        request1.rerewardBlock=^(int nextRewardNum,int num,NSString* projectName,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    self->progessLab.text = [NSString stringWithFormat:@"%d/%d",num,nextRewardNum];
                    [self->progessView setupProgreaa:num and:nextRewardNum];
                    self->goodsLab.text = projectName;
                    self->numLab.text = [NSString stringWithFormat:@"%d",nextRewardNum - num];
                }else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
    });

}

#pragma mark 开始请求我已预约项目
-(void)startRequestAppointInfo{
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_PARAM_UNI,API_URL_Appoint]
                          params:@{@"page":@(0),@"size":@(2)}];
        request.reappointmentBlock =^(int count,NSArray* myAppointArr,NSString* tips,NSError* err){
            [self startRequestProjectInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->myTable.header endRefreshing];
                if (!err) {
                    self->appointTotal = count;
                    self.midData = nil;
                    if (myAppointArr.count>0){
                        self.midData = myAppointArr;
                        [self->myTable reloadData];
                       // [self.midView startReloadData:myAppointArr andType:1];
                    }
//                    else
//                        [YIToast showText:tips];
                }else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
}
#pragma mark 开始请求我的项目
-(void)startRequestProjectInfo{
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_PARAM_UNI,API_URL_MyProjectInfo]
                           params:@{@"page":@(0),@"size":@(2)}];
        request1.remyProjectBlock =^(NSArray* myProjectArr,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!err) {
                    self.bottomData = nil;
                    if (myProjectArr.count>0){
                        self.bottomData=myProjectArr;
                        [self->myTable reloadData];
                       // [self.buttomView startReloadData:myProjectArr andType:2];
                    }
//                    else
//                        [YIToast showText:tips];
                }
                else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
}

#pragma mark 注册通知
-(void)setupNotification{
    //预约成功后 刷新 列表 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appointSuccessAndReflash) name:APPOINTANDREFLASH object:nil];
}

-(void)appointSuccessAndReflash{
    [myTable.header beginRefreshing];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:APPOINTANDREFLASH object:nil];
}

#pragma mark 设置状态栏字体颜色
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark <UINavigationControllerDelegate>
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if ([toVC isKindOfClass:[MainMidController class]]||[toVC isKindOfClass:[MainBottomController class]]){
      
    MainMoveTransition *transition = [[MainMoveTransition alloc]init];
        return transition;
    }
    return nil;
                                                            
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}


@end
