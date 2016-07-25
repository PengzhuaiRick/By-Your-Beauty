//
//  ViewController.m
//  Uni
//  功能界面
//  Created by apple on 15/10/27.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "UIActionSheet+Blocks.h"
#import "UNIShopManage.h"
#import "YILocationManager.h"
#import "MainViewController.h"
#import "AccountManager.h"
#import "AppDelegate.h"
#import "ViewControllerCell.h"
#import "UNITransfromX&Y.h"


#import "UNIMyRewardController.h"
#import "UNIWalletController.h"
#import "UNICardInfoController.h"
#import "UNIGiftController.h"
#import "UNIOrderListController.h"
#import "UNISetttingController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    NSArray* titleArray;
    NSArray* imgArray;
    NSArray* imgSArray;
}
@property (strong, nonatomic) UIButton* backBtn;
@property (strong, nonatomic) UIButton* setBtn;
@property (strong, nonatomic) UIButton* loginOutBtn;
@property (strong, nonatomic) UITableView *myTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupParams];
    [self setupTableView];
    [self setupSelf];
   // [self setupNotification];
    [self showGuideView:FUNCTIONGUIDE];
}
-(void)setupNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callPhoneToShop) name:@"callPhoneToShop" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callOtherMapApp) name:@"callOtherMapApp" object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(flashTheCellNum:) name:@"flashTheCellNum" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpToMyReward) name:@"jumpToMyReward" object:nil];//从我的详情跳转到我的奖励
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleanAndJump) name:@"setupLoginController" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mainToMyCoupon) name:@"mainToMyCoupon" object:nil];//从首页跳到我的优惠券
}

-(void)setupSelf{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(KMainScreenWidth - 100, -76, 100, 76);
    [btn setImage:[UIImage imageNamed:@"view_btn_back"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    _backBtn = btn;
    
    __weak ViewController* myself = self;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        [myself selfDismiss:nil];
    }];
}

-(void)setupParams{
    titleArray = @[//@"首页",
                   @"我的详情",
                   @"我的奖励",
                   @"我的礼包",
                   @"我的订单",
                   @"我的优惠",
                   @"导航到店",
                   @"致电商家"
//                   ,
//                   @"Copyright @2014-2021\n广州由你电子商务有限公司"
                   ];
    imgArray =@[//@"function_img_cell1",
                @"function_img_cell2",
                @"function_img_cell3",
                @"function_img_cell4",
                @"function_img_cell5",
                @"function_img_cell8",
                @"function_img_cell6",
                @"function_img_cell7"
                ];
    imgSArray =@[//@"function_img_scell1",
                @"function_img_scell2",
                @"function_img_scell3",
                @"function_img_scell4",
                @"function_img_scell5",
                @"function_img_scell8",
                @"function_img_scell6",
                @"function_img_scell7"
                ];
}


-(void)setupTableView{
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
    [self.view addSubview:effectview];
    
    __weak ViewController* myself = self;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]init];
    [effectview addGestureRecognizer:tap];
    [[tap rac_gestureSignal]subscribeNext:^(id x) {
        [myself selfDismiss:nil];
    }];
    
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 156, self.view.frame.size.width/2, self.view.frame.size.height - 76*2) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    tab.backgroundColor = [UIColor clearColor];
    tab.scrollsToTop=NO;
    [self.view addSubview:tab];
    _myTableView  = tab;
    _myTableView.tableFooterView = [UIView new];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(self.view.frame.size.width/2, KMainScreenHeight-100,self.view.frame.size.width/2, 30);
    [btn1 setTitle:@"   退出" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"function_btn_quit"] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*20/414];
    [btn1 setTitleColor: [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    _loginOutBtn = btn1;
    [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [myself loginOut];
        [[BaiduMobStat defaultStat]logEvent:@"menu_setting" eventLabel:@"首页设置菜单点击"];
    }];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0,KMainScreenHeight-100,self.view.frame.size.width/2, 30);
    [btn2 setTitle:@"   设置" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"function_btn_set"] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*20/414];
    [btn2 setTitleColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    _setBtn = btn2;
    
    [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [myself selfDismiss:@selector(setupSettingController)];
        //[self setupSettingController];
        [[BaiduMobStat defaultStat]logEvent:@"menu_exit" eventLabel:@"首页退出菜单点击"];
    }];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*70/414;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    ViewControllerCell*cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[ViewControllerCell alloc]initWithCellH:KMainScreenWidth*70/414 reuseIdentifier:name];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 2) {
            cell.numLab.hidden=NO;
            cell.numLab.text = [NSString stringWithFormat:@"%d",_tv.giftNum];
        }else
        cell.numLab.hidden=YES;
    }
        cell.mainImg.image = [UIImage imageNamed:imgArray[indexPath.row]];
        cell.mainLab.text = titleArray[indexPath.row];
        cell.mainLab.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
   

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ViewControllerCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.mainLab.textColor = [UIColor colorWithHexString:kMainThemeColor];

    for (int i = 0 ; i<titleArray.count; i++) {
        NSIndexPath* index = [NSIndexPath indexPathForRow:i inSection:0];
        ViewControllerCell* cell = [tableView cellForRowAtIndexPath:index];
        if (i == indexPath.row) {
            cell.mainLab.textColor = [UIColor colorWithHexString:kMainThemeColor];
            cell.mainImg.image = [UIImage imageNamed:imgSArray[i]];
           // cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        }else{
            cell.mainLab.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
            cell.mainImg.image = [UIImage imageNamed:imgArray[i]];
           // cell.backgroundColor = [UIColor clearColor];
        }
    }
    switch (indexPath.row) {
        case 0:
            [self selfDismiss:@selector(setupCardController)];
           // [self setupCardController];
            [[BaiduMobStat defaultStat]logEvent:@"menu_detail" eventLabel:@"我的详情菜单点击"];
            break;
        case 1://我的奖励
            [self selfDismiss:@selector(setupMyController)];
           // [self setupMyController];
            [[BaiduMobStat defaultStat]logEvent:@"menu_reward" eventLabel:@"我的奖励菜单点击"];
            break;
        case 2:
            [self selfDismiss:@selector(setupGiftController)];
          // [self setupGiftController];
            [[BaiduMobStat defaultStat]logEvent:@"menu_gift" eventLabel:@"我的礼包菜单点击"];
            break;
        case 3:
             [self selfDismiss:@selector(setupOrderListController)];
            //[self setupOrderListController];
            [[BaiduMobStat defaultStat]logEvent:@"menu_order" eventLabel:@"我的订单菜单点击"];
            break;
        case 4:
             [self selfDismiss:@selector(setupWalletController)];
           // [self setupWalletController];
            [[BaiduMobStat defaultStat]logEvent:@"menu_coupon" eventLabel:@"我的优惠菜单点击"];
            break;
        case 5:
            [self callOtherMapApp];
            [[BaiduMobStat defaultStat]logEvent:@"menu_gps" eventLabel:@"首页导航到店菜单点击"];
            break;
        case 6:
            [self callPhoneToShop];
            [[BaiduMobStat defaultStat]logEvent:@"menu_call_phone" eventLabel:@"首页致电商家菜单点击"];
            break;
    }
   
}

-(void)showViewAnimation{
    
    CGRect btnR = _backBtn.frame;
    btnR.origin.y = 0;
    
    CGRect tabR = _myTableView.frame;
    tabR.origin.y = 76;
    
    CGRect btnS = _setBtn.frame;
    btnS.origin.y = CGRectGetMaxY(tabR);
    
    CGRect btnL = _loginOutBtn.frame;
    btnL.origin.y = CGRectGetMaxY(tabR);
    
    __weak ViewController* myself = self;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:30 options:UIViewAnimationOptionCurveEaseOut animations:^{
        myself.backBtn.frame = btnR;
        myself.myTableView.frame = tabR;
        myself.loginOutBtn.frame = btnL;
        myself.setBtn.frame = btnS;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark 让自己消失
-(void)selfDismiss:(SEL)action{
    __weak ViewController* myself = self;
    [UIView animateWithDuration:0.3 animations:^{
        myself.view.alpha = 0;
    } completion:^(BOOL finished) {
        [myself dismissViewControllerAnimated:NO completion:^{
            if (action)
                [myself performSelectorOnMainThread:action withObject:nil waitUntilDone:NO];
        }];
    }];
}

#pragma mark 调用其他地图APP
-(void)callOtherMapApp{
    UNIShopManage* shopMan = [UNIShopManage getShopData];
    double endLat = [shopMan.x doubleValue];
    double endLong = [shopMan.y doubleValue];
    UNITransfromX_Y* xy= [[UNITransfromX_Y alloc]initWithView:self.view withEndCoor:CLLocationCoordinate2DMake(endLat, endLong) withAim:shopMan.shopName];
    [xy setupUI];
}

#pragma mark 调用电话功能
-(void)callPhoneToShop{
    UNIShopManage* manager = [UNIShopManage getShopData];
    NSString* tips=[NSString stringWithFormat:@"是否拨打电话:%@",manager.telphone];;
    NSArray* arr =@[@"拨打"];
    if (manager.telphone.length<11){
        tips=@"暂无店铺电话号码！";
        arr=nil;
    }
    
    [UIAlertView showWithTitle:tips message:nil cancelButtonTitle:@"取消" otherButtonTitles:arr tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex>0){
            NSString* tel = [NSString stringWithFormat:@"tel://%@",manager.telphone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
    }];
   
}

#pragma mark 调用退出登录
-(void)loginOut{
#ifdef IS_IOS9_OR_LATER
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定退出登录" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    UIAlertAction *checkAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cleanAndJump];
    }];
    [alertController addAction:checkAction];
    
    
    [self presentViewController:alertController animated:YES completion:nil];
#else
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否确定退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
#endif
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex>0) {
        [self cleanAndJump];
    }
}

-(void)cleanAndJump{
    [AccountManager clearAll];
    [UNIShopManage cleanShopinfo];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate judgeFirstTime];
}

#pragma mark 刷新功能列表上红色小圆圈的数字
//-(void)flashTheCellNum:(NSNotification*)notificate{
//    NSDictionary* dic = notificate.userInfo;
//    int count = [[dic objectForKey:@"count"] intValue];
//    
//    NSIndexPath* index = [NSIndexPath indexPathForRow:3 inSection:0];
//    ViewControllerCell* cell = [_myTableView cellForRowAtIndexPath:index];
//    if (count>0){
//        cell.numLab.hidden=NO;
//        cell.numLab.text = [NSString stringWithFormat:@"%d",count];
//    }else
//        cell.numLab.hidden=YES;
//}

#pragma mark 通知跳转到我的奖励
-(void)jumpToMyReward{
    NSIndexPath* index = [NSIndexPath indexPathForRow:2 inSection:0];
    [self tableView:self.myTableView didSelectRowAtIndexPath:index];
}

#pragma mark 通知跳转到我的优惠券
-(void)mainToMyCoupon{
    NSIndexPath* index = [NSIndexPath indexPathForRow:5 inSection:0];
    [self tableView:self.myTableView didSelectRowAtIndexPath:index];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callOtherMapApp" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callPhoneToShop" object:nil];
    //[[NSNotificationCenter defaultCenter]removeObserver:self name:@"flashTheCellNum" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"jumpToMyReward" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setupLoginController" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"mainToMyCoupon" object:nil];
}

//我的奖励
-(void)setupMyController{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UNIMyRewardController* mainCtr= [st instantiateViewControllerWithIdentifier:@"UNIMyRewardController"];
    [_tv.navigationController pushViewController:mainCtr animated:YES];
}

//我的钱包
-(void)setupWalletController{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UNIWalletController* view = [st instantiateViewControllerWithIdentifier:@"UNIWalletController"];
   [_tv.navigationController pushViewController:view animated:YES];
}

//会员卡详情
-(void)setupCardController{
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UNICardInfoController* view = [st instantiateViewControllerWithIdentifier:@"UNICardInfoController"];
     [_tv.navigationController pushViewController:view animated:YES];
}

//我的礼包
-(void)setupGiftController{
    UNIGiftController* view = [[UNIGiftController alloc]init];
    [_tv.navigationController pushViewController:view animated:YES];
}

//订单列表
-(void)setupOrderListController{
    UNIOrderListController* view = [[UNIOrderListController alloc]init];
    [_tv.navigationController pushViewController:view animated:YES];
}
//设置页面
-(void)setupSettingController{
    UNISetttingController* view = [[UNISetttingController alloc]init];
     [_tv.navigationController pushViewController:view animated:YES];
}


@end
