//
//  UNITransfromX&Y.h
//  Uni
//
//  Created by apple on 16/3/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNITransfromX_Y : NSObject
@property(nonatomic,strong)UIView* showView;

@property(nonatomic,assign)CLLocationCoordinate2D endCoor;
@property(nonatomic,copy)NSString *aimName;

-(id)initWithView:(UIView*)view withEndCoor:(CLLocationCoordinate2D)endCo withAim:(NSString*)name;
-(void)setupUI;
#pragma mark 百度坐标 转 火星坐标
+(NSArray*)bd_decrypt:(double)bd_lat and:(double)bd_lon;

#pragma mark 火星坐标 转 百度坐标
+(NSArray*)bd_encrypt:(double)gg_lat and:(double)gg_lon;
@end
