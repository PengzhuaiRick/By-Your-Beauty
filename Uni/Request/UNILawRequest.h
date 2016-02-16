//
//  UNILawRequest.h
//  Uni
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseRequest.h"
/**
 *  获取法律声明接口
 *
 *  @param url  地址
 *  @param tips 信息提示
 *  @param err  错误信息
 */
typedef void(^GetLawInfoBlock)(NSString* url,NSString* tips,NSError* err);

@interface UNILawRequest : BaseRequest

@property(nonatomic,copy)GetLawInfoBlock getLawInfoBlock;
@end
