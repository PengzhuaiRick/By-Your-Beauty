//
//  UNILoginViewRequest.m
//  Uni
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNILoginViewRequest.h"

@implementation UNILoginViewRequest

-(void)requestVertificationCode:(NSString *)code andParams:(NSDictionary *)params{
    [self postWithSerCode:code params:params];
}
-(void)requestSucceed:(NSDictionary*)dic{
    NSLog(@"requestSucceed  %@",dic);
  
}

-(void)requestFailed:(NSError *)err{
    NSLog(@"requestFailed  %@",err);
}
@end
