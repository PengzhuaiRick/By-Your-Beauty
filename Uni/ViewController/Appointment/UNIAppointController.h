//
//  UNIAppointController.h
//  Uni
//  预约界面
//  Created by apple on 15/11/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UNIMyProjectModel;
@interface UNIAppointController : UIViewController
@property (strong ,nonatomic) UNIMyProjectModel* model;
@property (copy ,nonatomic) NSString* projectId; // 存在的时候表示为从我的礼包跳转进来的

@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;

@end
