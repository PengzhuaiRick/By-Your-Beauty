//
//  BaseRequest.h
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <CommonCrypto/CommonDigest.h>
@interface BaseRequest : NSObject
/**
 *  POST请求
 *   SD
 *  @param code   业务码
 *  @param params 参数
 */
-(void)postWithSerCode:(NSArray*)code params:(NSDictionary *)params;

/**
 *  POST请求 没有token userId shopId
 *  @param code   业务码
 *  @param params 参数
 */
-(void)postWithoutUserIdSerCode:(NSArray*)code params:(NSDictionary *)params;

/**
 *  GET请求
 *
 *  @param code   业务码
 *  @param params 参数
 */
-(void)getWithSerCode:(NSArray*)code params:(NSDictionary *)params;

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


-(void)requestSucceed:(NSDictionary*)dic andIdenCode:(NSArray*)array;

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray*)array;


- (id)safeObject:(NSDictionary*)dic ForKey:(id)aKey;
@end
