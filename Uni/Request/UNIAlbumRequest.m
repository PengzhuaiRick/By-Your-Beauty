//
//  UNIAlbumRequest.m
//  Uni
//
//  Created by apple on 16/8/30.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIAlbumRequest.h"

@implementation UNIAlbumModel
-(id)initWithDic:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        [self analyDic:dic];
    }
    return self;
}
-(void)analyDic:(NSDictionary*)dic{
    self.imgUrl = [self safeObject:dic ForKey:@"imgUrl"];
    self.intro = [self safeObject:dic ForKey:@"intro"];
}


@end

@implementation UNIAlbumRequest
-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray *)array{
    // NSLog(@"requestSucceed  %@",dic);
    // NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    int code = [[self safeObject:dic ForKey:@"code"] intValue];
    NSString* tips = [self safeObject:dic ForKey:@"tips"];
    if (code != 0) {
        if (tips.length<1) tips = @"服务器处理失败， 未知错误";
    }
    //相册
    if ([param2 isEqualToString:API_URL_GetShopImages] ) {
        if (code == 0) {
            NSArray* imgList = [self safeObject:dic ForKey:@"imgList"];
            NSMutableArray* arr = [NSMutableArray arrayWithCapacity:imgList.count];
            for (NSDictionary* dia in imgList) {
                UNIAlbumModel* model = [[UNIAlbumModel alloc]initWithDic:dia];
                [arr addObject:model];
            }
            if (_getShopImages)
                _getShopImages(arr,tips,nil);
        }else{
            if (_getShopImages)
                _getShopImages(nil,tips,nil);
        }
        
    }
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    // NSString* param1 = array[0];
    NSString* param2 = array[0];
    
    //相册
    if ([param2 isEqualToString:API_URL_GetShopImages]){
        if (_getShopImages)
            _getShopImages(nil,nil,err);
        
    }
       
    
    
}
@end
