//
//  YIUserLocationMessage.h
//  YIVasMobile
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 YixunInfo Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//NSLog(@"");
@interface YIUserLocationMessage : NSObject

@property (nonatomic,copy) NSString* state;            //国家
@property (nonatomic,copy) NSString* province;         //省份
@property (nonatomic,copy) NSString* city;             //城市
@property (nonatomic,copy) NSString* latitude;         //纬度
@property (nonatomic,copy) NSString* longitude;        //经度
@property (nonatomic,copy) NSString* altitude;         //海拔高度
@property (nonatomic,copy) NSString* detailmessage;    //详细地址


@end
