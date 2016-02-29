//
//  UNIOrderListCell.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderListCell.h"

@implementation UNIOrderListCell

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    
    float imgX = KMainScreenWidth* 10 /320;
    float imgY = KMainScreenWidth* 10 /320;
    float imgWH =size.height - imgY*2;
    
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    //img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImg = img;
    //    [self.mainImg sd_setImageWithURL:nil
    //                    placeholderImage:[UIImage imageNamed:@"evaluete_img_reward"]];
    
    float lab3WH =KMainScreenWidth* 70/414;
    float lab3Y =(size.height - lab3WH)/2;
    float lab3X = size.width - 10 - lab3WH;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab3Y, lab3WH, lab3WH)];
    lab3.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth>320?16:14];
    lab3.textColor = [UIColor whiteColor];
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.lineBreakMode = 0;
    lab3.numberOfLines = 0;
    lab3.layer.masksToBounds = YES;
    lab3.layer.cornerRadius = lab3WH/2;
    [self addSubview:lab3];
    self.stateBtn = lab3;
    //    self.stateBtn.text= @"到店\n领取";
    //    [self.stateBtn setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    
    
    float labX = CGRectGetMaxX(img.frame)+10;
    float labW = size.width -2*imgX -lab3WH - imgWH;
    float labH = size.height/2;
    float lab1Y = 0;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>320?16:14];
    // lab1.text = @"ALBION 爽肤精体液";
    [self addSubview:lab1];
    self.label1 = lab1;
    
    float lab1H = KMainScreenWidth*17/320;
    float lab2Y = size.height/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>320?14:12];
    lab2.textColor = kMainGrayBackColor;
    //lab2.text = @"规格: 330ml       x1";
    [self addSubview:lab2];
    self.label2 = lab2;
    
    
    float lab4Y = CGRectGetMaxY(lab2.frame);
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab4Y, labW, lab1H)];
    lab4.font = [UIFont systemFontOfSize:KMainScreenWidth>320?14:12];
    lab4.textColor = [UIColor colorWithHexString:kMainThemeColor];
    // lab4.text = @"9-21 15:20";
    [self addSubview:lab4];
    
    self.label3 = lab4;
    
    
    
}


-(void)setupCellContentWith:(id)model{
    UNIOrderListModel* info = model;
    NSString* imgUrl = info.logoUrl;
    NSArray* arr = [info.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    
    NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgUrl];
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:str]
                    placeholderImage:[UIImage imageNamed:@"main_img_shuang"]];

    
    self.label1.text=info.projectName;
    self.label2.text=[NSString stringWithFormat:@"规格: %@     x%d",info.specifications,info.num];
    self.label3.text=info.time;
    
    if (info.status==0) {
        self.stateBtn.text= @"到店\n领取";
        [self.stateBtn setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    }else{
            self.stateBtn.text= @"已领取";
            [self.stateBtn setBackgroundColor:kMainGrayBackColor];
        }
}


@end
