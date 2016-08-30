//
//  MainViewController.h
//  Uni
//  首页界面
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"
//#import "MainMidView.h"
//#import "UNIContainController.h"
@interface MainViewController : baseViewController
@property(nonatomic , assign)int giftNum; //我的礼包数量

-(void)gotoShopCarController;
-(void)setupOrderListController;
@end
