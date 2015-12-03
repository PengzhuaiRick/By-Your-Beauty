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
 *  是否第一次登陆
 */
#define FIRSTINSTALL @"firstInstall"

/**
 *  主题颜色
 */
#define kMainThemeColor @"e23469"

/**
 *  背景颜色
 */
#define kMainBackGroundColor @"e4e5e9"

/**
 *  字体灰色颜色
 */
#define kMainTitleColor @"575757"

/**
 *  当前系统版本号
 */
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]


/**
 *  获取当前版本号
 *
 */
#define CURRENTVERSION [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

/**
 *  系统屏幕宽度
 */
#define KMainScreenWidth [UIScreen mainScreen].bounds.size.width

/**
 *  系统屏幕高度
 */
#define KMainScreenHeight [UIScreen mainScreen].bounds.size.height

/**
 *   当前系统是7.0或以上
 */
#define IS_IOS7_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >=7.0)

/**
 *   当前系统是8.0或以上
 */
#define IS_IOS8_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >=8.0)

#endif /* Config_h */
