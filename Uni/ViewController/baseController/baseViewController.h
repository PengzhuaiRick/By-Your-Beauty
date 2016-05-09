//
//  baseViewController.h
//  Uni
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaiduMobStat.h"
@interface baseViewController : UIViewController
#pragma mark 百度统计开始
-(void)BaiduStatBegin:(NSString*)text;

#pragma mark 百度统计结束
-(void)BaiduStatEnd:(NSString*)text;
@end
