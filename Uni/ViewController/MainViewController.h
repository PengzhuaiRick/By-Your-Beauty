//
//  MainViewController.h
//  Uni
//  首页界面
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMidView.h"
#import "UNIContainController.h"
@interface MainViewController : UIViewController

@property(nonatomic ,strong)MainMidView* midView;
@property(nonatomic ,strong)MainMidView* buttomView;
@property(nonatomic ,strong)UNIContainController* containController;
@end
