//
//  MainViewRequest.h
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
@interface MainViewRequest : BaseRequest

//请求版本号成功Block
typedef void(^RQCheckVersion)(float version,NSString* url);
@property(nonatomic,copy)RQCheckVersion reqheckVersion;
/**
 *  请求版本号
 *
 *  @param code   业务吗
 *  @param params 参数
 */
-(void)requestCheckVersion:(NSString*)code andParams:(NSDictionary *)params;

@end
