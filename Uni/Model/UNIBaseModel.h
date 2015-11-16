//
//  UNIBaseModel.h
//  Uni
//
//  Created by apple on 15/11/16.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNIBaseModel : NSObject
- (id)safeObject:(NSDictionary*)dic ForKey:(id)aKey;
@end
