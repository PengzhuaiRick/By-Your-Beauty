//
//  UNILawRequest.m
//  Uni
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNILawRequest.h"

@implementation UNILawRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
   // NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];

        //获取订单列表
        if ([param2 isEqualToString:API_URL_GetTextInfo]) {
            if (code == 0) {
                NSString* url = [self safeObject:dic ForKey:@"url"];
                _getLawInfoBlock(url,tips,nil);
            }else
                _getLawInfoBlock(nil,tips,nil);
        }
    
    
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        //获取订单列表
        if ([param2 isEqualToString:API_URL_GetTextInfo]) {
                _getLawInfoBlock(nil,nil,err);
        }
    }

}

@end
