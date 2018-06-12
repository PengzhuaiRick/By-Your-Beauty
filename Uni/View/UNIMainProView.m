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
    
    UIImageView* backImge = [[UIImageView alloc]initWithFrame:CGRectMake(-7, -7, self.frame.size.width+14, self.frame.size.height+14)];
    backImge.image = [UIImage imageNamed:@"main_img_menu"];
    [self addSubview:backImge];
    _mainImg = backImge;
    
//    CAShapeLayer* shape = [CAShapeLayer layer];
//    shape.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    shape.fillColor = [UIColor clearColor].CGColor;
//    shape.backgroundColor = [UIColor clearColor].CGColor;
//    shape.lineWidth = 1;
//    shape.shadowRadius = 5;
//    shape.shadowColor = [UIColor whiteColor].CGColor;
//    shape.shadowOffset = CGSizeMake(0,0);
//    shape.shadowOpacity = 0.9;
//    //shape.transform = CATransform3DMakeRotation(M_PI*2 , 0, 0, 1);//90+30度
//    [self.layer addSublayer:shape];
//    _shapeLayer = shape;
    
    CAShapeLayer* progess = [CAShapeLayer layer];
    progess.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    progess.fillColor = [UIColor clearColor].CGColor;
    progess.backgroundColor = [UIColor clearColor].CGColor;
    progess.lineWidth = 1;
   // progess.transform = CATransform3DMakeRotation(M_PI*2, 0, 0, 1); //90+30度
    [self.layer addSublayer:progess];
    _progessLayer = progess;
    
}
-(void)drawRect:(CGRect)rect{
    CGFloat radius = self.frame.size.width/2;
    CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
//    UIBezierPath *bezier = [UIBezierPath bezierPath];
//    [bezier addArcWithCenter:center radius:radius-1 startAngle:M_PI/2 endAngle:M_PI*2+M_PI/2 clockwise:YES];//0到300度
//    
//    _shapeLayer.path = bezier.CGPath;
    
    _mainImg.transform = CGAffineTransformMakeRotation(2*M_PI*(_num/_total));
    
    UIBezierPath *progessBezier = [UIBezierPath bezierPath];
    [progessBezier addArcWithCenter:center radius:radius-1 startAngle:M_PI/2 endAngle:(_num * (M_PI*2) /_total)+M_PI/2 clockwise:YES];
    _progessLayer.path = progessBezier.CGPath;
    
}

//-(void)setShapeColor:(UIColor *)shapeColor{
//    self.shapeLayer.strokeColor = shapeColor.CGColor;
//}

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
