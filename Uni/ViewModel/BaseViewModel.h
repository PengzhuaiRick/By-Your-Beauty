//
//  BaseViewModel.h
//  Uni
//
//  Created by apple on 15/11/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>

@interface BaseViewModel : NSObject
/**
 *  POST请求
 *   SD
 *  @param code   业务码
 *  @param params 参数
 */
-(void)postWithSerCode:(int)code params:(NSMutableDictionary *)params;


/**
 *  GET请求
 *
 *  @param code   业务码
 *  @param params 参数
 */
-(void)getWithSerCode:(int)code params:(NSMutableDictionary *)params;

/**
 *  删除所有请求
 */
-(void)cancelAllOperation;

/**
 *  MD5加密
 *
 *  @param str 需要加密的参数
 *
 *  @return 加密完成的参数
 */
+ (NSString *)md5Encrypt:(NSString *)str;
@end
