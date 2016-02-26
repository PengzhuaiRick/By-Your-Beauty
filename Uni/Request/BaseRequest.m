//
//  BaseRequest.m
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"
#import "AccountManager.h"
@implementation BaseRequest
-(void)postWithSerCode:(NSArray*)code params:(NSDictionary *)params{
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:params];
//    [dic setValue:@(1) forKey:@"userId"];
//    [dic setValue:@"abcdxxa" forKey:@"token"];
//    [dic setValue:@(1) forKey:@"shopId"];
    
    [dic setValue:@([[AccountManager userId] intValue]) forKey:@"userId"];
    [dic setValue:[AccountManager token] forKey:@"token"];
    [dic setValue:@([[AccountManager shopId]intValue]) forKey:@"shopId"];
    
    NSString* URL = [self spliceURL:code];
    NSLog(@" 吃吃吃吃   URL %@",URL);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html"]];
    NSDictionary* ddic = [NSDictionary dictionaryWithObject:[self dictionaryToJson:dic] forKey:@"json"];
    NSLog(@"%@",ddic);
    [manager POST:URL parameters:ddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON:%@ %@", code[1],responseObject);
       // NSLog(@"%@",[self safeObject:responseObject ForKey:@"tips"]);
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
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html"]];
    NSDictionary* ddic = [NSDictionary dictionaryWithObject:[self dictionaryToJson:params] forKey:@"json"];
    NSLog(@"%@",ddic);
    [manager POST:URL parameters:ddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        // NSLog(@"%@",[self safeObject:responseObject ForKey:@"tips"]);
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

-(void)getWithSerCode:(NSArray*)code params:(NSDictionary *)params{
    
}

-(NSString*)spliceURL:(NSArray*)code{
    NSString* str = [NSString stringWithFormat:@"%@/api.php?c=%@&a=%@",API_URL,code[0],code[1]];
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

- (id)safeObject:(NSDictionary*)dic ForKey:(id)aKey
{
    id obj = [dic objectForKey:aKey];
    if ([obj isEqual:[NSNull null]]) {
        obj = nil;
    }
    return obj;
}
@end
