//
//  UNICardInfoRequest.m
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNICardInfoRequest.h"

@implementation UNICardInfoRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    
    //会员卡详情接口
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        if ([param2 isEqualToString:API_URL_GetCardInfo]) {
            if (code == 0) {
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* models = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dic in result) {
                    UNIMyAppointInfoModel* model = [[UNIMyAppointInfoModel alloc]initWithDic:dic];
                    [models addObject:model];
                }
                _cardInfoBlock(models,tips,nil);
            }else
                _cardInfoBlock(nil,tips,nil);
               }
        //准时奖励
        if ([param2 isEqualToString:API_URL_ITRewardInfo]) {
            if (code == 0) {
                int nextRewardNum = [[self safeObject:dic ForKey:@"nextRewardNum"]intValue];
                int num = [[self safeObject:dic ForKey:@"num"]intValue];
                _rqrewardBlock(nextRewardNum,num,tips,nil);
            }else
                _rqrewardBlock(-1,-1,tips,nil);
        }
    }
    
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
   
    if ([param1 isEqualToString:API_PARAM_UNI]) {
         //会员卡详情接口
        if ([param2 isEqualToString:API_URL_GetCardInfo])
             _cardInfoBlock(nil,nil,err);
       // 准时奖励
         if ([param2 isEqualToString:API_URL_ITRewardInfo])
             _rqrewardBlock(-1,-1,nil,err);
    }
}
@end
