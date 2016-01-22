//
//  UNIOrderDetailCell3.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderDetailCell3.h"
#import "UNIOrderListModel.h"
@implementation UNIOrderDetailCell3

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    
    float lab1X = 10;
    float lab1W = size.width - 2*lab1X;
    float lab1H = size.height/2;
    float lab1Y = 0;
    
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab1Y, lab1W, lab1H)];
    lab1.textColor = kMainGrayBackColor;
    lab1 .font =[UIFont systemFontOfSize:KMainScreenWidth*13/320];
    [self addSubview:lab1];
    self.lab1 = lab1;
    
  
    float lab2Y = size.height/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab2Y, lab1W, lab1H)];
    lab2.textColor =kMainGrayBackColor;
    lab2 .font =[UIFont systemFontOfSize:KMainScreenWidth*13/320];
    [self addSubview:lab2];
    self.lab2 = lab2;
    
}
-(void)setupCellContent:(id)model;{
    UNIOrderListModel*info = model;
    self.lab1.text = [NSString stringWithFormat:@"订单编号: %@",info.orderCode];
    self.lab2.text = [NSString stringWithFormat:@"下单时间: %@",info.time];
}


@end
