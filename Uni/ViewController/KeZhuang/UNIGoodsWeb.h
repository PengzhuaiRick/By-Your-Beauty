//
//  UNIGoodsWeb.h
//  Uni
//
//  Created by apple on 16/1/29.
//  Copyright © 2016年 apple. All rights reserved.
//
@protocol UNIGoodsWebDelegate <NSObject>

-(void)UNIGoodsWebDelegateMethodAndprojectId:(NSString*)ProjectId Andtype:(NSString*)Type;
@end
#import <UIKit/UIKit.h>
@interface UNIGoodsWeb : UIViewController
@property(nonatomic,assign)id<UNIGoodsWebDelegate> delegate;
@end
