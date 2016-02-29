//
//  UNIAddProjcetCell.m
//  Uni
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIAddProjcetCell.h"

@implementation UNIAddProjcetCell
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    float imgX = KMainScreenWidth*20/320;
    float imgY = 10;
    float imgWH =size.height - 2*imgY;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    //img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImage = img;
    
    float btnWH =KMainScreenWidth*20/320;
    float btnY = (size.height - btnWH)/2;
    float btnX = size.width - 20 - btnWH;
//    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = btnWH/2;
//    btn.layer.borderColor = [UIColor colorWithHexString:kMainThemeColor].CGColor;
//    [btn setBackgroundImage:[UIImage imageNamed:@"addpro_btn_selelct1"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@"addpro_btn_selelct2"] forState:UIControlStateHighlighted];
//    [btn setBackgroundImage:[UIImage imageNamed:@"addpro_btn_selelct2"] forState:UIControlStateSelected];
//    [self addSubview:btn];
//    self.handleBtn =  btn;
    
    UIImageView* hImag = [[UIImageView alloc]initWithFrame:CGRectMake(btnX, btnY, btnWH, btnWH)];
    hImag.userInteractionEnabled = YES;
    hImag.image =[UIImage imageNamed:@"addpro_btn_selelct1"];
    [self addSubview:hImag];
    _handleImag = hImag;
    
    float labX = CGRectGetMaxX(img.frame)+20;
    float labW = size.width -CGRectGetMaxX(img.frame) - imgX - btnWH;
    float labH = KMainScreenWidth* 20/320;
    float lab1Y = size.height/2 - labH;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    float lab2Y = size.height/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, labH)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
    lab2.textColor =kMainGrayBackColor;
    [self addSubview:lab2];
    self.subLab = lab2;
    
    
}
-(void)setupCellWithData:(id)model{
    UNIMyProjectModel* info = model;
    NSString* imgUrl = info.logoUrl;
    NSArray* arr = [info.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgUrl];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:nil];
    self.mainLab.text = info.projectName;
    self.subLab .text = [NSString stringWithFormat:@"剩余%d次",info.num];
    if (info.select) {
        self.handleBtn.selected = YES;
    }else{
        self.handleBtn.selected = NO;
    }
}


@end
