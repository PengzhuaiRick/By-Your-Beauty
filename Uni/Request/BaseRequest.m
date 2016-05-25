//
//  BaseRequest.m
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "AccountManager.h"
//#import "UNIUrlManager.h"
@implementation BaseRequest

-(void)firstRequestUrl{
    NSString* url = [NSString stringWithFormat:
                     @"http://uni.dodwow.com/v2/index.php?s=/App/Version/index/app_version/%@/device/ios",CURRENTVERSION];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer.acceptableContentTypes =
    [NSSet setWithArray:@[@"text/html",@"application/json",@"text/json", @"text/javascript"]];
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"firstRequestUrl : %@",responseObject);
        int code = [[self safeObject:(NSDictionary*)responseObject ForKey:@"code"] intValue];
        
        UNIUrlManager* manager = [UNIUrlManager sharedInstance];
        [manager initUrlManager:responseObject];
        NSString *curVersion = CURRENTVERSION;      //获取项目版本号
        float curVersinNum = curVersion.floatValue;
        if (manager.version>curVersinNum) {
            
            NSString* cancelTitle =@"取消";
            if (manager.update_type == 2)
                cancelTitle=nil;
            
            [UIAlertView showWithTitle:@"更新提示" message:manager.detail style:UIAlertViewStyleDefault cancelButtonTitle:cancelTitle otherButtonTitles:@[@"更新"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                int index = 0;
                if (cancelTitle)
                    index = 1;
                
                if (buttonIndex==index){
                    if (manager.update_type == 2)
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"setupLoginController" object:nil];
                    
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:manager.url]];
                }
            }];
        }
        self.rqfirstUrl(code);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       }];
}


-(void)postWithSerCode:(NSArray*)code params:(NSDictionary *)params{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:params];
    [dic setValue:[AccountManager token] forKey:@"token"];
    
   if([[params objectForKey:@"shopId"] intValue]<1)
       [dic setValue:@([[AccountManager shopId]intValue]) forKey:@"shopId"];
    
    NSString* URL = [self spliceURL:code];
    NSLog(@"URL :  %@    ,   params : %@",URL , dic);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"application/json",@"text/json", @"text/javascript"]];
    [manager POST:URL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"code  %@   content  %@ ",code[0],responseObject);
        int resultcode = [[self safeObject:dic ForKey:@"code"] intValue];
        if (resultcode == -1) {
            [manager.operationQueue cancelAllOperations];
            [UIAlertView showWithTitle:@"提示" message:@"您授权码已过期！请重新登录" cancelButtonTitle:@"知道" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"setupLoginController" object:nil];
            }];
            return ;
        }

        if ([self respondsToSelector:@selector(requestSucceed:andIdenCode:)]) {
            [self requestSucceed:responseObject andIdenCode:code];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if ([self respondsToSelector:@selector(requestFailed:andIdenCode:)]) {
            [self requestFailed:error andIdenCode:code];
        }
    }];
}

-(void)postWithoutUserIdSerCode:(NSArray*)code params:(NSDictionary *)params{
    NSString* URL = [self spliceURL:code];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.f;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html",@"application/json",@"text/json", @"text/javascript",@"text/plain"]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary *content = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"code  %@   content  %@ ",code[0],content);
        if ([self respondsToSelector:@selector(requestSucceed:andIdenCode:)]) {
            [self requestSucceed:content andIdenCode:code];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@ %@",code[0], error);
        if ([self respondsToSelector:@selector(requestFailed:andIdenCode:)]) {
            [self requestFailed:error andIdenCode:code];
        }
    }];
}

-(NSString*)dictionaryToString:(NSDictionary*)dic{
    NSArray* keys = [dic allKeys];
    NSMutableString* url = [NSMutableString string];
    for (int i=0;i<keys.count;i++) {
        NSString* key = keys[i];
        [url appendString:key];
        if (i<keys.count-1)
            [url appendFormat:@"/%@/",dic[key]];
        else
            [url appendFormat:@"/%@",dic[key]];
    }
    return url;
}

-(NSString*)spliceURL:(NSArray*)code{
    //NSString* str = [NSString stringWithFormat:@"%@/api.php?c=%@&a=%@",API_URL,code[0],code[1]];
    NSString* str = [NSString stringWithFormat:@"%@/index.php?s=/App/%@/app_version/%@/device/ios",[UNIUrlManager sharedInstance].server_url,code[0],CURRENTVERSION];
    return str;
}

-(void)cancelAllOperation{
    [[NSOperationQueue mainQueue]cancelAllOperations];
}


+ (NSString *)md5Encrypt:(NSString *)str
{
    const char *original_str = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (int)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02x", result[i]];
    return hash;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //return jsonData;
}

-(void)requestFailed:(NSError *)err andIdenCode:(NSArray *)array{
    
}
-(void)requestSucceed:(NSDictionary *)dic andIdenCode:(NSArray *)array{
    
}
-(void)requestFirstUrlSucceed:(int)code{
    
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
