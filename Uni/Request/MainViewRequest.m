//
//  MainViewRequest.m
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewRequest.h"

@implementation MainViewRequest

-(void)requestCheckVersion:(NSString*)code andParams:(NSDictionary *)params{
    [self postWithSerCode:code params:params];
}

-(void)requestSucceed:(NSDictionary*)dic{
    NSLog(@"requestSucceed  %@",dic);
    _reqheckVersion(1.02,@"hahah");
}

-(void)requestFailed:(NSError *)err{
    NSLog(@"requestFailed  %@",err);
}
@end
