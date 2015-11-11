//
//  UNILoginViewRequest.h
//  Uni
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"

@interface UNILoginViewRequest : BaseRequest

/**
 *  请求登陆验证码
 *
 *  @param code   业务吗
 *  @param params 参数
 */
-(void)requestVertificationCode:(NSString*)code andParams:(NSDictionary*)params;
@end
