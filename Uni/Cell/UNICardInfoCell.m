//
//  UNICardInfoCell.m
//  Uni
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNICardInfoCell.h"

@implementation UNICardInfoCell

- (void)awakeFromNib {
    float cellH = KMainScreenWidth*65/320;
    float cellW = KMainScreenWidth-32;
    
    UIImage* img = [UIImage imageNamed:@"main_img_cell2"];
    self.mainImg.image = img;
    float imgH = KMainScreenWidth*50/320;
    float imgW = imgH*img.size.width/img.size.height;
    float imgX = 8;
    float imgY = (cellH - imgH)/2;
    self.mainImg.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    float btnWH = imgH;
    float btnX = cellW - btnWH - 8;
    float btnY = imgY;
    self.stateBtn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    self.stateBtn.layer.masksToBounds = YES;
    self.stateBtn.layer.cornerRadius = KMainScreenWidth*25/320;
    [self.stateBtn setBackgroundColor:[UIColor colorWithHexString:kMainTitleColor]];
    self.stateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*12/320];
    [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    float img2H = cellH/2;
    self.img2.frame = CGRectMake(btnX, img2H, btnWH, img2H);
    
    float labX = imgX+imgW;
    float labW = cellW - labX - btnWH - 10;
    float labH = KMainScreenWidth* 18/320;
    
    float lab1Y =(cellH -2*labH)/2;
    self.label1.frame = CGRectMake(labX, lab1Y, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
    
    float lab2Y = lab1Y+labH;
    self.label2.frame = CGRectMake(labX, lab2Y, labW, labH);
    self.label2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label2.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*12/320];
    
    
}
-(void)setupCellContentWith:(id)model{
    self.label1.text = @"日本皇室奖励";
    self.label2.text = @"9-21 15:20";
    [self.stateBtn setTitle:@"已完成" forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
