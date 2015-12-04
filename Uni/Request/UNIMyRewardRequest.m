//
//  UNIMyRewardRequest.m
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMyRewardRequest.h"

@implementation UNIMyRewardRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    
    if ([param1 isEqualToString:API_PARAM_UNI]) {
         //约满奖励
        if ([param2 isEqualToString:API_URL_MYRewardInfo]) {
            if (code == 0) {
                int num = [[self safeObject:dic ForKey:@"num"] intValue];
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* models = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dic in result) {
                    UNIMyRewardModel* model = [[UNIMyRewardModel alloc]initWithDic:dic];
                    [models addObject:model];
                }
                _myrewardBlock(models,num,tips,nil);
            }else
                _myrewardBlock(nil,-1,tips,nil);
            }
        }
        //准时奖励
        if ([param2 isEqualToString:API_URL_MYITRewardInfo]) {
            if (code == 0) {
                int num = [[self safeObject:dic ForKey:@"num"] intValue];
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* models = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dic in result) {
                    UNIMyRewardModel* model = [[UNIMyRewardModel alloc]initWithDic:dic];
                    [models addObject:model];
                }
            _intimeBlock(models,num,tips,nil);
            }
            else
                _intimeBlock(nil,-1,tips,nil);
        }
    

}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        //约满奖励
        if ([param2 isEqualToString:API_URL_MYRewardInfo])
            _myrewardBlock(nil,-1,nil,err);
        // 准时奖励
        if ([param2 isEqualToString:API_URL_MYITRewardInfo])
            _intimeBlock(nil,-1,nil,err);
    }
}

@end
