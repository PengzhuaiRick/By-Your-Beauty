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

@property (weak, nonatomic) IBOutlet UIScrollView *myScroller;

@end
