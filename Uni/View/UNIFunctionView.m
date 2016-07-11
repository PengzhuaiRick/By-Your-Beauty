//
//  UNIFunctionView.m
//  Uni
//
//  Created by apple on 16/7/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIFunctionView.h"
#import "ViewControllerCell.h"
@implementation UNIFunctionView
-(id)init{
    self = [super init];
    if (self) {
        [self setupParams];
        [self setupUI];
    }
    return self;
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


-(void)setupUI{
    [self setupSelf];
    [self setupTableView];
}
-(void)setupSelf{
    self.backgroundColor = [UIColor colorWithHexString:@"1b1b1b"];
    self.multipleTouchEnabled=YES;
}
-(void)setupTableView{
    
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, KMainScreenWidth, KMainScreenHeight - 64*2) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    tab.backgroundColor = [UIColor clearColor];
    tab.scrollsToTop=NO;
    [self addSubview:tab];
    _myTableView  = tab;
    _myTableView.tableFooterView = [UIView new];
    
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(tab.frame.size.width/2, CGRectGetMaxY(tab.frame),tab.frame.size.width/2, 30);
    [btn1 setTitle:@"   退出" forState:UIControlStateNormal];
    [btn1 setImage:[UIImage imageNamed:@"function_btn_quit"] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*20/414];
    [btn1 setTitleColor: [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1] forState:UIControlStateNormal];
    [self addSubview:btn1];
    [[btn1 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        [self loginOut];
//        [[BaiduMobStat defaultStat]logEvent:@"menu_setting" eventLabel:@"首页设置菜单点击"];
    }];
    
    UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, CGRectGetMaxY(tab.frame),tab.frame.size.width/2, 30);
    [btn2 setTitle:@"   设置" forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"function_btn_set"] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*20/414];
    [btn2 setTitleColor:[UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1] forState:UIControlStateNormal];
    [self addSubview:btn2];
    [[btn2 rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        [self.tv closeTheBox];
//        [self.tv setupSettingController];
       // [[BaiduMobStat defaultStat]logEvent:@"menu_exit" eventLabel:@"首页退出菜单点击"];
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*76/414;
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
//            [_tv closeTheBox];
//            [_tv setupMainController];
//            [[BaiduMobStat defaultStat]logEvent:@"menu_main" eventLabel:@"首页菜单点击"];
            break;
        case 1:
//            [_tv closeTheBox];
//            [_tv setupCardController];
//            [[BaiduMobStat defaultStat]logEvent:@"menu_detail" eventLabel:@"我的详情菜单点击"];
            break;
        case 2://我的奖励
//            [_tv closeTheBox];
//            [_tv setupMyController];
//            [[BaiduMobStat defaultStat]logEvent:@"menu_reward" eventLabel:@"我的奖励菜单点击"];
            break;
        case 3:
//            [_tv closeTheBox];
//            [_tv setupGiftController];
//            [[BaiduMobStat defaultStat]logEvent:@"menu_gift" eventLabel:@"我的礼包菜单点击"];
            break;
        case 4:
//            [_tv closeTheBox];
//            [_tv setupOrderListController];
//            [[BaiduMobStat defaultStat]logEvent:@"menu_order" eventLabel:@"我的订单菜单点击"];
            break;
        case 5:
//            [_tv closeTheBox];
//            [_tv setupWalletController];
//            [[BaiduMobStat defaultStat]logEvent:@"menu_coupon" eventLabel:@"我的优惠菜单点击"];
            break;
        case 6:
//            [self callOtherMapApp];
//            [[BaiduMobStat defaultStat]logEvent:@"menu_gps" eventLabel:@"首页导航到店菜单点击"];
            break;
        case 7:
//            [self callPhoneToShop];
//            [[BaiduMobStat defaultStat]logEvent:@"menu_call_phone" eventLabel:@"首页致电商家菜单点击"];
            break;
            
    }
}

@end
