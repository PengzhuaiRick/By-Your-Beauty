//
//  UNIOrderDetailCell2.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderDetailCell2.h"
#import "UNIOrderListModel.h"
@implementation UNIOrderDetailCell2

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    
    float lab1X = 16;
    float lab1W = KMainScreenWidth*60/320;
    float lab1H = size.height;
    float lab1Y = 0;
    
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab1Y, lab1W, lab1H)];
    lab1.text=@"合计:";
    lab1.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab1 .font =[UIFont systemFontOfSize:KMainScreenWidth*12/320];
    [self addSubview:lab1];
    self.lab1 = lab1;
   
    
    float lab2W = KMainScreenWidth*60/320;
    float lab2X = size.width - lab2W - lab1X;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab1Y, lab2W, lab1H)];
    lab2.text=@"￥899";
    lab2.textColor =[UIColor colorWithHexString:kMainThemeColor];
    lab2.textAlignment=NSTextAlignmentRight;
    lab2 .font =[UIFont systemFontOfSize:KMainScreenWidth*13/320];
    [self addSubview:lab2];
    self.lab2 = lab2;
    
  
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(lab1X, size.height-1, size.width-2*lab1X, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
    LAY=nil;lab2=nil; lab1=nil;
}
-(void)setupCellContent:(id)model;{
    UNIOrderListModel*info = model;
    self.lab2.text = [NSString stringWithFormat:@"￥%.2f",[info.price floatValue]*info.num];
    info=nil;
}


@end
