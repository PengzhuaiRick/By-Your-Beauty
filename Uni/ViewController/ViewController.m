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
//#import "YILocationManager.h"
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

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    int seletNum ;
    NSArray* titleArray;
    NSArray* imgArray;
    NSArray* imgSArray;
}

@property (weak, nonatomic) IBOutlet UIButton *shopCarBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectView;
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self setupBackView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupParams];
    //[self setupSelf];
   // [self setupNotification];
   // [self showGuideView:FUNCTIONGUIDE];
    [self setupBackView];
    [self setupCollestView];
}

-(void)setupBackView{
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectview.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
    //[self.view addSubview:effectview];
    [self.view insertSubview:effectview belowSubview:_shopCarBtn];
}
-(void)setupCollestView{
    [_myCollectView registerNib:[UINib nibWithNibName:@"ViewControllerCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    _myCollectView.backgroundColor = [UIColor clearColor];
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
    btn.frame = CGRectMake(50, -76, 100, 76);
    [btn setImage:[UIImage imageNamed:@"view_btn_back"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
   // _backBtn = btn;
    
    __weak ViewController* myself = self;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        [myself selfDismiss:nil];
    }];
}
#pragma mark 返回按钮事件
- (IBAction)backBtnAction:(UIButton *)sender {
    [self selfDismiss:nil];
}

-(void)setupParams{
    
    seletNum = 0;
    titleArray = @[@"首页",
                   @"我的详情",
                   @"我的奖励",
                   @"我的礼包",
                   @"我的订单",
                   @"致电商家",
                   @"导航到店",
                   @"设置"
//                   ,
//                   @"Copyright @2014-2021\n广州由你电子商务有限公司"
                   ];
    imgArray =@[@"function_img_cell1",
                @"function_img_cell2",
                @"function_img_cell3",
                @"function_img_cell4",
                @"function_img_cell5",
                @"function_img_cell7",
                @"function_img_cell6",
                @"function_img_cell8"
                ];
    imgSArray =@[@"function_img_scell1",
                @"function_img_scell2",
                @"function_img_scell3",
                @"function_img_scell4",
                @"function_img_scell5",
                @"function_img_scell7",
                @"function_img_scell6",
                @"function_img_scell8"
                ];
}
#pragma mark 购物车点击事件
- (IBAction)shopCarBtn:(id)sender {
    [self selfDismiss:nil];
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Function" bundle:nil];
    UIViewController* vc = [st instantiateViewControllerWithIdentifier:@"UNIShopCarController"];
    [_tv.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UICollectionView  的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    //return self.goodsListArr.count;
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return titleArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(KMainScreenWidth/2, collectionView.bounds.size.height/4);

}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellName = @"cell";
    ViewControllerCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellName
                                                                  forIndexPath:indexPath];
    cell.titleName.text = titleArray[indexPath.row];
    if (indexPath.row == seletNum) {
        cell.mainImg.image = [UIImage imageNamed:imgSArray[indexPath.row]];
        cell.titleName.textColor = [UIColor colorWithHexString:kMainThemeColor];
        cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    }else{
        cell.mainImg.image = [UIImage imageNamed:imgArray[indexPath.row]];
        cell.titleName.textColor = [UIColor colorWithHexString:@"c9c9c9"];
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == 3) {
        cell.numLab.hidden = _tv.giftNum <1;
        cell.numLab.text = [NSString stringWithFormat:@"%d",_tv.giftNum];
    }else
        cell.numLab.hidden =YES;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != seletNum) {
        int oldNum = seletNum;
        seletNum = (int)indexPath.row;
        NSIndexPath* oldIndex = [NSIndexPath indexPathForRow:oldNum inSection:0];
        [collectionView reloadItemsAtIndexPaths:@[oldIndex , indexPath]];
    }
    
    
    switch (indexPath.row) {
        case 0:
             [self selfDismiss:nil];
            break;
        case 1:
               [self selfDismiss:@selector(setupCardController)];
               // [self setupCardController];
                [[BaiduMobStat defaultStat]logEvent:@"menu_detail" eventLabel:@"我的详情菜单点击"];
        break;
        case 2://我的奖励
            [self selfDismiss:@selector(setupMyController)];
            // [self setupMyController];
            [[BaiduMobStat defaultStat]logEvent:@"menu_reward" eventLabel:@"我的奖励菜单点击"];
        break;
        case 3:
            [self selfDismiss:@selector(setupGiftController)];
            // [self setupGiftController];
            [[BaiduMobStat defaultStat]logEvent:@"menu_gift" eventLabel:@"我的礼包菜单点击"];
            break;
        case 4:
            [self selfDismiss:@selector(setupOrderListController)];
            //[self setupOrderListController];
            [[BaiduMobStat defaultStat]logEvent:@"menu_order" eventLabel:@"我的订单菜单点击"];
            break;
        case 7:
            [self selfDismiss:@selector(setupSettingController)];
            [[BaiduMobStat defaultStat]logEvent:@"menu_exit" eventLabel:@"首页退出菜单点击"];
            break;
        case 6:
            [self callOtherMapApp];
            [[BaiduMobStat defaultStat]logEvent:@"menu_gps" eventLabel:@"首页导航到店菜单点击"];
            break;
        case 5:
            [self callPhoneToShop];
            [[BaiduMobStat defaultStat]logEvent:@"menu_call_phone" eventLabel:@"首页致电商家菜单点击"];
            break;
    }

}



-(void)showViewAnimation{
    
   __block CGRect tabR = _myCollectView.frame;
    tabR.origin.y = 76;
    
    __weak ViewController* myself = self;
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:30 options:UIViewAnimationOptionCurveEaseOut animations:^{
        myself.myCollectView.frame = tabR;
    } completion:^(BOOL finished) {
        tabR.origin.y = 64;
        myself.myCollectView.frame = tabR;
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


#pragma mark 通知跳转到我的奖励
-(void)jumpToMyReward{
    //NSIndexPath* index = [NSIndexPath indexPathForRow:2 inSection:0];
   // [self tableView:self.myTableView didSelectRowAtIndexPath:index];
}

#pragma mark 通知跳转到我的优惠券
-(void)mainToMyCoupon{
    //NSIndexPath* index = [NSIndexPath indexPathForRow:5 inSection:0];
   // [self tableView:self.myTableView didSelectRowAtIndexPath:index];
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
//    UNIOrderListController* view = [[UNIOrderListController alloc]init];
//    [_tv.navigationController pushViewController:view animated:YES];
    
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
    UIViewController* view = [st instantiateViewControllerWithIdentifier:@"UNIOrderListController"];
    [_tv.navigationController pushViewController:view animated:YES];
}
//设置页面
-(void)setupSettingController{
//    UNISetttingController* view = [[UNISetttingController alloc]init];
//     [_tv.navigationController pushViewController:view animated:YES];
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
    UIViewController* view = [st instantiateViewControllerWithIdentifier:@"UNISetttingController"];
    [_tv.navigationController pushViewController:view animated:YES];
    
}


@end
