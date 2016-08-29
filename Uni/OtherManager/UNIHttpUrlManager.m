//
//  UNIHttpUrlManager.m
//  Uni
//
//  Created by apple on 16/3/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIHttpUrlManager.h"

@implementation UNIHttpUrlManager
+ (UNIHttpUrlManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    static UNIHttpUrlManager *sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[UNIHttpUrlManager alloc] init];
        
    });
    return sSharedInstance;
}

-(void)initHttpUrlManager:(NSDictionary*)dic{
    self.APP_KZ_URL = [self safeObject:dic ForKey:@"APP_KZ_URL"];
    self.MY_LIBAO_SHARE_URL = [self safeObject:dic ForKey:@"MY_LIBAO_SHARE_URL"];
    self.WX_GET_PREAPYID = [self safeObject:dic ForKey:@"WX_GET_PREAPYID"];
    self.WX_HB_URL = [self safeObject:dic ForKey:@"WX_HB_URL"];
    self.WX_LIBAO_URL = [self safeObject:dic ForKey:@"WX_LIBAO_URL"];
    self.WX_SHARE_URL = [self safeObject:dic ForKey:@"WX_SHARE_URL"];
    self.MY_YH_URL = [self safeObject:dic ForKey:@"MY_YH_URL"];
    self.APP_BWHL_SHARE_DESC = [self safeObject:dic ForKey:@"APP_BWHL_SHARE_DESC"];
    self.APP_BWHL_SHARE_TITLE = [self safeObject:dic ForKey:@"APP_BWHL_SHARE_TITLE"];
    self.APP_HB_SHARE_DESC = [self safeObject:dic ForKey:@"APP_HB_SHARE_DESC"];
    self.APP_HB_SHARE_TITLE = [self safeObject:dic ForKey:@"APP_HB_SHARE_TITLE"];
    self.APP_BWHL_SHARE_IMG = [self safeObject:dic ForKey:@"APP_BWHL_SHARE_IMG"];
    self.APP_HB_SHARE_IMG = [self safeObject:dic ForKey:@"APP_HB_SHARE_IMG"];
    self.APPOINT_SUCCESS = [self safeObject:dic ForKey:@"APPOINT_SUCCESS"];
    self.APPOINT_SUCCESS_TIPS = [self safeObject:dic ForKey:@"APPOINT_SUCCESS_TIPS"];
    self.GOTOBUY = [self safeObject:dic ForKey:@"GOTOBUY"];
    self.IS_APPOINT = [self safeObject:dic ForKey:@"IS_APPOINT"];
    self.NO_CASE_TIPS = [self safeObject:dic ForKey:@"NO_CASE_TIPS"];
    self.NO_ORDER_TIPS = [self safeObject:dic ForKey:@"NO_ORDER_TIPS"];
    self.APPOINT_DESC = [self safeObject:dic ForKey:@"APPOINT_DESC"];
    self.MORE_YH_TIPS = [self safeObject:dic ForKey:@"MORE_YH_TIPS"];
    self.SELF_APPOINT_TITLE = [self safeObject:dic ForKey:@"SELF_APPOINT_TITLE"];
    self.SELF_APPOINT_CONTENT = [self safeObject:dic ForKey:@"SELF_APPOINT_CONTENT"];
    self.MAIN_BOTTOM_TIPS = [self safeObject:dic ForKey:@"MAIN_BOTTOM_TIPS"];
    
    //NSLog(@"APP_KZ_URL %@  MY_LIBAO_SHARE_RUL %@     WX_GET_PREAPYID %@",self.APP_KZ_URL,self.MY_LIBAO_SHARE_RUL,self.WX_GET_PREAPYID);
}

- (id)safeObject:(NSDictionary*)dic ForKey:(id)aKey{
    id obj = [dic objectForKey:aKey];
    if ([obj isEqual:[NSNull null]]) {
        obj = nil;
    }
    return obj;
}
@end
