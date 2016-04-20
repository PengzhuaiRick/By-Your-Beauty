//
//  UNIUrlManager.m
//  Uni
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIUrlManager.h"

@implementation UNIUrlManager
+ (UNIUrlManager *)sharedInstance{
    static dispatch_once_t  onceToken;
    static UNIUrlManager *sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[UNIUrlManager alloc] init];
        
    });
    return sSharedInstance;
}
-(void)initUrlManager:(NSDictionary*)dic{
    _server_url = [self safeObject:dic ForKey:@"server_url"];
    _url = [self safeObject:dic ForKey:@"url"];
     _img_url = [self safeObject:dic ForKey:@"img_url"];
    _version =[[self safeObject:dic ForKey:@"version"] floatValue];
    _update_type =[[self safeObject:dic ForKey:@"update_type"] intValue];
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
