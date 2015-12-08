//
//  UNIContainController.h
//  Uni
//  容器页面
//  Created by apple on 15/11/23.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIContainController : UIViewController
@property(nonatomic,strong)UIPanGestureRecognizer* panGes;//侧滑手势;
@property(nonatomic,strong)UITapGestureRecognizer* tapGes;//点击手势;
-(void)setupMainController;
-(void)setupMyController;
-(void)setupWalletController;
@end
