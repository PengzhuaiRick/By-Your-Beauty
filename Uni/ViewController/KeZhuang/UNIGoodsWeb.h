//
//  UNIGoodsWeb.h
//  Uni
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//
@protocol UNIGoodsWebDelegate <NSObject>

-(void)UNIGoodsWebDelegateMethodAndprojectId:(NSString*)ProjectId Andtype:(NSString*)Type AndIsHeaderShow:(int)isH;
@end
#import <UIKit/UIKit.h>
//#import "baseViewController.h"
#import "BaseWebController.h"
@interface UNIGoodsWeb : BaseWebController
@property(nonatomic,assign)id<UNIGoodsWebDelegate> delegate;
@end
