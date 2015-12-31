//
//  UNIRewardDetailCell2.m
//  Uni
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardDetailCell2.h"

@implementation UNIRewardDetailCell2

- (void)awakeFromNib {
//    float cellH = KMainScreenWidth*90/320;
//    float cellW = KMainScreenWidth-32;
//    
    UIImage* img = [UIImage imageNamed:@"evaluete_img_reward"];
    self.mainImg.image = img;
//    float imgH = cellH/2;
//    float imgW = imgH*img.size.width/img.size.height;
//    float imgX = 5;
//    float imgY = (cellH - imgH)/2;
//    self.mainImg.frame = CGRectMake(imgX, imgY, imgW, imgH);
//    
//    float labX = imgX+imgW;
//    float labW = cellW - labX - btnWH - 10;
//    float labH = KMainScreenWidth* 18/320;e
//    
//    float lab1Y =(cellH -3*labH)/2;
//    self.label1.frame = CGRectMake(labX, lab1Y, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
//
//    float lab2Y = lab1Y+labH;
//    self.label2.frame = CGRectMake(labX, lab2Y, labW, labH);
    self.label2.textColor = kMainGrayBackColor;
    self.label2.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
//
//    float lab3Y = lab2Y+labH;
//    self.label3.frame = CGRectMake(labX, lab3Y, labW, labH);
    self.label3.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label3.font = [UIFont systemFontOfSize:KMainScreenWidth*17/320];
    
    self.label4.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label4.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
    
    self.label5.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label5.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
    
    self.label6.textColor = kMainGrayBackColor;
    self.label6.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
    
}

-(void)setupCellContentWith:(id)model{

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
