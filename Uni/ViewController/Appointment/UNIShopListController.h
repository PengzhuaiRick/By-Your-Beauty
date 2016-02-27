//
//  UNIShopListController.h
//  Uni
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//
@protocol UNIShopListControllerDelegate <NSObject>

-(void)UNIShopListControllerDelegateMethod:(id)model;
@end

#import <UIKit/UIKit.h>
#import "UNIShopListCell.h"
@interface UNIShopListController : UIViewController

@property(nonatomic,assign)id<UNIShopListControllerDelegate> delegate;

@end
