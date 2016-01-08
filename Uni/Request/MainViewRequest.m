//
//  MainViewRequest.m
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewRequest.h"

@implementation MainViewRequest

-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
   // NSLog(@"requestSucceed  %@",dic);
    NSString* param1 = array[0];
    NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    
    
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        //获取已预约信息
        if([param2 isEqualToString:API_URL_Appoint]){
            if (code == 0) {
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* array = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dia in result) {
                    UNIMyAppintModel * model = [[UNIMyAppintModel alloc]initWithDic:dia];
                    [array addObject:model];
                }
                _reappointmentBlock(array,tips,nil);
            }else
                _reappointmentBlock(nil,tips,nil);
        }
        //获取我的未预约项目
        if ([param2 isEqualToString:API_URL_MyProjectInfo]) {
            if (code==0) {
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* array = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dia in result) {
                    UNIMyProjectModel * model = [[UNIMyProjectModel alloc]initWithDic:dia];
                    [array addObject:model];
                }
                _remyProjectBlock(array,tips,nil);
            }else
            _remyProjectBlock(nil,tips,nil);
        }
        //获取商铺信息
        if ([param2 isEqualToString:API_URL_ShopInfo] ) {
            if (code == 0) {
                UNIShopManage* manager =[[UNIShopManage alloc]init];
                manager.shopName = [self safeObject:dic ForKey:@"shopName"];
                manager.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
                manager.address = [self safeObject:dic ForKey:@"address"];
                manager.telphone = [self safeObject:dic ForKey:@"telphone"];
                manager.x = [self safeObject:dic ForKey:@"latitude"];
                manager.y = [self safeObject:dic ForKey:@"longitude"];
                [UNIShopManage saveShopData:manager];
                _reshopInfoBlock(manager,tips,nil);
            }else
                _reshopInfoBlock(nil,tips,nil);
        }
        //获取约满奖励
       if ([param2 isEqualToString:API_URL_MRInfo] ) {
           if (code == 0) {
               int nextRewardNum = [[self safeObject:dic ForKey:@"nextRewardNum"] intValue];
               int num = [[self safeObject:dic ForKey:@"num"] intValue];
               _rerewardBlock(nextRewardNum,num,tips,nil);
           }else
               _rerewardBlock(-1,-1,tips,nil);
        }
    }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];

    
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        //获取已预约信息
        if ([param2 isEqualToString:API_URL_Appoint])
            _reappointmentBlock(nil,nil,err);
        
        //商店信息
        if ([param2 isEqualToString:API_URL_ShopInfo] )
            _reshopInfoBlock(nil,nil,err);
        
        
        //获取奖励信息
        if ([param2 isEqualToString:API_URL_MRInfo]) 
             _rerewardBlock(-1,-1,nil,err);
        
        //获取我的未预约项目
        if ([param1 isEqualToString:API_URL_MyProjectInfo])
            _remyProjectBlock(nil,nil,err);
    }


}
@end
