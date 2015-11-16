//
//  UNIBaseModel.m
//  Uni
//
//  Created by apple on 15/11/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIBaseModel.h"

@implementation UNIBaseModel


- (id)safeObject:(NSDictionary*)dic ForKey:(id)aKey{
    id obj = [dic objectForKey:aKey];
    if ([obj isEqual:[NSNull null]]) {
        obj = nil;
    }
    return obj;
}
@end
