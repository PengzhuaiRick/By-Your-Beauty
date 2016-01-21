//
//  Config.h
//  Uni
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 apple. All rights reserved.
//

#ifndef Config_h
#define Config_h

#define CONTAITVIEWCLOSE @"closeTheBox"
#define CONTAITVIEWOPEN @"openTheBox"

#define APPOINTANDREFLASH @"APPOINTANDREFLASH"

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
 *  按钮背景绿色颜色
 */
#define kMainGreenBackColor @"24CDB8"

/**
 *  按钮背景灰色颜色
 */
#define kMainGrayBackColor [UIColor colorWithRed:180/255.f green:180/255.f blue:180/255.f alpha:1]

/**
 *  字体
 */
#define kMainFont(si)  [UIFont fontWithName:@"Arial-BoldItalicMT" size:si];


/**
 *  本地通知数量
 */
#define kLocateNotification @"locateNotificateNum"


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

/**
 *   当前系统是9.0或以上
 */
#define IS_IOS9_OR_LATER ([[UIDevice currentDevice].systemVersion floatValue] >=9.0)




//支付宝公钥
#define ZFBPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB"
/* RSA私钥
-----BEGIN RSA PRIVATE KEY-----
MIICeAIBADANBgkqhkiG9w0BAQEFAASCAmIwggJeAgEAAoGBALWe8nqQhixVAHLgzu2oRJy6JNAtXTyzj2eCIfm8oeDH4yg+Q0x2rd+n9IlEVBxrvck6Xc7TEdFFHIbbla9fwtxiCn29BqjRJ/6fpQpHCr6+LNrpTr28nSZ38l1LpW0b50yr1kaxGPs4B0KEn2l6R1HYtTyIsuD02PimFqpwNAzNAgMBAAECgYBCvkq1p+7m08X6cYsZ40BzqCRnLISbDhGhJD2AHUYP6OUdoOPycZqsGnjPCQEwAJgaHwziOMbPdOpq1L9JV5Ov8kb+F6sWnahW3cKFkJq14l3v5nBjRBVuW6nWFSP44ZF6JVe9AY+DIRjVEzAYwppoLIyuFaZWLakN0RAFswZuAQJBAO3zUvcMIY0OuwZxPgQbpxgfgD8l6/rrJSTjT+s9NJhco5d+ydQb+qKcpb4EgL5chHvjoB6RNoVzjZ/iDiw/Dy0CQQDDZcdWnJ/rHrNl6TqP42qBJghuYFRd0EB+jXB0PblTmVUIwcHl/x7vV5V2Z2upDFG7U7AIdqko3gEW+wMKjnghAkEAiowF/6CJnIc6MHsZP+0V8r7MvngHGdd2ji7oprDBggFWo2wIej88RRhujOA0UiKuZTBZV9L3auaoTLKjy/F/lQJBAKT0ISpPIvn8evqHwDaEh/7rOqbjj5V7H1c21D5tdSzL/utblvMxQs5PJBBHEq4thjocVjlu4zNq54Sc915ME8ECQQCn9iSZQY7snMV+hiMt6CMHvOCe2EsC6IlwQrU+b6JXovm8yIqDM7qzb0I9k3C3us1NUEm6didHGXvX/u4lkQld
-----END RSA PRIVATE KEY-----
*/
#define ZFBRSAPrivateKey @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAOKBx0gyCpupUqI8xb3+sZ4ugAIT4ps21YO2wPwFknNaX4/Q7eZIrYmUz+O7QTCIKT9VVlzM1PWAdm84NuG25IXQDN/QTZQXPJ7H2/HiXgE0K8il5jMMrqKOMM9QGIs2YcyaYlMTJmg1YGoANhhydrLZDnvdQPhmc34i9Er5oIgNAgMBAAECgYBq06RmU1uXcLNNWvY0FnQ001+CG1jLtX/b4AyCkCozB1N8o6Af9PULp0io8j7bocw6V4gkumJR6yVwbQXNTJHX+1SFQceBmuRWs1CZlCjOmsm4PNqvjqDRr6G9EJR/YoayFf35Ne8m0thlrGc5SVoy5kO63MIvfnlgXM+ThArz7QJBAPDnLi+SUhbqZN+R/BOxPsdtLlV7nEZwUhIulHKtRLooCTLfqSUvcOB7kZsu8fyr7nLno/VEJmWpiyNv1IuhZMMCQQDws6QCV1xit1+8YaxrTtbaPCFagUNAlmtytl2qMjfkOg5v3ei4EXrjkHfqNZvRD1F+Z9WKq21kPqY17MSmz1LvAkEA3xjpn+q9FTXLZ3UV4tLR1fSZ5VaNenpIt0fl+HHYZSHwqumRBrvxqCMnzHRkbGB5enZlVB3iBWJHVfEaAJnd6wJAQ42XNRUBl67xTnR3KHKq9/qyPa1Ti5frtfkaln6bkxD8Jkc4XhiBzcYo8XF0Nps++uP3WYC9JcozaaT2l/5NvwJBAOvPg/1OZmYZbH5rsNQZPk16CbMWrC/JdIQy/FTQqFoeMbjEEm24QIOmwb00bQeckxBPInsTom9fyyH7Jkvon6I="




/* RSA公钥
 -----BEGIN PUBLIC KEY-----
 MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCfBkttKOOZcpQPTH8hETwvFyDmnIw6+qCaHUzQL9KdinK0TYUn/WC09b0GRYJJRSHYdQAXNjLnar8iL3wu2PH4dT+Vd3Cmu3HBZk8Mvrr29SjdeH1V6pNIAF2ch84pLOLKNCj1SEdZXMtd5d8coYTeDJPgW7UYkhYsuhjv831QIDAQAB
 -----END PUBLIC KEY-----
 */
#define ZFBRSAPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCfBkttKOOZcpQPTH8hETwvFyDmnIw6+qCaHUzQL9KdinK0TYUn/WC09b0GRYJJRSHYdQAXNjLnar8iL3wu2PH4dT+Vd3Cmu3HBZk8Mvrr29SjdeH1V6pNIAF2ch84pLOLKNCj1SEdZXMtd5d8coYTeDJPgW7UYkhYsuhjv831QIDAQAB"

//支付宝PID
#define ZFBPID @"2088121108997680"

//支付宝收款账号
#define ZFBACCOUNT @"YOUunimail@163.com"

//极光推送
#define APNSAppKey @"8c76934a7b516967128ea8b4"
#define APNSMasterSecret @"954989e225869603cef4d00b"


//微信AppID：wx2c500aabc49b7269
//AppSecret：282594f4d5ec2be53e9d74d40f7d5d6a
#define WECHATAPPID @"wx2c500aabc49b7269"
#define WECHATAPPSecret @"282594f4d5ec2be53e9d74d40f7d5d6a"


// 百度统计
#define BAIDUSTATAPPKEY @"5b42736457"
#endif /* Config_h */
