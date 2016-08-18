//
//  UNIMainProView.h
//  Uni
//
//  Created by apple on 16/1/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIMainProView : UIView
@property(nonatomic,strong)UIImageView* mainImg;
//@property(nonatomic,strong)CAShapeLayer* shapeLayer;
@property(nonatomic,strong)CAShapeLayer* progessLayer;
@property(nonatomic,assign)float radius; //半径
@property(nonatomic,strong) UIColor* shapeColor;
@property(nonatomic,strong) UIColor* progessColor;
@property(nonatomic)float total;
@property(nonatomic)float num;

-(void)setupProgreaa:(float)num and:(float)Total;
@end
