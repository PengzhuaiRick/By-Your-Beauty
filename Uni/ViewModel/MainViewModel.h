//
//  MainViewModel.h
//  Uni
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseViewModel.h"
#import "MainViewRequest.h"
@interface MainViewModel : BaseViewModel


/**
 *  请求版本号
 *
 *  @param code   业务吗
 *  @param params 参数
 */
-(void)requestViewModelCheckVersion:(NSArray*)code andParams:(NSDictionary *)params;
@end
