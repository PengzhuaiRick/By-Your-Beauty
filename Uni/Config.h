//
//  Config.h
//  Uni
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#ifndef Config_h
#define Config_h

/**
 *  当前系统版本号
 */
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


/**
 *  系统屏幕宽度
 */
#define KMainScreenWidth [UIScreen mainScreen].bounds.size.width

/**
 *  系统屏幕高度
 */
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height


#define IS_IOS7_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >=7.0)

#define IS_IOS8_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >=8.0)

#endif /* Config_h */
