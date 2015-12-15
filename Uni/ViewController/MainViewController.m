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

@interface MainViewController ()<UINavigationControllerDelegate,MainMidViewDelegate,UITableViewDataSource,UITableViewDelegate>{
  //  __weak IBOutlet UIScrollView *myScroller;
    UITableView* myTable;
    float cellHight;
    UIImageView* topView;
    UILabel* shopNameLab;
    UILabel* shopAddressLab;
    UIImageView* VIPImage;
    UIImageView* shopLogo;
    
    CGRect topRe;
    CGRect midRe;
    CGRect buttomRe;
    
    CGRect midTabRe;
    CGRect buttonTabRe;
    
    CGSize scrollSize;
    
    UITapGestureRecognizer* midGesture;
    UITapGestureRecognizer* buttomGesture;
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

}
-(void)viewWillDisappear:(BOOL)animated{
   self.navigationController.delegate = nil;
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }

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
    [self startRequestProjectInfo];//请求我的项目
}
#pragma mark
-(void)setupNavigation{
    self.title = @"首页";
    [self preferredStatusBarStyle];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:kMainThemeColor];
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    UIBarButtonItem* bar = [[UIBarButtonItem alloc]init];
    bar.image = [UIImage imageNamed:@"main_btn_function"];
    bar.style = UIBarButtonItemStyleDone;
    bar.tintColor = [UIColor whiteColor];
    bar.target = self;
    bar.action=@selector(navigationControllerLeftBarAction:);
    self.navigationItem.leftBarButtonItem = bar;
    
    UIBarButtonItem* right = [[UIBarButtonItem alloc]initWithTitle:@"客妆" style:0 target:self action:@selector(navigationControllerRightBarAction:)];
    self.navigationItem.rightBarButtonItem = right;
}
#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    float x = self.containController.view.frame.origin.x;
    [UIView animateWithDuration:0.2 animations:^{
        if (x==0)
            self.containController.view.frame =
            CGRectMake(KMainScreenWidth-100,
                                         0,self.view.frame.size.width
                                         ,self.view.frame.size.height);
        else
            self.containController.view.frame =
            CGRectMake(0,
                       0,self.view.frame.size.width
                       ,self.view.frame.size.height);
 
    }];
}
#pragma mark 跳转客妆界面
-(void)navigationControllerRightBarAction:(UIBarButtonItem*)bar{
    UIStoryboard* kz = [UIStoryboard storyboardWithName:@"KeZhuang" bundle:nil];
   UNIGoodsDeatilController* good = [kz instantiateViewControllerWithIdentifier:@"UNIGoodsDeatilController"];
    [self.navigationController pushViewController:good animated:YES];
}

#pragma mark 设置Scroller
-(void)setupScroller{
   
    float tabX = 10;
    float tabY = 64+10;
//    if (IOS_VERSION<9.0)
        tabY = 7;
    float tabW = KMainScreenWidth - tabX*2;
    float tabH = KMainScreenHeight - tabX - tabY;
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.backgroundColor = [UIColor clearColor];
    tabview.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabview.showsVerticalScrollIndicator=NO;
    
    [self.view addSubview:tabview];
    myTable =tabview;
    
   // int bj = 8;   //边界
    int bj = 0;
    UIImage* imag =[UIImage imageNamed:@"main_img_top"];
    float imgH = imag.size.height*tabW/imag.size.width;
    topRe =CGRectMake(bj,bj,tabW,imgH);
    UIImageView* topImg = [[UIImageView alloc]initWithFrame:topRe];
    topImg.image = imag;
    //[myScroller addSubview:topImg];
    tabview.tableHeaderView = topImg;
    topView = topImg;
    
    if (KMainScreenHeight<568)
        cellHight =(568-64-tabX*2-topView.frame.size.height)/2;
    else
        cellHight =(KMainScreenHeight-64-tabX*2-topView.frame.size.height)/2;

    [self setupTopImageSubView];
    
    tabview.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self startRequestAppointInfo];//请求我已预约
        [self startRequestProjectInfo];//请求我的项目
    }];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"name"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        MainMidView* midview = [[MainMidView alloc]initWithFrame:
                                CGRectMake(0,5,  tableView.frame.size.width, cellHight-5) headerTitle:@"我已预约"];
        midview.delegate=self;
        [cell addSubview:midview];
        self.midView = midview;
    }
    if (indexPath.row == 1) {
        MainMidView* bottomView = [[MainMidView alloc]initWithFrame:
                                   CGRectMake(0,6,tableView.frame.size.width,cellHight-6)
                                                        headerTitle:@"我的项目"];
        bottomView.delegate = self;
        [cell addSubview:bottomView];
        self.buttomView = bottomView;

    }
    return cell;
}

#pragma mark 设置顶图的子视图
-(void)setupTopImageSubView{
    
    float imgW = topView.frame.size.width*0.16;
    UIImageView* shopLog = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, imgW, imgW)];
    shopLog.image = [UIImage imageNamed:@"main_img_shopLog"];
    shopLog.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:shopLog];
    shopLogo = shopLog;
    
    topView.userInteractionEnabled = YES;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toCardinfoController)];
    [topView addGestureRecognizer:tap];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopLog.frame)+10,
                                                            15, topView.frame.size.width*0.7, 20)];
    lab.textColor = [UIColor colorWithRed:226/255.f green:52/255.f blue:105/255.f alpha:1];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.041];
    lab.text = @"动静界健身美容尊尚会所";
    [topView addSubview:lab];
    shopNameLab = lab;
    
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopLog.frame)+10,
                                                            CGRectGetMaxY(lab.frame), 100, 15)];
    lab2.textColor = [UIColor colorWithRed:226/255.f green:52/255.f blue:105/255.f alpha:1];
    lab2.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.03];
    lab2.text = @"体育东店";
    [topView addSubview:lab2];
    shopAddressLab = lab2;
    
    UIImageView* VIPimg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(shopLog.frame)+10,
                                                                   CGRectGetMaxY(lab2.frame)+3, 100, 15)];
    VIPimg.image = [UIImage imageNamed:@"main_img_VIP"];
    VIPimg.contentMode = UIViewContentModeScaleAspectFit;
    [topView addSubview:VIPimg];
    VIPImage = VIPimg;
}
#pragma mark 跳转到会员卡使用详情界面
-(void)toCardinfoController{
    UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController* vc = [main instantiateViewControllerWithIdentifier:@"UNICardInfoController"];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark 点击手势跳转事件
-(void)showMoreInfo:(UIGestureRecognizer*)gesture{
    UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (gesture.view.tag == 10) {
        //[self midViewAnimationEvent];
         self.midController = [main instantiateViewControllerWithIdentifier:@"MainMidController"];
        self.midController.myData = [NSMutableArray arrayWithArray:self.midData];
        //self.midController.myData =self.midData;
        [self.navigationController pushViewController:self.midController animated:YES];
    }else if (gesture.view.tag == 11){
              //  [self buttomViewAnimationEvent];
        self.buttomController = [main instantiateViewControllerWithIdentifier:@"MainBottomController"];
        self.buttomController.myData =  [NSMutableArray arrayWithArray:self.bottomData];;
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

#pragma mark 添加两个列表
-(void)addChildController{
    MainMidView* midview = [[MainMidView alloc]initWithFrame:
                            CGRectMake(0, 0,  _midView.frame.size.width, _midView.frame.size.height) headerTitle:@"我已预约"];
    midview.delegate=self;
    [_midView addSubview:midview];
    
    
    MainMidView* bottomView = [[MainMidView alloc]initWithFrame:
                               CGRectMake(0, 0,  _buttomView.frame.size.width, _buttomView.frame.size.height)
                                                    headerTitle:@"我的项目"];
    bottomView.delegate = self;
    [_buttomView addSubview:bottomView];
}
#pragma mark 刷新商家信息
-(void)reflashShopInfo:(UNIShopManage*) manager{
    if (manager.shopName.length>11) {
        self->shopNameLab.text = [manager.shopName substringToIndex:11];
        self->shopAddressLab.text =[manager.shopName substringFromIndex:11];
    }else{
        self->shopNameLab.text = manager.shopName;
        CGRect re =self->shopAddressLab.frame;
        self->shopAddressLab.hidden=YES;
        self->VIPImage.frame = CGRectMake(re.origin.x, re.origin.y,
                                          self->VIPImage.frame.size.width,
                                          self->VIPImage.frame.size.height);
    }
    
    [self->shopLogo sd_setImageWithURL:[NSURL URLWithString:manager.logoUrl]
                      placeholderImage:[UIImage imageNamed:@"main_img_shopLog"]];

}

#pragma mark 请求店铺信息
-(void)startRequestShopInfo{
    UNIShopManage* shop = [UNIShopManage getShopData];
    if (shop.shopName) {
        [self reflashShopInfo:shop];
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //AccountManager* manager = [AccountManager shared];
      
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_PARAM_UNI,API_URL_ShopInfo]
                          params:nil];
        request.reshopInfoBlock=^(UNIShopManage* manager,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    if (manager) {
                        [self reflashShopInfo:manager];//刷新商家信息
                    }else
                        [YIToast showText:tips];
                }else
                    [YIToast showText:tips];
                
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
                           params:@{@"shopId":@(1),
                                    @"token":@"abcdxxa",
                                    @"userId":@(1)}];
        request1.rerewardBlock=^(int nextRewardNum,int num,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    if (nextRewardNum!=-1) {
                        float jc = (self->topView.frame.size.width-30)/10;
                        float y = nextRewardNum/10;
                        for (int i = 0; i<10; i++) {
                            UIImage* img1 =[UIImage imageNamed:@"main_img_proLess"];
                            UIImageView* img = [[UIImageView alloc]initWithFrame:
                                                CGRectMake(10+(jc*i), self->topView.frame.size.height-30, jc,img1.size.height*jc/img1.size.width)];
                            if ((i+1)*y<num)
                                img.image = [UIImage imageNamed:@"main_img_bluePro"];
                            else
                                img.image = img1;
                            [self->topView addSubview:img];
                            
                            UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0,0,jc,img1.size.height*jc/img1.size.width)];
                            lab.text = [NSString stringWithFormat:@"%i",(i+1)*nextRewardNum/10];
                            lab.textColor = [UIColor whiteColor];
                            lab.textAlignment = NSTextAlignmentRight;
                            lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*8/320];
                            [img addSubview:lab];
                        }
                        UIImageView* awardImge = [[UIImageView alloc]initWithFrame:
                                                  CGRectMake(self->topView.frame.size.width-35,
                                                             self->topView.frame.size.height-45,30,35)];
                        if (nextRewardNum ==num)
                            awardImge.image = [UIImage imageNamed:@"main_img_award"];
                        else
                            awardImge.image = [UIImage imageNamed:@"main_img_unaward"];
                        [self->topView addSubview:awardImge];
                    }else
                        [YIToast showText:tips];
                }else
                    [YIToast showText:tips];
            });
        };
    });

}

#pragma mark 开始请求我已预约项目
-(void)startRequestAppointInfo{
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_PARAM_UNI,API_URL_Appoint]
                          params:@{@"userId":@(1),
                                   @"token":@"abcdxxa",
                                   @"shopId":@(1),
                                   @"page":@(0),@"size":@(20)}];
        request.reappointmentBlock =^(NSArray* myAppointArr,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self->myTable.header endRefreshing];
                if (!err) {
                    if (myAppointArr){
                        self.midData = myAppointArr;
                        [self.midView startReloadData:myAppointArr andType:1];
                    }
                    else
                        [YIToast showText:tips];
                }else
                    [YIToast showText:tips];
            });
        };
}
#pragma mark 开始请求我已预约项目
-(void)startRequestProjectInfo{
        MainViewRequest* request1 = [[MainViewRequest alloc]init];
        [request1 postWithSerCode:@[API_PARAM_UNI,API_URL_MyProjectInfo]
                           params:@{@"userId":@(1),
                                    @"token":@"abcdxxa",
                                    @"shopId":@(1),
                                    @"page":@(0),@"size":@(2)}];
        request1.remyProjectBlock =^(NSArray* myProjectArr,NSString* tips,NSError* err){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!err) {
                    if (myProjectArr){
                        self.bottomData=myProjectArr;
                        [self.buttomView startReloadData:myProjectArr andType:2];
                    }
                    else
                        [YIToast showText:tips];
                }else
                    [YIToast showText:tips];
            });
        };
}

#pragma mark 中部视图动画事件
-(void)midViewAnimationEvent{
    CGRect re = _midView.frame;
    if (re.origin.y>100) {
       // self->myScroller.contentSize = CGSizeMake(KMainScreenWidth, KMainScreenHeight-64);
        [UIView animateWithDuration:0.5 delay:0
             usingSpringWithDamping:0.5 initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect top = self->topView.frame;
                             float yy = top.size.height- 15;
                             self->topView.frame =CGRectMake(top.origin.x, top.origin.y-yy, top.size.width, top.size.height);
                             
                             CGRect buttom = self.buttomView.frame;
                             self.buttomView.frame = CGRectMake(buttom.origin.x,KMainScreenHeight-64-20,buttom.size.width, buttom.size.height);
                             
                             self.midView.frame = CGRectMake(re.origin.x
                                                             , re.origin.y-yy,
                                                             re.size.width,
                                                             KMainScreenHeight-64-(re.origin.y-yy)-50);
                             self.midController.tableView.frame = CGRectMake(0,self.midController.tableView.frame.origin.y,
                                                                             re.size.width, KMainScreenHeight-64-(re.origin.y-yy)-50);
                             [self.midController insertTableViewData];
                         } completion:^(BOOL finished) {
                             self->buttomGesture.enabled=NO;
                         }];
        
    }else{
        [UIView animateWithDuration:0.5 delay:0
             usingSpringWithDamping:0.5 initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self->topView.frame = self->topRe;
                             self.midView.frame = self->midRe;
                             self.buttomView.frame = self->buttomRe;
                             self.midController.tableView.frame = self->midTabRe;
                             [self.midController deleteTableViewData:2];
                         }completion:^(BOOL finished) {
                             self->buttomGesture.enabled=YES;
                             //self->myScroller.contentSize = self->scrollSize;
                         }];
    }

}

#pragma mark 底部视图动画事件
-(void)buttomViewAnimationEvent{
    CGRect re = _buttomView.frame;
    if (re.origin.y>KMainScreenHeight/2) {
        // myScroller.contentSize = CGSizeMake(KMainScreenWidth, KMainScreenHeight-64);
        [UIView animateWithDuration:0.5 delay:0
             usingSpringWithDamping:0.5 initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             CGRect top = self->topView.frame;
                             float yy = top.size.height- 15;//露出15像素
                             self->topView.frame =CGRectMake(top.origin.x, top.origin.y-yy, top.size.width, top.size.height);
                             
                             CGRect mid = self.midView.frame;
                             self.midView.frame = CGRectMake(mid.origin.x
                                                             , mid.origin.y-yy,
                                                             mid.size.width,
                                                             KMainScreenWidth*0.05+5);
                             self.midController.tableView.frame = CGRectMake(0,self.midController.tableView.frame.origin.y,
                                                                             mid.size.width, KMainScreenWidth*0.05+5);
                             [self.midController deleteTableViewData:0];
                             
                             
                             float by =mid.origin.y-yy+KMainScreenWidth*0.05+13;// self.midView的Y+H
                             self.buttomView.frame = CGRectMake(re.origin.x,by
                                                                ,re.size.width,
                                                                KMainScreenHeight-64-by-20);
                             self.buttomController.tableView.frame = CGRectMake(0, self->buttonTabRe.origin.y, self->buttonTabRe.size.width, KMainScreenHeight-64-by-20);
                             [self.buttomController insertTableViewData];
                             
                         } completion:^(BOOL finished) {
                             self->midGesture.enabled=NO;
                         }];
        
    }else{
        [UIView animateWithDuration:0.5 delay:0
             usingSpringWithDamping:0.5 initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self->topView.frame = self->topRe;
                             self.midView.frame = self->midRe;
                             self.buttomView.frame = self->buttomRe;
                             self.midController.tableView.frame = self->midTabRe;
                             self.buttomController.tableView.frame = self->buttonTabRe;
                             
                             [self.midController reflashTabel:2];
                             [self.buttomController deleteTableViewData:2];
                         }completion:^(BOOL finished) {
                             self->midGesture.enabled=YES;
                            // self->myScroller.contentSize = self->scrollSize;
                         }];
    }

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
