//
//  UNILoginShopList.h
//  Uni
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNILoginShopList : UIViewController
@property(nonatomic , assign)int extra;
@property(nonatomic , copy) NSString* phone;
@property(nonatomic , copy) NSString* randcode;
@property(nonatomic , strong) NSMutableArray* myData;
@end
