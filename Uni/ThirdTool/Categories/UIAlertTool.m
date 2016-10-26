//
//  UIAlertTool.m
//  Welfare Treasure
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIAlertTool.h"
//#import "WTBaseTool.h"
#import <objc/runtime.h>
#define IAIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define ConfirmBlock @"ConfirmBlock"
#define CancleBlock @"CancleBlock"
typedef void (^confirm)(NSInteger buttonIndex);
typedef void (^cancle)();
@interface UIAlertTool(){
    confirm confirmParam;
    cancle  cancleParam;
}
@end
@implementation UIAlertTool
+(void)showAlertViewTitle:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)cancelButtonTitle OtherTitle:(NSArray *)otherButtonTitle Confirm:(void (^)(NSInteger buttonIndex))confirm Cancle:(void (^)())cancle{
    if (confirm)
        objc_setAssociatedObject(self, ConfirmBlock, confirm, OBJC_ASSOCIATION_COPY);
    if (cancle)
        objc_setAssociatedObject(self, CancleBlock, cancle, OBJC_ASSOCIATION_COPY);
    // self->confirmParam=confirm;
    //  self->cancleParam=cancle;
    if (IAIOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        if (cancelButtonTitle.length>0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (cancle)
                    cancle();
            }];
            [cancelAction setValue:[UIColor colorWithHexString:@"eeeeee"] forKey:@"titleTextColor"];
            [alertController addAction:cancelAction];
        }
        if (otherButtonTitle.count>0) {
            for (int i = 0; i<otherButtonTitle.count; i++) {
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if (confirm)
                        confirm(i);
                }];
                [otherAction setValue:[UIColor colorWithHexString:@"eeeeee"] forKey:@"titleTextColor"];
                [alertController addAction:otherAction];
            }
        }
        [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        for (NSString* string in otherButtonTitle)
            [TitleAlert addButtonWithTitle:string];
        
        [TitleAlert show];
  
    }

}
+(void)showAlertViewTitle:(NSString *)title Message:(NSString *)message CancelTitle:(NSString *)cancelButtonTitle OtherTitle:(NSArray *)otherButtonTitle AndBtnsColor:(NSArray*)colors Confirm:(void (^)(NSInteger buttonIndex))confirm Cancle:(void (^)())cancle{
    if (confirm)
        objc_setAssociatedObject(self, ConfirmBlock, confirm, OBJC_ASSOCIATION_COPY);
    if (cancle)
        objc_setAssociatedObject(self, CancleBlock, cancle, OBJC_ASSOCIATION_COPY);
    // self->confirmParam=confirm;
    //  self->cancleParam=cancle;
    if (IAIOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        // Create the actions.
        if (cancelButtonTitle.length>0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (cancle)
                    cancle();
            }];
            NSString* cancelColor = colors[0];
            if (cancelColor.length>1)
                [cancelAction setValue:[UIColor colorWithHexString:cancelColor] forKey:@"titleTextColor"];
            [alertController addAction:cancelAction];
        }
        if (otherButtonTitle.count>0) {
            for (int i = 0; i<otherButtonTitle.count; i++) {
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if (confirm)
                        confirm(i);
                }];
                NSString* otherColor = colors[1];
                if (otherColor.length>1)
                    [otherAction setValue:[UIColor colorWithHexString:otherColor] forKey:@"titleTextColor"];
               // [otherAction setValue:[UIColor colorWithHexString:@"eeeeee"] forKey:@"titleTextColor"];
                [alertController addAction:otherAction];
            }
        }
        [[self getCurrentVC] presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIAlertView *TitleAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        for (NSString* string in otherButtonTitle)
            [TitleAlert addButtonWithTitle:string];
        
        [TitleAlert show];
        
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        cancleParam = objc_getAssociatedObject(self,CancleBlock);
        if (cancleParam ) cancleParam();
    }
    else{
         confirmParam = objc_getAssociatedObject(self,ConfirmBlock);
       if (confirmParam) confirmParam(buttonIndex);
    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
@end
