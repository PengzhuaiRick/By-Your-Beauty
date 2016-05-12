//
//  MainViewRequest.m
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewRequest.h"
#import "UNIHttpUrlManager.h"
@implementation MainViewRequest

-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
   // NSLog(@"requestSucceed  %@",dic);
    NSString* param1 = array[0];
   // NSString* param2 = array[1];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    if (code != 0) {
        if (tips.length<1) tips = @"服务器处理失败， 未知错误";
    }
    
        //获取已预约信息
        if([param1 isEqualToString:API_URL_Appoint]){
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
        if ([param1 isEqualToString:API_URL_MyProjectInfo]) {
            
            int count = [[self safeObject:dic ForKey:@"count"] intValue];
            if (code==0) {
                NSArray* result = [self safeObject:dic ForKey:@"result"];
                NSMutableArray* array = [NSMutableArray arrayWithCapacity:result.count];
                for (NSDictionary* dia in result) {
                    UNIMyProjectModel * model = [[UNIMyProjectModel alloc]initWithDic:dia];
                    [array addObject:model];
                }
                _remyProjectBlock(array,count,tips,nil);
            }else
            _remyProjectBlock(nil,count,tips,nil);
        }
        //获取商铺信息
        if ([param1 isEqualToString:API_URL_ShopInfo] ) {
            if (code == 0) {
                UNIShopManage* manager =[[UNIShopManage alloc]initWithDictionary:dic];
//                manager.shopName = [self safeObject:dic ForKey:@"shopName"];
//                manager.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
//                manager.address = [self safeObject:dic ForKey:@"address"];
//                manager.telphone = [self safeObject:dic ForKey:@"telphone"];
//                manager.shortName =[self safeObject:dic ForKey:@"shortName"];
//                NSArray* arr = [UNIShopManage bd_decrypt:[[self safeObject:dic ForKey:@"latitude"] doubleValue]
//                                                     and:[[self safeObject:dic ForKey:@"longitude"] doubleValue]];
//                manager.x = [self safeObject:dic ForKey:@"latitude"];
//                manager.y = [self safeObject:dic ForKey:@"longitude"];
//                manager.x = arr[0];
//                manager.y= arr[1];
                [UNIShopManage saveShopData:manager];
                _reshopInfoBlock(manager,tips,nil);
            }else
                _reshopInfoBlock(nil,tips,nil);
        }
        //获取约满奖励
       if ([param1 isEqualToString:API_URL_MRInfo] ) {
           
           if (code == -1) {
               [UIAlertView showWithTitle:@"提示" message:@"您授权码已过期！请重新登录" cancelButtonTitle:@"知道" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                   [[NSNotificationCenter defaultCenter]postNotificationName:@"setupLoginController" object:nil];
               }];
               
           }
           
           if (code == 0) {
               int nextRewardNum = [[self safeObject:dic ForKey:@"nextRewardNum"] intValue];
               int num = [[self safeObject:dic ForKey:@"num"] intValue];
               int type = [[self safeObject:dic ForKey:@"type"] intValue];
               int goodsId = [[self safeObject:dic ForKey:@"goodsId"] intValue];
               NSString* projectName = [self safeObject:dic ForKey:@"projectName"];
                NSString* title = [self safeObject:dic ForKey:@"title"];
               NSString* url = [self safeObject:dic ForKey:@"url"];
               _rerewardBlock(nextRewardNum,num,type,goodsId,url,projectName,title,tips,nil);
           }else
               _rerewardBlock(-1,-1,-1,-1,nil,nil,nil,tips,nil);
          
        }
        if ([param1 isEqualToString:API_URL_GetImgByshopIdCode] ) {
            if (code == 0) {
//                UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
//                [manager initHttpUrlManager:dic];
                 NSArray* result = [self safeObject:dic ForKey:@"result"];
                _reMainBgBlock(result,tips,nil);
            }else
                 _reMainBgBlock(nil,tips,nil);
        }
        
        if ([param1 isEqualToString:API_URL_GetSellInfo] ) {
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
        if ([param1 isEqualToString:API_URL_GetSellInfo2] ) {
            if (code == 0) {
                    UNIGoodsModel* model = [[UNIGoodsModel alloc]initWithDic:dic];
                NSArray* arr = @[model];
                _resellInfoBlock(arr,tips,nil);
            }else
                _resellInfoBlock(nil,tips,nil);
        }
        if ([param1 isEqualToString:API_URL_HasActivity] ) {
            if (code == 0) {
                NSDictionary* result = [self safeObject:dic ForKey:@"result"];
                int hasActivity = [[self safeObject:result ForKey:@"hasActivity"] intValue];
                int activityId = [[self safeObject:result ForKey:@"activityId"] intValue];
                _rqactivity(hasActivity,activityId,tips,nil);
            }else
                _rqactivity(-1,-1,tips,nil);
        }
        
        //审核期间是否显示活动
        if ([param1 isEqualToString:API_URL_RetCode]) {
            _rqshowAcitivityOrNot(code,tips,nil);
        }
    
        //获取APP提示信息
        if ([param1 isEqualToString:API_URL_GetAppTips]) {
//                UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
//                [manager initHttpUrlManager:dic];
                _rqAppTips(dic,nil,nil);
        }

    
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    NSString* param1 = array[0];

        //获取已预约信息
        if ([param1 isEqualToString:API_URL_Appoint])
            _reappointmentBlock(-1,nil,nil,err);
        
        //商店信息
        if ([param1 isEqualToString:API_URL_ShopInfo] )
            _reshopInfoBlock(nil,nil,err);
        
        
        //获取奖励信息
        if ([param1 isEqualToString:API_URL_MRInfo])
             _rerewardBlock(-1,-1,-1,-1,nil,nil,nil,nil,err);
        
        //获取我的未预约项目
        if ([param1 isEqualToString:API_URL_MyProjectInfo])
            _remyProjectBlock(nil,-1,nil,err);
        
        if ([param1 isEqualToString:API_URL_GetImgByshopIdCode] )
            _reMainBgBlock(nil,nil,err);
        
        if ([param1 isEqualToString:API_URL_GetSellInfo] )
            _resellInfoBlock(nil,nil,err);
        
        if ([param1 isEqualToString:API_URL_GetSellInfo2] ) {
            _resellInfoBlock(nil,nil,err);
        }
        if ([param1 isEqualToString:API_URL_HasActivity] ) {
                _rqactivity(-1,-1,nil,err);
        }
        //审核期间是否显示活动
        if ([param1 isEqualToString:API_URL_RetCode]) {
            _rqshowAcitivityOrNot(-1,nil,err);
        }
    //获取APP提示信息
    if ([param1 isEqualToString:API_URL_GetAppTips]) {
        _rqAppTips(nil,nil,err);
    }

}
@end
