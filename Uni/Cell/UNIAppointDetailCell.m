//
//  UNIAppointDetailCell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetailCell.h"
#import "UNIMyAppointInfoModel.h"
@implementation UNIAppointDetailCell

- (void)awakeFromNib {
    float cellH = KMainScreenWidth*90/320;
    float cellW = KMainScreenWidth-32;
    
    UIImage* img = [UIImage imageNamed:@"main_img_cell2"];
    self.mainImg.image = img;
    float imgH = cellH/2;
    float imgW = imgH*img.size.width/img.size.height;
    float imgX = 5;
    float imgY = (cellH - imgH)/2;
    self.mainImg.frame = CGRectMake(imgX, imgY, imgW, imgH);
    
    float btnWH = imgH;
    float btnX = cellW - btnWH - 8;
    float btnY = imgY;
    self.stateBtn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    self.stateBtn.layer.masksToBounds = YES;
    self.stateBtn.layer.cornerRadius = KMainScreenWidth*22/320;
    [self.stateBtn setBackgroundColor:kMainGrayBackColor];
    self.stateBtn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
    [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    float labX = imgX+imgW;
    float labW = cellW - labX - btnWH - 10;
    float labH = KMainScreenWidth* 18/320;
    
    float lab1Y =(cellH -3*labH)/2;
    self.label1.frame = CGRectMake(labX, lab1Y, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];

    float lab2Y = lab1Y+labH;
    self.label2.frame = CGRectMake(labX, lab2Y, labW, labH);
    self.label2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label2.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
    
    float lab3Y = lab2Y+labH;
    self.label3.frame = CGRectMake(labX, lab3Y, labW, labH);
    self.label3.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label3.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
}

-(void)setupCellContentWith:(id)model{
    UNIMyAppointInfoModel* info = model;
    self.label1.text = info.projectName;
    self.label2.text = [NSString stringWithFormat:@"预约时间 : %@",[info.createTime substringToIndex:16]];
    self.label3.text =[NSString stringWithFormat:@"服务时长 : %d分钟",info.costTime ];
    NSString* titel = nil;
    switch (info.status) {
        case 0:
            titel = @"待确认";
            break;
        case 1:
            titel = @"待服务";
            break;
        case 2:
            titel = @"已完成";
            break;
        case 3:
            titel = @"已取消";
            break;
    }
    [self.stateBtn setTitle:titel forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
