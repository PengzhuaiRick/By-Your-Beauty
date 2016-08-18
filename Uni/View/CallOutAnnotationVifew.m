//
//  CallOutAnnotationVifew.m
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import "CallOutAnnotationVifew.h"
#import <QuartzCore/QuartzCore.h>
#import "UNIMapAddressView.h"
#import "UNIShopManage.h"
#define  Arror_height 0

@interface CallOutAnnotationVifew ()

-(void)drawInContext:(CGContextRef)context;
- (void)getDrawPath:(CGContextRef)context;
@end

@implementation CallOutAnnotationVifew

- (void)dealloc
{
    
}

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.superview.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.canShowCallout = NO;
        //self.image =[UIImage imageNamed:@"appoint_img_pin"];
        //self.centerOffset = CGPointMake(0, -30);
        
        UNIMapAddressView *_contentView = [[UNIMapAddressView alloc] init];
        _contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _contentView.layer.masksToBounds=YES;
        _contentView.layer.cornerRadius = 3;
        [self addSubview:_contentView];
        
        UILabel* lab = [[UILabel alloc]init];
        lab.text = [[UNIShopManage getShopData] address];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor whiteColor];
        [lab sizeToFit];
        lab.frame = CGRectMake(10, 0, lab.frame.size.width, 50);
        [_contentView addSubview:lab];
        
        UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
        [but setBackgroundImage:[UIImage imageNamed:@"appoint_btn_nav"] forState:UIControlStateNormal];
        float btnX = CGRectGetMaxX(lab.frame)+5;
        but.frame = CGRectMake(btnX, 0,46,
                              CGRectGetMaxY(lab.frame));
//        [[but rac_signalForControlEvents:UIControlEventTouchUpInside]
//         subscribeNext:^(id x) {
//             NSLog(@"导航");
//            // [self callOtherMapApp];
//         }];
        [_contentView addSubview:but];
        _navBtn = but;
        
        float contentW = CGRectGetMaxX(but.frame);
        _contentView.frame = CGRectMake(0, 0, contentW, CGRectGetMaxY(lab.frame));
        
        UIImageView* jian = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appoint_img_jian"]];
        jian.frame = CGRectMake(contentW/4, CGRectGetMaxY(_contentView.frame), contentW/2, 10);
        [self addSubview:jian];
        
        UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appoint_img_dian"]];
        float imgWH = 25;
        float imgX =  (contentW - imgWH)/2;
        float imgY = CGRectGetMaxY(_contentView.frame)+8;
        img.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
        img.contentMode = UIViewContentModeScaleAspectFit;
        img.backgroundColor = [UIColor clearColor];
        [self addSubview:img];
        
        CGRect selfR =self.frame;
        selfR.size = CGSizeMake(contentW, CGRectGetMaxY(_contentView.frame));
        self.frame =selfR;
        
         //self.centerOffset = CGPointMake(-contentW/2, -30);
        
    }
    return self;
}

-(void)drawInContext:(CGContextRef)context
{
	
   CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
   
    [self getDrawPath:context];
    CGContextFillPath(context);
    
//    CGContextSetLineWidth(context, 1.0);
//     CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
//    [self getDrawPath:context];
//    CGContextStrokePath(context);
    
}
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
	CGFloat radius = 6.0;
    
	CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect), 
    maxx = CGRectGetMaxX(rrect);
	CGFloat miny = CGRectGetMinY(rrect), 
    // midy = CGRectGetMidY(rrect), 
    maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

- (void)drawRect:(CGRect)rect
{
//	[self drawInContext:UIGraphicsGetCurrentContext()];
//    
//    self.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.layer.shadowOpacity = 1.0;
//  //  self.layer.shadowOffset = CGSizeMake(-5.0f, 5.0f);
//    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}
@end
