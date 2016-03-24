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
#import "UNIContainController.h"
#import "AccountManager.h"
#import "AppDelegate.h"
#import "ViewControllerCell.h"
#import "UNITransfromX&Y.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
//    CGPoint startPoint;
//    CGPoint currentPoint;
    
    NSArray* titleArray;
    NSArray* imgArray;
    NSArray* imgSArray;
}
@property (strong, nonatomic) UITableView *myTableView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupParams];
    [self setupTableView];
    [self setupSelf];
    [self setupNotification];
}
-(void)setupNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callPhoneToShop) name:@"callPhoneToShop" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(callOtherMapApp) name:@"callOtherMapApp" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(flashTheCellNum:) name:@"flashTheCellNum" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpToMyReward) name:@"jumpToMyReward" object:nil];//从我的详情跳转到我的奖励
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleanAndJump) name:@"setupLoginController" object:nil];
}

-(void)setupSelf{
    self.view.backgroundColor = [UIColor colorWithHexString:@"1b1b1b"];
    [self.view addSubview:_tv.view];
    self.view.multipleTouchEnabled=YES;
}

-(void)setupParams{
    titleArray = @[@"首页",
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
    imgArray =@[@"function_img_cell1",
                @"function_img_cell2",
                @"function_img_cell3",
                @"function_img_cell4",
                @"function_img_cell5",
                @"function_img_cell8",
                @"function_img_cell6",
                @"function_img_cell7"
                ];
    imgSArray =@[@"function_img_scell1",
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
//    UIImageView* bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_img_menu"]];
//    bg.frame = CGRectMake(0, 0, self.view.frame.size.width - _tv.edag, self.view.frame.size.height);
//    [self.view addSubview:bg];
    
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width - _tv.edag, self.view.frame.size.height - 60) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    tab.backgroundColor = [UIColor clearColor];
    tab.scrollsToTop=NO;
    [self.view addSubview:tab];
    _myTableView  = tab;
    _myTableView.tableFooterView = [UIView new];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(tab.frame.size.width/2, CGRectGetMaxY(tab.frame),tab.frame.size.width/2, 30);
    [btn1 setTitle:@"   退出" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"function_btn_quit"] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*20/414];
    [btn1 setTitleColor: [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self loginOut];
    }];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, CGRectGetMaxY(tab.frame),tab.frame.size.width/2, 30);
    [btn2 setTitle:@"   设置" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"function_btn_set"] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*20/414];
    [btn2 setTitleColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self.tv closeTheBox];
        [self.tv setupSettingController];
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
        if (indexPath.row == 3) {
            cell.numLab.hidden=NO;
        }else
        cell.numLab.hidden=YES;
    }
        cell.mainImg.image = [UIImage imageNamed:imgArray[indexPath.row]];
        cell.mainLab.text = titleArray[indexPath.row];
        cell.mainLab.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
   

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    ViewControllerCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.mainLab.textColor = [UIColor colorWithHexString:kMainThemeColor];

    for (int i = 0 ; i<titleArray.count; i++) {
        NSIndexPath* index = [NSIndexPath indexPathForRow:i inSection:0];
        ViewControllerCell* cell = [tableView cellForRowAtIndexPath:index];
        if (i == indexPath.row) {
            cell.mainLab.textColor = [UIColor colorWithHexString:kMainThemeColor];
            cell.mainImg.image = [UIImage imageNamed:imgSArray[i]];
            cell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        }else{
            cell.mainLab.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
            cell.mainImg.image = [UIImage imageNamed:imgArray[i]];
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    switch (indexPath.row) {
        case 0:
            [_tv closeTheBox];
            [_tv setupMainController];
            break;
        case 1:
            [_tv closeTheBox];
            [_tv setupCardController];
            break;
        case 2://我的奖励
             [_tv closeTheBox];
            [_tv setupMyController];
            break;
        case 3:
            [_tv closeTheBox];
            [_tv setupGiftController];
            break;
        case 4:
            [_tv closeTheBox];
            [_tv setupOrderListController];
            break;
        case 5:
            [_tv closeTheBox];
            [_tv setupWalletController];
            break;
        case 6:
            [self callOtherMapApp];
            break;
        case 7:
            [self callPhoneToShop];
            break;

    }
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
    NSString* tel = [NSString stringWithFormat:@"tel://%@",manager.telphone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
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
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate judgeFirstTime];
}

#pragma mark 刷新功能列表上红色小圆圈的数字
-(void)flashTheCellNum:(NSNotification*)notificate{
    NSDictionary* dic = notificate.userInfo;
    int count = [[dic objectForKey:@"count"] intValue];
    
    NSIndexPath* index = [NSIndexPath indexPathForRow:3 inSection:0];
    ViewControllerCell* cell = [_myTableView cellForRowAtIndexPath:index];
    if (count>0){
        cell.numLab.hidden=NO;
        cell.numLab.text = [NSString stringWithFormat:@"%d",count];
    }else
        cell.numLab.hidden=YES;
}

#pragma mark 通知跳转到我的奖励
-(void)jumpToMyReward{
    NSIndexPath* index = [NSIndexPath indexPathForRow:2 inSection:0];
    [self tableView:self.myTableView didSelectRowAtIndexPath:index];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callOtherMapApp" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callPhoneToShop" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"flashTheCellNum" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"jumpToMyReward" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"setupLoginController" object:nil];
}

@end
