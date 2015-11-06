//
//  YIUserLocationMessage.m
//  YIVasMobile
//
//  Created by apple on 15/4/2.
//  Copyright (c) 2015年 YixunInfo Inc. All rights reserved.
//

#import "YIUserLocationMessage.h"

@implementation YIUserLocationMessage
+(id)share{
    static dispatch_once_t  onceToken;
    static YIUserLocationMessage *sSharedInstance;
    dispatch_once(&onceToken, ^{
        sSharedInstance = [[YIUserLocationMessage alloc] init];
    });
    return sSharedInstance;
}
@end
