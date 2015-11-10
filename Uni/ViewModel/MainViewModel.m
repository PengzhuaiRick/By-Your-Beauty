//
//  MainViewModel.m
//  Uni
//
//  Created by apple on 15/11/5.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewModel.h"

@implementation MainViewModel

-(void)requestViewModelCheckVersion:(NSString*)code andParams:(NSDictionary *)params{
    MainViewRequest* request = [[MainViewRequest alloc]init];
    [request requestCheckVersion:code andParams:params];
    request.reqheckVersion = ^(float version,NSString* url){
        NSLog(@"url  %@",url);
    };
}

@end
