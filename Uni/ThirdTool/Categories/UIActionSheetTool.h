//
//  UIActionSheetTool.h
//  Welfare Treasure
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIActionSheetTool : NSObject
+(void)showActionShootTitle:(NSString *)title antTarget:(id<UIActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelButtonTitle OtherTitle:(NSArray *)otherButtonTitle Confirm:(void (^)(NSInteger buttonIndex))confirm Cancle:(void (^)())cancle;
@end
