//
//  UNILoginViewModel.h
//  Uni
//
//  Created by apple on 15/11/11.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "BaseViewModel.h"
#import "UNILoginViewRequest.h"
@interface UNILoginViewModel : BaseViewModel

-(void)requestVertificationCode:(NSString*)code andParams:(NSDictionary*)param;
@end
