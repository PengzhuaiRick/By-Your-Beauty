//
//  UNIOrderListController.h
//  Uni
//  订单列表
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"
#import "UNIContainController.h"
@interface UNIOrderListController : baseViewController
@property(nonatomic ,strong)UNIContainController* containController;
@property(nonatomic,assign)int type ;
@end
