//
//  MainViewController.m
//  Uni
//  首页界面
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewController.h"
#import "MainViewRequest.h"
#import "AccountManager.h"
#import "UNIAppointController.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIGoodsDeatilController.h"
#import "UNIMainProView.h"
#import "UNIGoodsWeb.h"
#import "UNIHttpUrlManager.h"
#import "UNITouristController.h"

#import "ViewController.h"
#import "UNIWalletController.h"
#import "MainCell.h"
//#import "MainViewCell.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UNIGoodsWebDelegate>{
 //   UITableView* myTable;
    float cellHight;
    int appointTotal;
    int type1;
    int goodId1;
    int bottomPage;//底部数据加载页数
    
    int cellNumber; //Cell的数量
    
//    UILabel* progessLab; //9/10
//    UILabel* goods1;
//    UILabel* goods2;
//   // UILabel* goods3;
//    UILabel* goodsLab; //约满奖励商品名称
//    UILabel* numLab; //再预约次数
//    UNIMainProView* progessView;//进度条
//    UIImageView* goodsImg; //奖励产品图片
//    UIImageView* headerImg;
//    
//    NSArray* sellGoods;
//    UILabel* sell1;
//    UILabel* sell2;
//    UILabel* sell3;
//    UILabel* sell4;
//    UIButton* sellBtn;
//    UIButton* alphBtn;
    
    NSArray* couponArr;
}
@property(nonatomic,strong) NSArray* midData;
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (strong, nonatomic) UNIMainProView *progessView;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImg;
@property (weak, nonatomic) IBOutlet UILabel *progessLab;
@property (weak, nonatomic) IBOutlet UIButton *numBtn;
@property (weak, nonatomic) IBOutlet UILabel *rewardLab;
@property (weak, nonatomic) IBOutlet UILabel *reward;
@property (weak, nonatomic) IBOutlet UIButton *couponBtn;
@property (weak, nonatomic) IBOutlet UIButton *shopBtn;
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
//     MainViewRequest* request = [[MainViewRequest alloc]init];
//    request.rqfirstUrl=^(int code){
//        dispatch_async(dispatch_get_main_queue(), ^{
            [myself startRequestMain];
            [myself requestActivityShowOrNot];
//        });
//    };
//    [request firstRequestUrl];
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
    //[self getSellInfo]; //获取首页销售商品
   // [self requestCouponInfo];
}

-(void)requestCouponInfo{
    __weak MainViewController* myself = self;
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
                [myself.myTable reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
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
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setImage:[UIImage imageNamed:@"main_bar_left"] forState:UIControlStateNormal];
    btn1.frame = CGRectMake(0, 0, 40, 40);
    [btn1 addTarget:self action:@selector(navigationControllerLeftBarAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn1];
    
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
#pragma mark 跳转优惠券
- (IBAction)gotoCouponController:(id)sender {
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UNIWalletController* view = [st instantiateViewControllerWithIdentifier:@"UNIWalletController"];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark 跳转商城列表
- (IBAction)gotoGoodsWeb:(id)sender {
    UNIGoodsWeb* web = [[UNIGoodsWeb alloc]init];
    [self.navigationController pushViewController:web animated:YES];
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

    cellHight =KMainScreenWidth*80.5/414;
    
    _progessLab.font = kWTFont(15);
    _numBtn.titleLabel.font =kWTFont(18);
    _rewardLab.font =kWTFont(15);
    _couponBtn.titleLabel.font=kWTFont(18);
    _shopBtn.titleLabel.font=kWTFont(18);
    
    __weak MainViewController* myself = self;
    _myTable.header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->bottomPage = 0;
        [myself requestBackGroundUrl1];
    }];
    _myTable.backgroundColor = [UIColor clearColor];
    
    float pWH = KMainScreenWidth* 180/414;
    float pX = (KMainScreenWidth - pWH)/2;
    float pY = KMainScreenWidth* 120/414;
    UNIMainProView* progess = [[UNIMainProView alloc]initWithFrame:CGRectMake(pX, pY, pWH, pWH)];
    progess.backgroundColor =[UIColor clearColor];
    progess.shapeColor = [UIColor colorWithHexString:@"9e928c"];
    progess.progessColor = [UIColor whiteColor];
    [progess setupProgreaa:0 and:0];
    [_headerView addSubview:progess];
    _progessView =progess;
    
    _rewardLab.layer.masksToBounds=YES;
    _rewardLab.layer.cornerRadius = _rewardLab.frame.size.height/2;
    _rewardLab.layer.borderWidth =1;
    _rewardLab.layer.borderColor = [UIColor colorWithHexString:@"7a777b"].CGColor;
    
    
}

#pragma mark 创建  tableHeaderView
-(void)setupTabViewHeader:(UIImageView*)imageView{

    UIButton* proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proBtn.frame = _progessView.frame;
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return KMainScreenWidth*20/414;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenWidth*20/414)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    cellNumber = 2 + (int)_bottomData.count;
    return cellNumber;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainCell* cell = [tableView dequeueReusableCellWithIdentifier:@"name"];
    if (!cell){
         __weak MainViewController* myself = self;
        //cell = [[MainViewCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, cellHight) reuseIdentifier:@"name"];
        cell = [[NSBundle mainBundle]loadNibNamed:@"MainCell" owner:self options:nil].lastObject;
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
        //[cell setupCouponCell:couponArr];
        [cell setupFirstCell:_midData andTotal:appointTotal];
    }else if (indexPath.section == cellNumber-1){
        if (_bottomData.count<1){
            cell.handleBtn.tag = -1;
            [cell setupCustomCell];
        }
        
    }else{
        cell.handleBtn.tag =indexPath.section+1;
        [cell setupOtherCell:_bottomData[indexPath.section]];
    }
    
       return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
    if (indexPath.section==0 ) {
       
        if (_midData.count<1)
                return;
        UIStoryboard* main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController* midController = [main instantiateViewControllerWithIdentifier:@"MainMidController"];
        [self.navigationController pushViewController:midController animated:YES];
        
    }else if (indexPath.section==cellNumber-1) {
        if (_bottomData.count<1)
            [self mainMidViewDelegataButton:nil];
    }

    if (indexPath.section>0 && indexPath.section< cellNumber-1) {
        if (_bottomData.count<1)
            return;
        id model = self.bottomData[indexPath.section];
        [self mainMidViewDelegataButton:model];
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
 __weak MainViewController* myself = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //AccountManager* manager = [AccountManager shared];
      
        MainViewRequest* request = [[MainViewRequest alloc]init];
        [request postWithSerCode:@[API_URL_ShopInfo]
                          params:nil];
        request.reshopInfoBlock=^(UNIShopManage* manager,NSString*tips,NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!er) {
                    if (manager) {
                        if (manager.shortName.length>0)
                            myself.title =manager.shortName;
                        else
                            myself.title =manager.shopName;
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
    __weak MainViewController* myself= self;
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
                            myself.progessLab.text = [NSString stringWithFormat:@"%d/%d",nextRewardNum,nextRewardNum];
                        else
                            myself.progessLab.text = [NSString stringWithFormat:@"%d/%d",num,nextRewardNum];
                        
                        [myself.progessView setupProgreaa:num and:nextRewardNum];
                        // NSString* usrl = [NSString stringWithFormat:@"%@%@",API_IMG_URL,url];
                        [myself.goodsImg sd_setImageWithURL:[NSURL URLWithString:url] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (!image)
                                return ;
                            CGPoint center = myself.goodsImg.center;
                            CGRect goodsRect = myself.goodsImg.frame;
                            goodsRect.size.width = myself.goodsImg.frame.size.height * image.size.width / image.size.height;
                            myself.goodsImg.frame = goodsRect;
                            myself.goodsImg.center = center;
                            
                        }];
                        if (nextRewardNum>num) {
                             myself.reward.text =@"再预约次数";
                            [myself.numBtn setTitle:[NSString stringWithFormat:@"%d",nextRewardNum - num] forState:UIControlStateNormal];
                        }if (nextRewardNum <= num) {
                            myself.reward.text =@"恭喜您!";
                            [myself.numBtn setTitle:@"" forState:UIControlStateNormal];
                        }
                        myself.rewardLab.text = projectName;

                    }else{
                        myself.progessLab.text = nil;
                        myself.rewardLab.text = nil;
                        [myself.numBtn setTitle:@"" forState:UIControlStateNormal];
                        [myself.progessView setupProgreaa:0 and:0];
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
                [myself.myTable.header endRefreshing];
                if (!err) {
                    self->appointTotal = count;
                    myself.midData = nil;
                    myself.midData = myAppointArr;
                    [myself.myTable reloadData];
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
                    [myself.myTable.footer endRefreshing];
                    //刷新侧边栏我的礼包的数量
                    myself.giftNum = count;
                    
                    if (self->bottomPage<1)
                        [myself.bottomData removeAllObjects];
                    
                    if (myProjectArr.count<10)
                        [myself.myTable.footer endRefreshingWithNoMoreData];
                    
                    [myself.bottomData addObjectsFromArray: myProjectArr];
                
                    [myself.myTable reloadData];
                    [myself addTableViewReflashFootView];
                
                }
                else
                    [YIToast showText:NETWORKINGPEOBLEM];
            });
        };
}
#pragma mark 判断是否添加上拉加载
-(void)addTableViewReflashFootView{
    if (_myTable.footer){
        return;}
        __weak MainViewController* myself = self;
        _myTable.footer =[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self->bottomPage++;
            [myself startRequestProjectInfo];
        }];

}

#pragma mark 获取背景图片 和 奖励商品图片
-(void)getBgImageAndGoodsImage{
    __weak MainViewController* myself = self;
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
                        [myself.headerImg sd_setImageWithURL:[NSURL URLWithString:url]
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
//    __weak MainViewController* myself = self;
    MainViewRequest* request1 = [[MainViewRequest alloc]init];
    [request1 postWithSerCode:@[API_URL_GetSellInfo2]
                       params:@{@"projcetId":@"",@"type":@"2",@"isHeadShow":@(1)}];
    request1.resellInfoBlock =^(NSArray* arr,NSString* tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!err) {
//                if (arr.count>0) {
//                    self->sellGoods = arr;
//                    UNIGoodsModel* info = arr[0];
//                    self->sell1.text = info.projectName;
////                    if (info.shopPrice>1)
////                        self->sell2.text = [NSString stringWithFormat:@"￥%.f",info.shopPrice];
////                    else
//                        self->sell2.text = [NSString stringWithFormat:@"￥%.f",info.shopPrice];
//                    self->sell3.hidden=NO;
//                    self->sell4.hidden=YES;
//                    self->sellBtn.hidden=NO;
//                    self->alphBtn.enabled=YES;
//                }else{
//                    self->sell1.text = @"";
//                    self->sell2.text = @"";
//                    self->sell3.hidden=YES;
//                    self->sell4.text = [UNIHttpUrlManager sharedInstance].MORE_YH_TIPS;
//                    self->sell4.hidden=NO;
//                    self->sellBtn.hidden=YES;
//                    self->alphBtn.enabled=NO;
//                }
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
        [_myTable.header beginRefreshing];
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
