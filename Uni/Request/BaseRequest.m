//
//  BaseRequest.m
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseRequest.h"

@implementation BaseRequest
-(void)postWithSerCode:(NSString*)code params:(NSDictionary *)params{
   
    NSString* URL = [self spliceURL:code];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html"]];
    NSDictionary* ddic = [NSDictionary dictionaryWithObject:[self dictionaryToJson:params] forKey:@"json"];
    NSLog(@"%@",ddic);
    [manager POST:URL parameters:ddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSLog(@"%@",[responseObject objectForKey:@"tips"]);
        if ([self respondsToSelector:@selector(requestSucceed:)]) {
            [self requestSucceed:responseObject];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if ([self respondsToSelector:@selector(requestFailed:)]) {
            [self requestFailed:error];
        }
    }];
    
}

-(void)getWithSerCode:(NSString*)code params:(NSDictionary *)params{
    
}

-(NSString*)spliceURL:(NSString*)code{
    NSString* str = [NSString stringWithFormat:@"%@%@",API_URL,code];
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


- (id)safeObject:(NSDictionary*)dic ForKey:(id)aKey
{
    id obj = [dic objectForKey:aKey];
    if ([obj isEqual:[NSNull null]]) {
        obj = nil;
    }
    return obj;
}
@end
