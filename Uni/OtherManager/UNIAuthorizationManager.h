//
//  UNIAuthorizationManager.h
//  Uni
//  微信授权管理
//  Created by apple on 16/4/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApiManager.h"

@interface UNIAuthorizationManager : NSObject<WXApiManagerDelegate,WXApiDelegate>{
    NSString* wxUnionid;
    NSString* wxOpenid;
}
-(void)AuthorizationManager:(UIViewController*)viewC;

@end
