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
}

-(void)setupSelf{
    self.view.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.9f];
    [self.view addSubview:_tv.view];
    self.view.multipleTouchEnabled=YES;
}

-(void)setupParams{
    titleArray = @[@"首页",
                   @"会员详情",
                   @"我的奖励",
                   @"活动礼包",
                   @"我的卡包",
                   @"导航到家",
                   @"致电商家"
//                   ,
//                   @"Copyright @2014-2021\n广州由你电子商务有限公司"
                   ];
    imgArray =@[@"function_img_cell1",
                @"function_img_cell2",
                @"function_img_cell3",
                @"function_img_cell4",
                @"function_img_cell5",
                @"function_img_cell6",
                @"function_img_cell7"
                ];
    imgSArray =@[@"function_img_scell1",
                @"function_img_scell2",
                @"function_img_scell3",
                @"function_img_scell4",
                @"function_img_scell5",
                @"function_img_scell6",
                @"function_img_scell7"
                ];
    
}


-(void)setupTableView{
    UIImageView* bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_img_menu"]];
    bg.frame = CGRectMake(0, 0, self.view.frame.size.width - _tv.edag, self.view.frame.size.height);
    [self.view addSubview:bg];
    
    UIView* bgview = [[UIView alloc]initWithFrame:bg.frame];
    bgview.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    [bg addSubview:bgview];
    
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width - _tv.edag, self.view.frame.size.height - 80) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    tab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tab];
    _myTableView  = tab;
    _myTableView.tableFooterView = [UIView new];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(tab.frame.size.width/2, CGRectGetMaxY(tab.frame),KMainScreenWidth*80/320, 30);
    [btn1 setTitle:@" 退出" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"function_btn_quit"] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*15/320];
    [self.view addSubview:btn1];
    [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self loginOut];
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.frame.size.height/titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return titleArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    ViewControllerCell*cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell) {
        cell = [[ViewControllerCell alloc]initWithCellH:KMainScreenHeight/titleArray.count reuseIdentifier:name];
        cell.backgroundColor = [UIColor clearColor];
    }
        cell.mainImg.image = [UIImage imageNamed:imgArray[indexPath.row]];
        cell.mainLab.text = titleArray[indexPath.row];
        cell.mainLab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    cell.numLab.hidden=YES;

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
        }else{
            cell.mainLab.textColor = [UIColor colorWithHexString:kMainTitleColor];
            cell.mainImg.image = [UIImage imageNamed:imgArray[i]];
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
            [_tv setupWalletController];
            break;
        case 5://导航到店
            [self callOtherMapApp];
            break;
        case 6:
            [self callPhoneToShop];
            break;

    }
}

#pragma mark 调用其他地图APP
-(void)callOtherMapApp{
    NSMutableArray* mapsArray = [NSMutableArray arrayWithObjects:@"苹果地图", nil];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]])
        [mapsArray addObject:@"百度地图"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]])
        [mapsArray addObject:@"高德地图"];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]])
        [mapsArray addObject:@"Google地图"];
    
    [UIActionSheet showInView:self.view withTitle:@"本机地图" cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:mapsArray tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
        NSString* mapName = [actionSheet buttonTitleAtIndex:buttonIndex];
        [self selectLocateAppMap:mapName];
    }];


}
-(void)selectLocateAppMap:(NSString*)tag{
    YILocationManager* locaMan = [YILocationManager sharedInstance];
    float myLat = [locaMan.userLocInfo.latitude floatValue];
    float myLong = [locaMan.userLocInfo.longitude floatValue];
    CLLocationCoordinate2D pt = CLLocationCoordinate2DMake(myLat, myLong);
    CLLocationCoordinate2D startCoor = pt;
    
    UNIShopManage* shopMan = [UNIShopManage getShopData];
    float endLat = [shopMan.x floatValue];
    float endLong = [shopMan.y floatValue];
    CLLocationCoordinate2D endCoor = CLLocationCoordinate2DMake(endLat, endLong);
    NSString *toName =shopMan.shopName;
    
    
    if ([tag isEqualToString:@"苹果地图"])//苹果地图
    {
        MKMapItem *currentAction = [MKMapItem mapItemForCurrentLocation];
        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil];
        MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
        toLocation.name =toName;
        
        [MKMapItem openMapsWithItems:@[currentAction, toLocation]
                       launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
                                       MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
        
    }
    if ([tag isEqualToString:@"百度地图"]){
        //百度地图
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",
                                startCoor.latitude, startCoor.longitude, endCoor.latitude, endCoor.longitude, toName]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
    if ([tag isEqualToString:@"高德地图"]){
        //高德地图
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",
                                toName, endCoor.latitude, endCoor.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
    if ([tag isEqualToString:@"Google地图"]){
        //Google地图
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f¢er=%f,%f&directionsmode=transit", endCoor.latitude, endCoor.longitude, startCoor.latitude, startCoor.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:urlString]];
    }
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callOtherMapApp" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"callPhoneToShop" object:nil];
}

@end
