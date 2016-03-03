//
//  UNIAppointDetall1Cell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetall1Cell.h"

@implementation UNIAppointDetall1Cell
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    float labX = KMainScreenWidth*16/320;
    float labW = size.width - 2*labX;
    float labH = KMainScreenWidth*18/320;
    float labY = KMainScreenWidth*5/320;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab1.textColor = kMainGrayBackColor;
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:13];
    [self addSubview:lab1];
    self.label1 = lab1;
    
    float lab2Y = CGRectGetMaxY(lab1.frame);
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, labH)];
    lab2.textColor = kMainGrayBackColor;
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:13];
    [self addSubview:lab2];
    self.label2 = lab2;

    float lab3Y = CGRectGetMaxY(lab2.frame);
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab3Y, labW, labH)];
    lab3.textColor = kMainGrayBackColor;
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:13];
    [self addSubview:lab3];
    self.label3 = lab3;

    
}

-(void)setupCellContentWith:(NSArray*)model{
    int state = [model[0] intValue];
    self.label1.text =[NSString stringWithFormat:@"订单编号 : %@",model[1]] ;
    NSString* text1 = model[2];
    NSString* time = [text1 substringToIndex:text1.length-3];
    NSString* str1 = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    self.label2.text =[NSString stringWithFormat:@"下单时间 : %@",str1];
    if (state != 3) {
        self.label3.hidden = YES;
    }else{
        NSString* text2 = model[3];
        NSString* time2 = [text2 substringToIndex:text2.length-3];
        NSString* str2 = [time2 stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.label3.text =[NSString stringWithFormat:@"取消时间 : %@",str2];
        //self.label3.text =[NSString stringWithFormat:@"取消时间 : %@",[model[3] substringToIndex:16]];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
