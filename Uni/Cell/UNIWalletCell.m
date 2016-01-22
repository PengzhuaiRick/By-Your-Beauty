//
//  UNIWalletCell.m
//  Uni
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIWalletCell.h"

@implementation UNIWalletCell

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    float imgXY =16;
    float imgW = size.width - 2*imgXY;
    float imgH = size.height - imgXY;
    UIImageView* img= [[UIImageView alloc]initWithFrame:CGRectMake(imgXY, imgXY, imgW, imgH)];
    img.image = [UIImage imageNamed:@"card_img_bg2"];
    [self addSubview:img];
    self.mainImg = img;
    
    float labS1W = imgW*0.6;
    float labS2W = imgW - labS1W;
    
    float labW = labS1W/3;
    float labH = KMainScreenWidth*20/320;
    float labY = (imgH- labH)/2 ;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, labY, labW, labH)];
    lab.text=@"￥";
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment=NSTextAlignmentCenter;
    lab .font =[UIFont systemFontOfSize:KMainScreenWidth*20/320];
    [img addSubview:lab];
    
    float lab1W = labS1W;
    float lab1H = imgH/2;
    float lab1Y = labH;
    float lab1X = 0;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab1Y, lab1W, lab1H)];
    lab1.text=@"100";
    lab1.textColor = [UIColor whiteColor];
    lab1 .font =[UIFont systemFontOfSize:lab1H];
    lab1.textAlignment=NSTextAlignmentCenter;
    [img addSubview:lab1];
    self.lab1 = lab1;
    
    
    float lab2W = labS1W;
    float lab2H = KMainScreenWidth*30/320;
    float lab2Y = CGRectGetMaxY(lab.frame);
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, lab2Y, lab2W, lab2H)];
    lab2.text=@"满1000元减100元";
    lab2.textColor = [UIColor whiteColor];
    lab2.textAlignment=NSTextAlignmentCenter;
    lab2 .font =[UIFont systemFontOfSize:KMainScreenWidth*14/320];
    [img addSubview:lab2];
    self.lab2 = lab2;
    
    float lab3X = labS1W;
    float lab3W = labS2W;
    float lab3H = KMainScreenWidth*20/320;
    float lab3Y = imgH/2- lab3H - lab3H/2;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab3Y, lab3W, lab3H)];
    lab3.text=@"使用期限";
    lab3.textColor = [UIColor whiteColor];
    lab3.textAlignment=NSTextAlignmentCenter;
    lab3 .font =[UIFont systemFontOfSize:KMainScreenWidth*15/320];
    [img addSubview:lab3];
    
    float lab4X = labS1W;
    float lab4W = labS2W;
    float lab4H = KMainScreenWidth*20/320;
    float lab4Y = CGRectGetMaxY(lab3.frame);
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab4X, lab4Y, lab4W, lab4H)];
    lab4.text=@"2015.10.20 00:00";
    lab4.textColor = [UIColor whiteColor];
    lab4.textAlignment=NSTextAlignmentCenter;
    lab4 .font =[UIFont systemFontOfSize:KMainScreenWidth*13/320];
    [img addSubview:lab4];
    self.lab3 = lab4;
    
    float lab5X = labS1W;
    float lab5W = labS2W;
    float lab5H = KMainScreenWidth*20/320;
    float lab5Y = CGRectGetMaxY(lab4.frame);
    UILabel* lab5 = [[UILabel alloc]initWithFrame:CGRectMake(lab5X, lab5Y, lab5W, lab5H)];
    lab5.text=@"2015.12.20 23:59";
    lab5.textColor = [UIColor whiteColor];
    lab5.textAlignment=NSTextAlignmentCenter;
    lab5 .font =[UIFont systemFontOfSize:KMainScreenWidth*13/320];
    [img addSubview:lab5];
    self.lab4 = lab5;
    
  
//    float img1WH = imgH - 30;
//    float centerX = imgW*0.6;
//    float centerY = imgH/2;
//    UIImageView* img1= [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, img1WH, img1WH)];
//    img1.image = [UIImage imageNamed:@"card_img_overdus"];
//    img1.center = CGPointMake(centerX, centerY);
//    [img addSubview:img1];
//    self.overDusImg = img1;

}
-(void)setupCellContent:(id)model;{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
