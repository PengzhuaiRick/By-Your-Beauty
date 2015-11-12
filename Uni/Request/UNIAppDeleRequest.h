//
//  UNIAppDeleRequest.h
//  Uni
//
//  Created by apple on 15/11/12.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
/**
 *  请求版本号成功Block
 *
 *  @param version 版本号
 *  @param url     下载链接
 *  @param desc    更新内容
 *  @param tips    反馈信息
 *  @param type    更新类型;0---必须更新；1----可选更新
 *  @param er      错误信息
 */
typedef void(^RQCheckVersion)(NSString* version,NSString* url,NSString* desc,NSString*tips, int type,NSError* er);

/**
 *  请求欢迎页面Block
 *
 *  @param url  图片路径
 *  @param tips 反馈信息
 *  @param er   错误信息
 */
typedef void(^RqWelcomeBlock)(NSString* url,NSString* tips,NSError* er);


@interface UNIAppDeleRequest : BaseRequest

//请求版本号成功Block
@property(nonatomic,copy)RQCheckVersion reqheckVersion;


//请求欢迎页面Block
@property(nonatomic,copy)RqWelcomeBlock rqwelcomeBlock;

@end
