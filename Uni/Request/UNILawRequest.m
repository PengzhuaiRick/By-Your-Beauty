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
    NSString* param2 = array[0];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    if (code != 0) {
        if (tips.length<1) tips = @"服务器处理失败， 未知错误";
    }
        //
        if ([param2 isEqualToString:API_URL_GetTextInfo]) {
            if (code == 0) {
                NSString* url = [self safeObject:dic ForKey:@"url"];
                _getLawInfoBlock(url,tips,nil);
            }else
                _getLawInfoBlock(nil,tips,nil);
        }
    
    
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    //NSString* param1 = array[0];
    NSString* param2 = array[0];
        //获取订单列表
        if ([param2 isEqualToString:API_URL_GetTextInfo]) {
                _getLawInfoBlock(nil,nil,err);
        }

}

@end
