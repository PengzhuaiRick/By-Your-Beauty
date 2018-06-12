//
//  UIActionSheetTool.m
//  Welfare Treasure
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIActionSheetTool.h"
#import <objc/runtime.h>

#define ConfirmBlock @"ConfirmBlock"
#define CancleBlock @"CancleBlock"

typedef void (^confirm)(NSInteger buttonIndex);
typedef void (^cancle)();

@implementation UIActionSheetTool{
    confirm confirmParam;
    cancle  cancleParam;
}
+(void)showActionShootTitle:(NSString *)title antTarget:(id<UIActionSheetDelegate>)delegate CancelTitle:(NSString *)cancelButtonTitle OtherTitle:(NSArray *)otherButtonTitle Confirm:(void (^)(NSInteger buttonIndex))confirm Cancle:(void (^)())cancle{

    if (confirm)
        objc_setAssociatedObject(self, ConfirmBlock, confirm, OBJC_ASSOCIATION_COPY);
    if (cancle)
        objc_setAssociatedObject(self, CancleBlock, cancle, OBJC_ASSOCIATION_COPY);
    
    if (IOS_VERSION>8.0) {
        UIAlertController* sheet = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        if (cancelButtonTitle.length>0) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (cancle)
                    cancle();
            }];
            [sheet addAction:cancelAction];
        }
        
        if (otherButtonTitle.count>0) {
            for (int i = 1; i<otherButtonTitle.count+1; i++) {
                UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle[i-1] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if (confirm)
                        confirm(i);
                }];
               
                [sheet addAction:otherAction];
            }
        }
         [[self getCurrentVC] presentViewController:sheet animated:YES completion:nil];

    }else{
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:title
                                      delegate:delegate
                                      cancelButtonTitle:cancelButtonTitle
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:nil];
        for (NSString* string in otherButtonTitle)
            [actionSheet addButtonWithTitle:string];
        
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:[self getCurrentVC].view];
  }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"SDAS  %ld",buttonIndex);
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
