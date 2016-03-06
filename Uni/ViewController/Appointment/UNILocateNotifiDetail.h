//
//  UNILocateNotifiDetail.h
//  Uni
//  本地通知预约详情
//  Created by apple on 15/12/17.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UNIShopModel;
@interface UNILocateNotifiDetail : UIViewController
@property (strong, nonatomic) UITableView *myTableView;
@property (copy, nonatomic) NSString* order;
@property (assign , nonatomic)int shopId;

@property (strong, nonatomic)UNIShopModel* shopModel;
@end
