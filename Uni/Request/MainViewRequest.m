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
                int count =[[self safeObject:dic ForKey:@"count"]intValue];
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* array = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dia in result) {
                    UNIMyAppintModel * model = [[UNIMyAppintModel alloc]initWithDic:dia];
                    [array addObject:model];
                }
                _reappointmentBlock(count,array,tips,nil);
            }else
                _reappointmentBlock(-1,nil,tips,nil);
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
                manager.shortName =[self safeObject:dic ForKey:@"shortName"];
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
               NSString* projectName = [self safeObject:dic ForKey:@"projectName"];
               _rerewardBlock(nextRewardNum,num,projectName,tips,nil);
           }else
               _rerewardBlock(-1,-1,nil,tips,nil);
        }
        if ([param2 isEqualToString:API_URL_GetImgByshopIdCode] ) {
            if (code == 0) {
                 NSArray* result = [self safeObject:dic ForKey:@"result"];
                _reMainBgBlock(result,tips,nil);
            }else
                 _reMainBgBlock(nil,tips,nil);
        }
        
        if ([param2 isEqualToString:API_URL_GetSellInfo] ) {
            if (code == 0) {
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* arr = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dic in result) {
                    UNIGoodsModel* model = [[UNIGoodsModel alloc]initWithDic:dic];
                    [arr addObject:model];
                }
                _resellInfoBlock(arr,tips,nil);
            }else
                _resellInfoBlock(nil,tips,nil);
        }
        if ([param2 isEqualToString:API_URL_GetSellInfo2] ) {
            if (code == 0) {
                    UNIGoodsModel* model = [[UNIGoodsModel alloc]initWithDic:dic];
                NSArray* arr = @[model];
                _resellInfoBlock(arr,tips,nil);
            }else
                _resellInfoBlock(nil,tips,nil);
        }


    }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];
    NSString* param2 = array[1];

    
    if ([param1 isEqualToString:API_PARAM_UNI]) {
        //获取已预约信息
        if ([param2 isEqualToString:API_URL_Appoint])
            _reappointmentBlock(-1,nil,nil,err);
        
        //商店信息
        if ([param2 isEqualToString:API_URL_ShopInfo] )
            _reshopInfoBlock(nil,nil,err);
        
        
        //获取奖励信息
        if ([param2 isEqualToString:API_URL_MRInfo]) 
             _rerewardBlock(-1,-1,nil,nil,err);
        
        //获取我的未预约项目
        if ([param2 isEqualToString:API_URL_MyProjectInfo])
            _remyProjectBlock(nil,nil,err);
        
        if ([param2 isEqualToString:API_URL_GetImgByshopIdCode] )
            _reMainBgBlock(nil,nil,err);
        
        if ([param2 isEqualToString:API_URL_GetSellInfo] )
            _resellInfoBlock(nil,nil,err);
        
        if ([param2 isEqualToString:API_URL_GetSellInfo2] ) {
            _resellInfoBlock(nil,nil,err);
        }

    }


}
@end
