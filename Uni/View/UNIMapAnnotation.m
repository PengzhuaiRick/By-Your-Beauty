//
//  UNIMapAnnotation.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIMapAnnotation.h"

@implementation UNIMapAnnotation
-(id)initWithTitle:(NSString *)title andCoordinate:
(CLLocationCoordinate2D)coordinate2d{
    self.tiTle = title;
    self.coordinate =coordinate2d;
    return self;
}
@end
