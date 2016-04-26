//
//  UNIAppDeleRequest.m
//  Uni
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppDeleRequest.h"

@implementation UNIAppDeleRequest
//-(void)requestFirstUrlSucceed:(int)code{
//    _rqfirstUrl(code);
//}

-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
   // NSLog(@"requestSucceed  %@",dic);
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    if (code != 0) {
        if (tips.length<1) tips = @"服务器处理失败， 未知错误";
    }
    
    //检查版本信息
    if ([param1 isEqualToString:API_PARAM_UNI]){
       if ( [param2 isEqualToString:API_URL_CheckVersion]) {
        if (code == 0) {
            NSString* version = [self safeObject:dic ForKey:@"version"];
            NSString* desc = [self safeObject:dic ForKey:@"desc"];
            NSString* url = [self safeObject:dic ForKey:@"url"];
            int type = [[self safeObject:dic ForKey:@"type"] intValue];
            _reqheckVersion(version,url,desc,tips,type,nil);
        }else
            _reqheckVersion(nil,nil,nil,nil,-1,nil);
    }
    
        if ([param2 isEqualToString:API_URL_Welcome]) {
        if (code == 0) {
            NSString* url = [self safeObject:dic ForKey:@"url"];
            _rqwelcomeBlock(url,tips,nil);
        }else
            _rqwelcomeBlock(nil,tips,nil);
    }
        //用户到店
        if ([param2 isEqualToString:API_URL_ArriveShop]) {
            if (code == 0) {
                _setArriveShopBlock(0,tips,nil);
            }else
                _setArriveShopBlock(-1,tips,nil);
        }

    }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    //检查版本信息
    if ([param1 isEqualToString:API_PARAM_UNI]){
        if ( [param2 isEqualToString:API_URL_CheckVersion])
            _reqheckVersion(nil,nil,nil,nil,-1,err);
    
        if ([param2 isEqualToString:API_URL_Welcome])
            _rqwelcomeBlock(nil,nil,err);
        //用户到店
        if ([param2 isEqualToString:API_URL_ArriveShop])
            _setArriveShopBlock(-1,nil,err);
    }
}
@end
