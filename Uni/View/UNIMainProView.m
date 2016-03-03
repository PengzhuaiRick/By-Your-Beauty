//
//  UNIMainProView.m
//  Uni
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIMainProView.h"

@implementation UNIMainProView

-(id)initWithFrame:(CGRect)frame{
    self =[super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    // _radius = self.frame.size.width /2;
    
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    shape.fillColor = [UIColor clearColor].CGColor;
    shape.backgroundColor = [UIColor clearColor].CGColor;
    shape.lineWidth = 8;
    shape.transform = CATransform3DMakeRotation(M_PI/2 +M_PI/6 , 0, 0, 1);//90+30度
    [self.layer addSublayer:shape];
    _shapeLayer = shape;
    
    CAShapeLayer* progess = [CAShapeLayer layer];
    progess.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    progess.fillColor = [UIColor clearColor].CGColor;
    progess.backgroundColor = [UIColor clearColor].CGColor;
    progess.lineWidth = 8;
    progess.transform = CATransform3DMakeRotation(M_PI/2 +M_PI/6, 0, 0, 1); //90+30度
    [self.layer addSublayer:progess];
    _progessLayer = progess;
    
    
}
-(void)drawRect:(CGRect)rect{
    CGFloat radius = self.frame.size.width/2;
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    [bezier addArcWithCenter:center radius:radius-8 startAngle:0 endAngle:M_PI*5/3 clockwise:YES];//0到300度
    
    _shapeLayer.path = bezier.CGPath;
    
    UIBezierPath *progessBezier = [UIBezierPath bezierPath];
    [progessBezier addArcWithCenter:center radius:radius-8 startAngle:0 endAngle:(_num * (M_PI*5/3) /_total) clockwise:YES];
    _progessLayer.path = progessBezier.CGPath;
    
}

-(void)setShapeColor:(UIColor *)shapeColor{
    self.shapeLayer.strokeColor = shapeColor.CGColor;
}

-(void)setProgessColor:(UIColor *)progessColor{
    self.progessLayer.strokeColor = progessColor.CGColor;
}


-(void)setNum:(float)num{
    _num = num;
    [self setNeedsDisplay];
}

-(void)setTotal:(float)total{
    _total = total;
    [self setNeedsDisplay];
}

-(void)setupProgreaa:(float)num and:(float)Total{
    if (num>Total) 
        num = Total;
    
    _num = num;
    _total = Total;
    
    [self setNeedsDisplay];
}

@end
