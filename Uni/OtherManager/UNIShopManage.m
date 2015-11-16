//
//  UNIShopManage.m
//  Uni
//
//  保存店铺信息
//
#define ShopManage @"UNIShopManage"
#import "UNIShopManage.h"

@implementation UNIShopManage



+(void)saveShopData:(UNIShopManage*)shop{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setValue:shop.shopName forKey:@"shopName"];
     [user setValue:shop.logoUrl forKey:@"logoUrl"];
     [user setValue:shop.address forKey:@"address"];
     [user setValue:shop.telphone forKey:@"telphone"];
     [user setValue:shop.x forKey:@"latitude"];
     [user setValue:shop.y forKey:@"longitude"];
    [user synchronize];
}

+(UNIShopManage*)getShopData{
    UNIShopManage* man = [[UNIShopManage alloc]init];
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    man.shopName= [user valueForKey:@"shopName"];
    man.logoUrl= [user valueForKey:@"logoUrl"];
    man.address= [user valueForKey:@"address"];
    man.telphone= [user valueForKey:@"telphone"];
    man.x= [user valueForKey:@"latitude"];
    man.y= [user valueForKey:@"longitude"];
    
    return man;
}

+(NSString *)filePath{
    
    //  NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/texts"]; //两种方法都可以
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"ShopInfo"];
    
    return path;
}

@end
