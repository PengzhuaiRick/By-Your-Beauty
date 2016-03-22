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
        for (UIView* vi in self.subviews) {
            if ([vi isKindOfClass:[UILabel class]]) {
                [vi removeFromSuperview];
            }
        }
        [self setNeedsDisplay];
    }
    else{
//        UILabel* LAB = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        LAB.backgroundColor = [UIColor colorWithHexString:kMainThemeColor];
//        LAB.textAlignment = NSTextAlignmentCenter;
//        LAB.textColor = [UIColor whiteColor];
//        LAB.layer.masksToBounds=YES;
//        LAB.layer.cornerRadius = self.frame.size.height/2;
//        LAB.font = [UIFont systemFontOfSize:(KMainScreenWidth>400?16:14) weight:0];
//        LAB.text = @"可领取";
//        [self addSubview:LAB];
//        LAB = nil;
        
        UIColor* theme =[UIColor colorWithHexString:kMainThemeColor];
        UIColor* white =[UIColor whiteColor];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [btn setTitle:@"可领取" forState:UIControlStateNormal];
        btn.titleLabel.font= [UIFont systemFontOfSize:(KMainScreenWidth>400?16:14) weight:0];
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius = self.frame.size.height/2;
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor =theme.CGColor;
        [btn setBackgroundImage:[self createImageWithColor:theme] forState:UIControlStateNormal];
        [btn setBackgroundImage:[self createImageWithColor:white] forState:UIControlStateHighlighted];
        [btn setTitleColor:white forState:UIControlStateNormal];
        [btn setTitleColor:theme forState:UIControlStateHighlighted];
         [self addSubview:btn];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            [UIAlertView showWithTitle:@"请联系店员领取奖励！" message:@"" cancelButtonTitle:@"我知道了" otherButtonTitles:nil tapBlock:nil];
        }];
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
    
    //指定直线样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,0.5);
    //设置颜色
    CGContextSetRGBStrokeColor(context,0.3, 0.3, 0.3, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    
    float lh = self.frame.size.height/4*2;
    float ly =(self.frame.size.height-lh)/2;
    //画笔移动到点
    CGContextMoveToPoint(context,self.frame.size.width/2+4,ly);
    //下一点
    CGContextAddLineToPoint(context,self.frame.size.width/2-2, lh+ly);
    //绘制完成
    CGContextStrokePath(context);
    
//    UIFont* fontl =[UIFont systemFontOfSize:KMainScreenWidth>320?34:28 weight:0];
//    CGSize titleSize1 = [@"/" boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontl} context:nil].size;
//    float lx = (rect.size.width - titleSize1.width)/2+2;
//    float ly = (rect.size.height - titleSize1.height)/2;
//    [@"/" drawInRect:CGRectMake(lx, ly, titleSize1.width, titleSize1.height) withAttributes:@{NSFontAttributeName:fontl ,NSForegroundColorAttributeName:[UIColor blackColor]}];
    float lx = self.frame.size.width/2;
    
    UIFont* font =[UIFont systemFontOfSize:KMainScreenWidth>400?30:25];
    NSString* str1 =[NSString stringWithFormat:@"%d",_num];
    CGSize titleSize = [str1 boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    float x =lx - titleSize.width - (KMainScreenWidth>400?3:5);
    float y =(rect.size.height - titleSize.height)/2;
    if (_num>9 && _num<99){
        x +=KMainScreenWidth>400?10:9;
        y +=KMainScreenWidth>400?10:4;
        font =[UIFont systemFontOfSize:KMainScreenWidth>400?20:19];
    }
//    if (_num>99)
//        x -=8;
    
   
    [str1 drawInRect:CGRectMake(x, y, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:font ,NSForegroundColorAttributeName:[UIColor colorWithHexString:kMainThemeColor]}];
    
    
    UIFont* fontt =[UIFont systemFontOfSize:KMainScreenWidth>400?17:14];
    NSString* str2 =[NSString stringWithFormat:@"%d",_total];
    CGSize titleSize2 = [str2 boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:fontt} context:nil].size;
    float tx =lx+6;
    float ty =(rect.size.height - titleSize2.height)/2+4;
    if (_total>9 && _total<99){
        tx-=(KMainScreenWidth>400?1:3);
       // fontt =[UIFont systemFontOfSize:KMainScreenWidth>320?16:14];
    }
    if (KMainScreenWidth>400) {
       ty =(rect.size.height - titleSize2.height)/2+4;
    }
    [str2 drawInRect:CGRectMake(tx, ty, titleSize2.width, titleSize2.height) withAttributes:@{NSFontAttributeName:fontt ,NSForegroundColorAttributeName:[UIColor blackColor]}];
    
}
#pragma mark 颜色转图片
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
@end
