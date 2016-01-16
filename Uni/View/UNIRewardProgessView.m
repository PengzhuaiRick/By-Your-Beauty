//
//  UNIRewardProgessView.m
//  Uni
//
//  Created by apple on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIRewardProgessView.h"

@implementation UNIRewardProgessView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 1);//设置画笔颜色
    CGContextSetLineWidth(context, 2);//设置线宽
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2,  rect.size.width/2-2, M_PI/2, 2*M_PI + M_PI/2, 0);//画圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);//设置画笔颜色
    CGContextSetLineWidth(context, 2);//设置线宽
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2,  rect.size.width/2-2, M_PI/2, M_PI/2+ M_PI, 0);//画圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    UIFont* fontl =[UIFont systemFontOfSize:rect.size.height/2.5];
    CGSize titleSize1 = [@"/" boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontl} context:nil].size;
    float lx = (rect.size.width - titleSize1.width)/2;
    float ly = (rect.size.height - titleSize1.height)/2;
    [@"/" drawInRect:CGRectMake(lx, ly, titleSize1.width, titleSize1.height) withAttributes:@{NSFontAttributeName:fontl ,NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
    UIFont* font =[UIFont systemFontOfSize:rect.size.height/3];
    CGSize titleSize = [@"5" boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    float x =rect.size.width/2 - titleSize.width - titleSize1.width/2;
    float y =(rect.size.height - titleSize.height)/2 -5;
    [@"5" drawInRect:CGRectMake(x, y, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:font ,NSForegroundColorAttributeName:[UIColor colorWithHexString:kMainThemeColor]}];
    
    
    
    
    UIFont* fontt =[UIFont systemFontOfSize: rect.size.height/5];
    CGSize titleSize2 = [@"10" boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontt} context:nil].size;
    float tx = rect.size.width/2+titleSize1.width/2;
    float ty =(rect.size.height)/2;
    [@"10" drawInRect:CGRectMake(tx, ty, titleSize2.width, titleSize2.height) withAttributes:@{NSFontAttributeName:fontt ,NSForegroundColorAttributeName:[UIColor blackColor]}];
}


@end
