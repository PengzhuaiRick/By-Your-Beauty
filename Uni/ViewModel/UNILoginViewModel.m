//
//  UNILoginViewModel.m
//  Uni
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNILoginViewModel.h"

@implementation UNILoginViewModel
-(void)requestVertificationCode:(NSString*)code andParams:(NSDictionary*)param{
    UNILoginViewRequest* request = [[UNILoginViewRequest alloc]init];
    [request requestVertificationCode:code andParams:param];
}
@end
