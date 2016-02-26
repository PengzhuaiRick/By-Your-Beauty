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
        self.num = 0;
        self.total = 0;
    }
    return self;
}
-(void)setNum:(int)num{
    _num=num;
    [self setNeedsDisplay];
}

-(void)setTotal:(int)total{
    _total=total;
    [self setNeedsDisplay];
}

-(void)setNum:(int)num andTotal:(int)total{
    if (num<total) {
        _num=num;
        _total=total;
        [self setNeedsDisplay];
    }
    else{
        UILabel* LAB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        LAB.backgroundColor = [UIColor colorWithHexString:kMainThemeColor];
        LAB.textAlignment = NSTextAlignmentCenter;
        LAB.textColor = [UIColor whiteColor];
        LAB.layer.masksToBounds=YES;
        LAB.layer.cornerRadius = self.frame.size.height/2;
        LAB.font = [UIFont systemFontOfSize:(KMainScreenWidth>320?16:14) weight:0];
        LAB.text = @"可领取";
        [self addSubview:LAB];
    }
}
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 0.7, 0.7, 0.7, 1);//设置画笔颜色
    CGContextSetLineWidth(context, 2);//设置线宽
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2,  rect.size.width/2-2, M_PI/2, 2*M_PI + M_PI/2, 0);//画圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    
    CGContextSetRGBStrokeColor(context,238.f/255, 76.f/255, 125.f/255, 1);//设置画笔颜色
    CGContextSetLineWidth(context, 2);//设置线宽
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2,  rect.size.width/2-2, M_PI/2,  M_PI/2+ (2*M_PI * _num / _total) , 0);//画圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    UIFont* fontl =[UIFont systemFontOfSize:KMainScreenWidth>320?34:28 weight:0];
    CGSize titleSize1 = [@"/" boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontl} context:nil].size;
    float lx = (rect.size.width - titleSize1.width)/2+2;
    float ly = (rect.size.height - titleSize1.height)/2;
    [@"/" drawInRect:CGRectMake(lx, ly, titleSize1.width, titleSize1.height) withAttributes:@{NSFontAttributeName:fontl ,NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    
    UIFont* font =[UIFont systemFontOfSize:KMainScreenWidth>320?25:20];
    NSString* str1 =[NSString stringWithFormat:@"%d",_num];
    CGSize titleSize = [str1 boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    float x =lx - titleSize.width - 3;
    if (_num>9 && _num<99){
        x +=KMainScreenWidth>320?10:4;
        font =[UIFont systemFontOfSize:KMainScreenWidth>320?20:17];
    }
    if (_num>99)
        x -=8;
    
    float y =(rect.size.height - titleSize.height)/2;
    [str1 drawInRect:CGRectMake(x, y, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:font ,NSForegroundColorAttributeName:[UIColor colorWithHexString:kMainThemeColor]}];
    
    
    UIFont* fontt =[UIFont systemFontOfSize:KMainScreenWidth>320?20:16];
    NSString* str2 =[NSString stringWithFormat:@"%d",_total];
    CGSize titleSize2 = [str2 boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontt} context:nil].size;
    float tx =lx + titleSize1.width+2;
    if (_total>9 && _total<99){
        tx-=4;
        fontt =[UIFont systemFontOfSize:KMainScreenWidth>320?16:14];
    }
    float ty =(rect.size.height - titleSize2.height)/2+6;
    if (KMainScreenWidth>320) {
       ty =(rect.size.height - titleSize2.height)/2+4;
    }
    [str2 drawInRect:CGRectMake(tx, ty, titleSize2.width, titleSize2.height) withAttributes:@{NSFontAttributeName:fontt ,NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}

@end
