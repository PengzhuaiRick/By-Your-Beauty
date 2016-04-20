//
//  UNIAppointDetail.h
//  Uni
//  预约详情界面
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"
@interface UNIAppointDetail : baseViewController
@property (strong, nonatomic) UITableView *myTableView;
@property (copy, nonatomic) NSString* order;
@property (assign , nonatomic)int shopId;

@property (assign , nonatomic)BOOL ifMyDetail; // 是否从我的详情界面跳入
@property (nonatomic,strong)MKMapView* mappView;
@end
