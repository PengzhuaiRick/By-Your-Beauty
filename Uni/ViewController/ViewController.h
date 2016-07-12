//
//  ViewController.h
//  Uni
//  功能界面
//  Created by apple on 15/10/27.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "baseViewController.h"
//@class UNIContainController;
@class MainViewController;
@interface ViewController : baseViewController
@property(nonatomic,strong) MainViewController* tv;

-(void)showViewAnimation;
@end

