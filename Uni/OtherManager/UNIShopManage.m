//
//  UNIShopManage.m
//  Uni
//
//  保存店铺信息
//
#define ShopManage @"UNIShopManage"
#import "UNIShopManage.h"

@implementation UNIShopManage

-(id)initWithDictionary:(NSDictionary*)dic{
    self = [super init];
    if (self) {
        self.shopName = [self safeObject:dic ForKey:@"shopName"];
        self.logoUrl = [self safeObject:dic ForKey:@"logoUrl"];
        self.address = [self safeObject:dic ForKey:@"address"];
        self.telphone = [self safeObject:dic ForKey:@"telphone"];
        self.shortName =[self safeObject:dic ForKey:@"shortName"];
        self.x =[self safeObject:dic ForKey:@"latitude"];
        self.y = [self safeObject:dic ForKey:@"longitude"];

        
    }
    return self;
}

+(void)saveShopData:(UNIShopManage*)shop{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user setValue:shop.shopName forKey:@"shopName"];
    [user setValue:shop.shortName forKey:@"shortName"];
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
     man.shortName= [user valueForKey:@"shortName"];
    man.logoUrl= [user valueForKey:@"logoUrl"];
    man.address= [user valueForKey:@"address"];
    man.telphone= [user valueForKey:@"telphone"];
    man.x= [user valueForKey:@"latitude"];
    man.y= [user valueForKey:@"longitude"];
    return man;
}
#pragma mark 百度坐标 转 火星坐标
+(NSArray*)bd_decrypt:(double)bd_lat and:(double)bd_lon{
    double x_pi = M_PI * 3000.0 / 180.0;
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    //    gg_lon = z * cos(theta);
    //    gg_lat = z * sin(theta);
    return @[@(z * sin(theta)),@(z * cos(theta))];
}
+(NSString *)filePath{
    
    //  NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/texts"]; //两种方法都可以
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:@"ShopInfo"];
    
    return path;
}

+(void)cleanShopinfo{
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    [user removeObjectForKey:@"shopName"];
    [user removeObjectForKey:@"shortName"];
    [user removeObjectForKey:@"logoUrl"];
    [user removeObjectForKey:@"address"];
    [user removeObjectForKey:@"telphone"];
    [user removeObjectForKey:@"latitude"];
    [user removeObjectForKey:@"longitude"];
    [user synchronize];
    
}

- (id)safeObject:(NSDictionary*)dic ForKey:(id)aKey
{
    id obj = [dic objectForKey:aKey];
    if ([obj isEqual:[NSNull null]]) {
        obj = nil;
    }
    return obj;
}
@end
