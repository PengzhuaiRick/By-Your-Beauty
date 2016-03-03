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
    self.MY_LIBAO_SHARE_RUL = [self safeObject:dic ForKey:@"MY_LIBAO_SHARE_RUL"];
    self.WX_GET_PREAPYID = [self safeObject:dic ForKey:@"WX_GET_PREAPYID"];
    self.WX_HB_URL = [self safeObject:dic ForKey:@"WX_HB_URL"];
    self.WX_LIBAO_URL = [self safeObject:dic ForKey:@"WX_LIBAO_URL"];
    self.WX_SHARE_URL = [self safeObject:dic ForKey:@"WX_SHARE_URL"];
    self.MY_YH_URL = [self safeObject:dic ForKey:@"MY_YH_URL"];
    
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
