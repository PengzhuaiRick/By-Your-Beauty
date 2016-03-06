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
#import "UNIGoodsWeb.h"
#import "UNIHttpUrlManager.h"

@interface MainViewController ()</*UINavigationControllerDelegate,*/MainMidViewDelegate,UITableViewDataSource,UITableViewDelegate,UNIGoodsWebDelegate>{
    UITableView* myTable;
    UITableView* footTableView;
    float cellHight;
    int appointTotal;
    int type1;
    int goodId1;
    
    CGRect topRe;
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
    
    UIButton* backTopBtn;//返回顶部按钮

}
@property(nonatomic,strong) NSArray* midData;
@property(nonatomic,strong) NSArray* bottomData;
@property(nonatomic,strong) MainMidController* midController ;
@property(nonatomic,strong) MainBottomController* buttomController;
@end

@implementation MainViewController

-(void)viewWillAppear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    backTopBtn.enabled = YES;
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    backTopBtn.enabled = NO;
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupScroller];
    [self startRequestShopInfo];//请求商家信息
    [self startRequestReward];//请求约满信息
    [self startRequestAppointInfo];//请求我已预约
   [self getBgImageAndGoodsImage];//请求背景图片 和 奖励商品图片
    [self getSellInfo]; //获取首页销售商品
    [self setupNotification];//注册通知

    //[self addLocateNotication];
}
-(void)addLocateNotication{
    NSMutableArray* arr = [NSMutableArray array];
    for (int i =0 ; i<2; i++) {
        
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        NSTimeZone* zo = [NSTimeZone systemTimeZone];
        
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:24*60*60*i];
        
        NSInteger interval = [zo secondsFromGMTForDate: date];
        
        NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
        
       // localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*i];
        localNotification.fireDate = localeDate;
        //设置本地通知的时区
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        //设置通知的内容
        localNotification.alertBody =  @"您预约的服务时间还有一小时";
        //设置通知动作按钮的标题
        localNotification.alertAction = @"查看";
        //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
        
        NSDictionary *infoDic = @{@"OrderId":@"1223",@"useId":[AccountManager userId]};
        localNotification.userInfo = infoDic;
        //在规定的日期触发通知
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        NSDictionary* dic = @{@"time":localNotification.fireDate,
                              @"OrderId":@"1223",
                              @"useId":[AccountManager userId]};
        [arr addObject:dic];
    }
    
    NSUserDefaults* userD = [NSUserDefaults standardUserDefaults];
    [userD setValue:arr forKey:@"appointArr"];
    [userD synchronize];
}

#pragma mark
-(void)setupNavigation{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]init];
    bar.image = [UIImage imageNamed:@"main_btn_function"];
    bar.style = UIBarButtonItemStyleDone;
    bar.target = self;
    bar.action=@selector(navigationControllerLeftBarAction:);
    self.navigationItem.leftBarButtonItem = bar;
     self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:0 target:self action:nil];
    
    UIButton* stateBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    stateBtn.frame = CGRectMake(40, -20, KMainScreenWidth-80, 60);
    stateBtn.backgroundColor = [UIColor clearColor];
    //[[UIApplication sharedApplication].keyWindow addSubview:stateBtn];
    [self.navigationController.view addSubview:stateBtn];
    backTopBtn = stateBtn;
    [[stateBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        NSLog(@"顶部");
        CGPoint p = CGPointMake(0, 0);
        [self->myTable setContentOffset:p animated:YES];
    }];
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
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tabview];
    if (IOS_VERSION>8.0)
        tabview.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
    myTable =tabview;
    
    float imgH = tabH*0.6;
    topRe =CGRectMake(0,0,tabW,imgH);
    UIImageView* topImg = [[UIImageView alloc]initWithFrame:topRe];
    //topImg.image = [UIImage imageNamed:@"main_img_top"];
    topImg.userInteractionEnabled = YES;
    tabview.tableHeaderView = topImg;
    headerImg = topImg;
    
    if (KMainScreenHeight<568)
        cellHight =(568-64-imgH)/2;
    else
        cellHight =(KMainScreenHeight-64-imgH)/2;
    
    [self setupTabViewHeader:topImg];
   
    tabview.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequestReward];//请求约满信息
        [self startRequestAppointInfo];//请求我已预约
        [self getBgImageAndGoodsImage];//请求背景图片 和 奖励商品图片
        [self getSellInfo]; //获取首页销售商品
        //[self startRequestProjectInfo];//请求我的项目
    }];
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
    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
//    [[tap rac_gestureSignal] subscribeNext:^(id x) {
//        if (self->goodId1<1)
//            return ;
//        NSString* str1 = [NSString stringWithFormat:@"%d",self->goodId1];
//        NSString* str2 = [NSString stringWithFormat:@"%d",self->type1];
//        //[self UNIGoodsWebDelegateMethodAndprojectId:str1 Andtype:str2];
//        [self UNIGoodsWebDelegateMethodAndprojectId:str1 Andtype:str2 AndIsHeaderShow:0];
//    }];
//    [shuangfu addGestureRecognizer:tap];
   
    
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
    float imgVX = KMainScreenWidth>400?20:15;
    float imgVH = cellHight/3;
    float imgVW = iage.size.width * imgVH / iage.size.height;
//    float imgVW = KMainScreenWidth>400?50:40;
//    float imgVH = (iage.size.height* imgVW / iage.size.width);
    float imgVY = imgH/4*3+ ((imgH/4 - imgVH)/2);
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgVX, imgVY, imgVW, imgVH)];
    img.image = iage;
    [imageView addSubview:img];
    
//    float btnWH =  KMainScreenWidth*70/414;
//    float btnY =imgH/4*3+(imgH/4 - btnWH)/2;
//    float btnX = imgW - btnWH - imgVX;
//    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
//    btn.titleLabel.numberOfLines = 0;
//    btn.titleLabel.lineBreakMode = 0;
//    [btn setTitle:@"马上\n购买" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*18/414];
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = btnWH/2;
//    btn.layer.borderColor = [UIColor whiteColor].CGColor;
//    btn.layer.borderWidth = 1;
//    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[self createImageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]] forState:UIControlStateHighlighted];
//    [imageView addSubview:btn];
//    sellBtn = btn;
//    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
//    subscribeNext:^(id x) {
//        if (self->sellGoods.count<1)
//            return ;
//        UNIGoodsModel* info = self->sellGoods.lastObject;
//        NSString* str = [NSString stringWithFormat:@"%d",info.projectId];
//        [self UNIGoodsWebDelegateMethodAndprojectId:str Andtype:@"2" AndIsHeaderShow:1];
//    }];
    
    
    float lab6H = 20;
   // float lab6Y = CGRectGetMaxY(lay.frame)+(KMainScreenWidth>400?30:25);
    float lab6Y = img.center.y - lab6H - 2;
    float lab6X = CGRectGetMaxX(img.frame)+20;
    float lab6W = imgW - lab6X - proX*2;
    UILabel* lab6 = [[UILabel alloc]initWithFrame:CGRectMake(lab6X, lab6Y, lab6W, lab6H)];
//    lab6.text = @"ALBION清新莹润滋养护理（五次）";
    lab6.textColor = [UIColor whiteColor];
    lab6.font = [UIFont systemFontOfSize:KMainScreenWidth*16/414];
    [imageView addSubview:lab6];
    sell1 = lab6;
    
    //float lab7Y =CGRectGetMaxY(lab6.frame)+11;
    float lab7Y =img.center.y+5;
    float lab7W = KMainScreenWidth*80/320;
    UILabel* lab7 = [[UILabel alloc]initWithFrame:CGRectMake(lab6X, lab7Y, lab7W, lab6H)];
    lab7.text = @"活动价";
    lab7.textColor = [UIColor whiteColor];
    lab7.font = [UIFont systemFontOfSize:KMainScreenWidth>400?12:10];
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
    lab8.font = [UIFont systemFontOfSize:(KMainScreenWidth>400?20:17)];
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
        web.delegate = self;
        [self.navigationController pushViewController:web animated:YES];
    }];
    alphBtn = alpBtn;
}

#pragma mark 设置footerTable
-(void)setupTableViewFooter{
    int num =(int)_bottomData.count;
    if (num<1)
        num=1;
    if (footTableView) {
        CGRect footR =footTableView.frame;
        footR.size.height = num*cellHight;
        footTableView.frame = footR;
        [footTableView reloadData];
        
        footTableView.contentSize =CGSizeMake(footTableView.frame.size.width, num*cellHight);
        myTable.contentSize = CGSizeMake(myTable.frame.size.width, myTable.frame.size.height + --num*cellHight);
        return;
    }
    
    float tabW = KMainScreenWidth ;
    float tabH =num*cellHight;
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, tabW, tabH) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.backgroundColor = [UIColor clearColor];
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabview.showsVerticalScrollIndicator=NO;
    myTable.tableFooterView = tabview;
    footTableView = tabview;

}

#pragma mark
-(void)UNIGoodsWebDelegateMethodAndprojectId:(NSString *)ProjectId Andtype:(NSString *)Type AndIsHeaderShow:(int)isH{
    UIStoryboard* kz = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
    UNIGoodsDeatilController* good = [kz instantiateViewControllerWithIdentifier:@"UNIGoodsDeatilController"];
    good.projectId = ProjectId;
    good.type = Type;
    good.isHeadShow = isH;
    [self.navigationController pushViewController:good animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int cellNum = 1;
    if (tableView == footTableView) {
        if (_bottomData.count>0)
            cellNum =(int)_bottomData.count;
    }
    return cellNum;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"name"];
   
    if (tableView == myTable) {
        if (!cell)
            cell = [[MainViewCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:@"name"];
            [cell setupCellWithData:_midData type:1 andTotal:appointTotal];

    }else if (tableView == footTableView){
        if (!cell){
            cell = [[MainViewCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:@"name"];
            cell.handleBtn.tag = indexPath.row+1;
            [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
             subscribeNext:^(UIButton* x) {
                 id model = self.bottomData[x.tag-1];
                 [self mainMidViewDelegataButton:model];
             }];
        }
            [cell setupCellWithData:_bottomData[indexPath.row] type:2 andTotal:-1];
    }
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == myTable) {
        UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        if (indexPath.row == 0) {
            if (_midData.count<1)
                return;
            
            self.midController = [main instantiateViewControllerWithIdentifier:@"MainMidController"];
            [self.navigationController pushViewController:self.midController animated:YES];
        }
    }
    if (tableView == footTableView) {
        if (_bottomData.count>0){
            id model = self.bottomData[indexPath.row];
            [self mainMidViewDelegataButton:model];
        }
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
                        if (manager.shortName.length>0)
                            self.title =[NSString stringWithFormat:@"欢迎来到%@",manager.shortName];
                        else
                            self.title =[NSString stringWithFormat:@"欢迎来到%@",manager.shopName];
                    }
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
        request1.rerewardBlock=^(int nextRewardNum,int num,int type,int goodid,NSString* url,NSString* projectName,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    if (nextRewardNum>0) {
                        self->type1 = type;
                        self->goodId1 = goodid;
                        self->progessLab.text = [NSString stringWithFormat:@"%d/%d",num,nextRewardNum];
                        [self->progessView setupProgreaa:num and:nextRewardNum];
                         NSString* usrl = [NSString stringWithFormat:@"%@%@",API_IMG_URL,url];
                        [self->goodsImg sd_setImageWithURL:[NSURL URLWithString:usrl]];
                        if (nextRewardNum>num) {
                            self->numLab.text = [NSString stringWithFormat:@"%d",nextRewardNum - num];
                            self->numLab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?45:35];
                            self->goods1.hidden=NO;
                            self->goods1.text = @"再预约次数";
                        }if (nextRewardNum <= num) {
                            self->numLab.text = @"恭喜您!";
                            self->numLab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:13];
                            self->goods1.hidden=YES;
                        }
                        NSRange yuan = [projectName rangeOfString:@"元"];
                        if (yuan.length>0) {
                            self->goods2.text=[NSString stringWithFormat:@"可获得%@",[projectName substringToIndex:yuan.location+1]];
                            self->goodsLab.text = [projectName substringFromIndex:yuan.location+1];
                        }
                    }
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
                          params:@{@"page":@(0),@"size":@(1)}];
        request.reappointmentBlock =^(int count,NSArray* myAppointArr,NSString* tips,NSError* err){
            [self startRequestProjectInfo];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->myTable.header endRefreshing];
                if (!err) {
                    self->appointTotal = count;
                    self.midData = nil;
                    self.midData = myAppointArr;
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
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_PARAM_UNI,API_URL_MyProjectInfo]
                           params:@{@"page":@(0),@"size":@(50)}];
        request1.remyProjectBlock =^(NSArray* myProjectArr,int count,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!err) {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"flashTheCellNum" object:nil userInfo:@{@"count":@(count)}];
                    self.bottomData = nil;
                    
                        self.bottomData=myProjectArr;
                        [self setupTableViewFooter];
                }
                else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
}

#pragma mark 获取背景图片 和 奖励商品图片
-(void)getBgImageAndGoodsImage{
    MainViewRequest* request1 = [[MainViewRequest alloc]init];
    int shopId =[[AccountManager shopId]intValue];
    NSString* code = [NSString stringWithFormat:@"%d_prize_shop,%d_index_bg",shopId,shopId];
    [request1 postWithSerCode:@[API_PARAM_UNI,API_URL_GetImgByshopIdCode]
                       params:@{@"code":code}];
    request1.reMainBgBlock =^(NSArray* result,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!err) {
                for (NSDictionary* dic in result) {
                    NSString* code = [dic valueForKey:@"code"];
                    NSString* url = [dic valueForKey:@"url"];
                    NSString* usrl = [NSString stringWithFormat:@"%@%@",API_IMG_URL,url];
                    if ([code hasSuffix:@"_bg"]) {
                        [self->headerImg sd_setImageWithURL:[NSURL URLWithString:usrl]];
                    }
//                    if ([code hasSuffix:@"_shop"]) {
//                        [self->goodsImg sd_setImageWithURL:[NSURL URLWithString:usrl]];
//                    }
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
    [request1 postWithSerCode:@[API_PARAM_UNI,API_URL_GetSellInfo2]
                       params:@{@"projcetId":@"",@"type":@"2",@"isHeadShow":@(1)}];
    request1.resellInfoBlock =^(NSArray* arr,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!err) {
                if (arr.count>0) {
                    self->sellGoods = arr;
                    UNIGoodsModel* info = arr[0];
                    self->sell1.text = info.projectName;
                    if (info.shopPrice>1)
                        self->sell2.text = [NSString stringWithFormat:@"￥%.f",info.shopPrice];
                    else
                        self->sell2.text = [NSString stringWithFormat:@"￥%.2f",info.shopPrice];
                    self->sell3.hidden=NO;
                    self->sell4.hidden=YES;
                    self->sellBtn.hidden=NO;
                    self->alphBtn.enabled=YES;
                }else{
                    self->sell1.text = @"";
                    self->sell2.text = @"";
                    self->sell3.hidden=YES;
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

//#pragma mark <UINavigationControllerDelegate>
//- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
//                                   animationControllerForOperation:(UINavigationControllerOperation)operation
//                                                fromViewController:(UIViewController *)fromVC
//                                                  toViewController:(UIViewController *)toVC{
//    if ([toVC isKindOfClass:[MainMidController class]]||[toVC isKindOfClass:[MainBottomController class]]){
//      
//    MainMoveTransition *transition = [[MainMoveTransition alloc]init];
//        return transition;
//    }
//    return nil;
//                                                            
//}
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
