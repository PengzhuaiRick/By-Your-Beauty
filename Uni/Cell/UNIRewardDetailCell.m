//
//  UNIRewardDetailCell.m
//  Uni
//
//  Created by apple on 16/1/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIRewardDetailCell.h"

@implementation UNIRewardDetailCell

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier andTpye:(int)tp{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize andTpye:tp];
    }
    return self;
}
-(void)setupUI:(CGSize)size andTpye:(int)tp{
    
    float proY = KMainScreenWidth*5/320;
    float proWH =size.height - 2*proY;
    float proX =size.width - proY -proWH;
    UNIRewardProgessView* view = [[UNIRewardProgessView alloc]initWithFrame:CGRectMake(proX, proY, proWH, proWH)];
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
    self.progessView = view;
    
    float labX = KMainScreenWidth*10/320;
    float labW = KMainScreenWidth*100/320;
    float labH = KMainScreenWidth*20/320;
    float labY = size.height/2 - labH;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*15/320];
    if (tp == 1)
        lab1.text= @"成功约满";
    if (tp == 2)
        lab1.text= @"准时到店满";
    [lab1 sizeToFit];
    [self addSubview:lab1];
   
    
    float lab2X = CGRectGetMaxX(lab1.frame);
    float lab2W = KMainScreenWidth*40/320;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, labY, lab2W, labH)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth*15/320];
    lab2.textColor =[UIColor colorWithHexString:kMainThemeColor];
    [self addSubview:lab2];
    self.mainLab = lab2;
    
    
    float lab3Y = size.height/2;
    float lab3W = KMainScreenWidth* 70/320;
    float lab3X = size.width - proWH - labX - lab3W;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab3Y, lab3W, labH)];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    lab3.textColor = [UIColor blackColor];
    lab3.text = @"价值￥580";
    [self addSubview:lab3];
    self.stateLab = lab3;
    
    float lab4W = size.width - 2*labX - proWH - lab3W;
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab3Y, lab4W, labH)];
    lab4.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    lab4.textColor = kMainGrayBackColor;
    lab4.lineBreakMode = 0;
    lab4.numberOfLines = 0;
    [self addSubview:lab4];
    self.subLab = lab4;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


-(void)setupCellContent:(id)model andType:(int)type{
    UNIMyRewardModel* info = model;
    self.mainLab.text = [NSString stringWithFormat:@"%d次",info.rewardNum];
    self.subLab.text = info.goods;
    
    CGSize titleSize = [info.goods boundingRectWithSize:CGSizeMake(self.subLab.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KMainScreenWidth*13/320]} context:nil].size;
    
    CGRect subRe = self.subLab.frame;
    subRe.size.width = titleSize.width;
    subRe.size.height = titleSize.height;
    self.subLab.frame = subRe;
    
    
    CGSize title1Size = [self.stateLab.text boundingRectWithSize:CGSizeMake(self.stateLab.frame.size.width,20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:KMainScreenWidth*13/320]} context:nil].size;
    
    CGRect stateRe = self.stateLab.frame;
    stateRe.origin.x = CGRectGetMaxX(self.subLab.frame);
    stateRe.size.height = title1Size.height;
    self.stateLab.frame = stateRe;
}



@end
