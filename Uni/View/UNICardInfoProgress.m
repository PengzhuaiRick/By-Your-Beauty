//
//  UNICardInfoProgress.m
//  Uni
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNICardInfoProgress.h"
#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
@implementation UNICardInfoProgress
-(id)initWithFrame:(CGRect)frame andData:(NSArray*)data{
    self = [super initWithFrame:frame];
    if (self) {
        _num = [data[0] intValue];
        _total = [data[1] intValue];
        [self setupGradientLayer:frame];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetRGBStrokeColor(context, 69/255.f, 50/255.f, 88/255.f, 1);//设置画笔颜色
//    CGContextSetLineWidth(context, 8);//设置线宽
//    CGContextAddArc(context, rect.size.width/2, rect.size.height/2,  rect.size.width/2-8, M_PI/2, 2*M_PI + M_PI/2, 0);//画圆
//    CGContextSetLineCap(context, kCGLineCapRound); //线的两头为圆角
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    
//    CGContextSetRGBStrokeColor(context,238.f/255, 76.f/255, 125.f/255, 1);//设置画笔颜色
//    CGContextSetLineWidth(context, 8);//设置线宽
//    CGContextAddArc(context, rect.size.width/2, rect.size.height/2,  rect.size.width/2-8, M_PI/2,  M_PI/2+ (2*M_PI * _num / _total) , 0);//画圆
//    CGContextSetLineCap(context, kCGLineCapRound); //线的两头为圆角
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
//    
//    //指定直线样式
//    CGContextSetLineCap(context, kCGLineCapSquare);
//    //直线宽度
//    CGContextSetLineWidth(context,0.5);
//    //设置颜色
//    CGContextSetRGBStrokeColor(context,0.3, 0.3, 0.3, 1.0);
//    //开始绘制
//    CGContextBeginPath(context);
    
    float lw = self.frame.size.width/2;
    
    UIFont* font =kWTFont(18.6);
    NSString* str = @"/";
    CGSize Size = [str boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    float x1 = lw - Size.width/2;
    float y1 = lw - Size.height/2;
    [str drawInRect:CGRectMake(x1, y1, Size.width,Size.height) withAttributes:@{NSFontAttributeName:font ,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"453258"]}];
    
    
    NSString* str1 =[NSString stringWithFormat:@"%d",_num];
    CGSize titleSize = [str1 boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    float x =x1 - titleSize.width;
    [str1 drawInRect:CGRectMake(x, y1, titleSize.width, titleSize.height) withAttributes:@{NSFontAttributeName:font ,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"ff63d2"]}];
    
    
    NSString* str2 =[NSString stringWithFormat:@"%d",_total];
    CGSize titleSize2 = [str2 boundingRectWithSize:CGSizeMake(rect.size.width, rect.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
    float tx =lw+Size.width/2;
    [str2 drawInRect:CGRectMake(tx, y1, titleSize2.width, titleSize2.height) withAttributes:@{NSFontAttributeName:font ,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    

}

#pragma mark 渐变图层
-(void)setupGradientLayer:(CGRect)rect{
    
     float lw = rect.size.width/2;
    
    CAShapeLayer* _trackLayer = [CAShapeLayer layer];//创建一个track shape layer
    _trackLayer.frame = self.bounds;
    [self.layer addSublayer:_trackLayer];
    _trackLayer.fillColor = [[UIColor clearColor] CGColor];
    _trackLayer.strokeColor = [[UIColor colorWithHexString:@"453258"] CGColor];//指定path的渲染颜色
    _trackLayer.opacity = 0.25; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
    _trackLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
    _trackLayer.lineWidth = 8;//线的宽度
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(lw, lw) radius:lw-8 startAngle:degreesToRadians(90) endAngle:degreesToRadians(360+90) clockwise:YES];//上面说明过了用来构建圆形
    _trackLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
    
    
    CAShapeLayer* progressLayer = [CAShapeLayer layer];
    progressLayer.frame = self.bounds;
    progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    progressLayer.strokeColor  = [[UIColor whiteColor] CGColor];
    progressLayer.lineCap = kCALineCapRound;
    progressLayer.lineJoin = kCALineJoinRound;
    progressLayer.lineWidth = 8;
    progressLayer.path = [path CGPath];
   // progressLayer.strokeEnd = 0;
    _progressLayer = progressLayer;
    
    CALayer *gradientLayer = [CALayer layer];
    CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, rect.size.width/2, rect.size.height);
    [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithHexString:@"975ca6"] CGColor],
                                                        (id)[[UIColor colorWithHexString:@"fe63d2"] CGColor],
                                                        nil]];
   // [gradientLayer1 setLocations:@[@0.5]];
    [gradientLayer1 setStartPoint:CGPointMake(0.25, 0.75)];
    [gradientLayer1 setEndPoint:CGPointMake(0.5, 0)];
    [gradientLayer insertSublayer:gradientLayer1 atIndex:0];
    
    CAGradientLayer *gradientLayer2 =  [CAGradientLayer layer];
   // [gradientLayer2 setLocations:@[@0.5]];
    gradientLayer2.frame = CGRectMake(rect.size.width/2, 0, rect.size.width/2, rect.size.height);
    [gradientLayer2 setColors:[NSArray arrayWithObjects:(id)[[UIColor purpleColor] CGColor],(id)[[UIColor blueColor] CGColor], nil]];
    [gradientLayer2 setStartPoint:CGPointMake(0.5, 0)];
    [gradientLayer2 setEndPoint:CGPointMake(0.5, 1)];
    [gradientLayer insertSublayer:gradientLayer2 atIndex:0];
    

    [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
}

-(void)setProgrssLayerEndStroke:(float)num and:(float)total{
    _num = num;
    _total = total;
    
    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [CATransaction setAnimationDuration:1];
    _progressLayer.strokeEnd =num/total;
    [CATransaction commit];
    
    
    [self setNeedsDisplay];
    
    
}
@end
