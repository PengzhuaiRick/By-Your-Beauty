//
//  UNIRewardListCell.m
//  Uni
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardListCell.h"

@implementation UNIRewardListCell

- (void)awakeFromNib {
//    float cellH = KMainScreenWidth*90/320;
//    float cellW = KMainScreenWidth-32;
//    
//    UIImage* img = [UIImage imageNamed:@"main_img_cell2"];
//    self.mainImg.image = img;
//    float imgH = cellH/2;
//    float imgW = imgH*img.size.width/img.size.height;
//    float imgX = 5;
//    float imgY = (cellH - imgH)/2;
//    self.mainImg.frame = CGRectMake(imgX, imgY, imgW, imgH);
//    
//    float btnWH = imgH;
//    float btnX = cellW - btnWH - 8;
//    float btnY = imgY;
//    self.stateBtn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    self.stateBtn.layer.masksToBounds = YES;
    self.stateBtn.layer.cornerRadius = 22;
    [self.stateBtn setBackgroundColor:kMainGrayBackColor];
    self.stateBtn.titleLabel.numberOfLines = 0;
    self.stateBtn.titleLabel.lineBreakMode = 0;
    self.stateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//
//    float labX = imgX+imgW;
//    float labW = cellW - labX - btnWH - 10;
//    float labH = KMainScreenWidth* 18/320;
//    
//    float lab1Y =(cellH -3*labH)/2;
//    self.label1.frame = CGRectMake(labX, lab1Y, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont boldSystemFontOfSize:11];
//
//    float lab2Y = lab1Y+labH;
//    self.label2.frame = CGRectMake(labX, lab2Y, labW, labH);
    self.label2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label2.font = [UIFont boldSystemFontOfSize:11];
    
//
//    float lab3Y = lab2Y+labH;
//    self.label3.frame = CGRectMake(labX, lab3Y, labW, labH);
    self.label3.textColor = [UIColor blackColor];
    self.label3.font = [UIFont boldSystemFontOfSize:11];
}

-(void)setupCellContentWith:(id)model{
    [self.mainImg sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"evaluete_img_reward"]];
    self.label1.text =@"日本皇室酵素精油";
    self.label2.text = @"规格 : 200ml x1";
    self.label3.text = @"9-25 10:20";
   // [self.stateBtn setBackgroundImage:[UIImage imageNamed:@"appoint_btn_sure"] forState:UIControlStateNormal];
    [self.stateBtn setTitle:@"到店\n领取" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
