//
//  UIAlertTool.h
//  Welfare Treasure
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertTool : NSObject
+(void)showAlertViewTitle:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)cancelButtonTitle OtherTitle:(NSArray *)otherButtonTitle Confirm:(void (^)(NSInteger buttonIndex))confirm Cancle:(void (^)())cancle;

//修改 取消 或 确定 按钮的颜色 数组里面第一个是取消按钮的颜色  第二个为其他按钮的颜色
+(void)showAlertViewTitle:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)cancelButtonTitle OtherTitle:(NSArray *)otherButtonTitle AndBtnsColor:(NSArray*)colors Confirm:(void (^)(NSInteger buttonIndex))confirm Cancle:(void (^)())cancle;
@end
