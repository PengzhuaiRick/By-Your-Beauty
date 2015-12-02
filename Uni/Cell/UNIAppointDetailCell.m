//
//  UNIAppointDetailCell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetailCell.h"

@implementation UNIAppointDetailCell

- (void)awakeFromNib {
    float cellH = KMainScreenWidth*100/320;
    float cellW = KMainScreenWidth-16;
    
    UIImage* img = [UIImage imageNamed:@"main_img_cell2"];
    self.mainImg.image = img;
    float imgH = cellH/2;
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
    self.stateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*14/320];
    [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    float labX = imgX+imgW+5;
    float labW = cellW - labX - btnWH - 5;
    float labH = KMainScreenWidth* 25/320;
    
    float lab1Y = 8;
    self.label1.frame = CGRectMake(labX, lab1Y, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];

    float lab2Y = lab1Y+labH+5;
    self.label2.frame = CGRectMake(labX, lab2Y, labW, labH);
    self.label2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label2.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
    
    float lab3Y = lab2Y+labH+5;
    self.label3.frame = CGRectMake(labX, lab3Y, labW, labH);
    self.label3.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label3.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
}

-(void)setupCellContentWith:(id)model{
    self.label1.text = @"美国全息皮肤检测";
    self.label2.text = @"预约时间 : 2015-12-10 12：30";
    self.label3.text = @"服务时长 : 90分钟";
    [self.stateBtn setTitle:@"待确定" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
