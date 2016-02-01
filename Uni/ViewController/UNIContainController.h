//
//  UNIContainController.h
//  Uni
//  容器页面
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIContainController : UIViewController
@property(nonatomic,assign)BOOL closing;
@property(nonatomic,assign)float edag;
@property(nonatomic,strong)UIPanGestureRecognizer* panGes;//侧滑手势;
@property(nonatomic,strong)UITapGestureRecognizer* tapGes;//点击手势;

-(void)openTheBox;
-(void)closeTheBox;
-(void)setupMainController;
-(void)setupMyController;
-(void)setupWalletController;
-(void)setupCardController;
-(void)setupGiftController;
//订单列表
-(void)setupOrderListController;
//设置页面
-(void)setupSettingController;
@end
