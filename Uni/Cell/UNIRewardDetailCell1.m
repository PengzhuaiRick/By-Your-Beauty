//
//  UNIRewardDetailCell1.m
//  Uni
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardDetailCell1.h"

@implementation UNIRewardDetailCell1

- (void)awakeFromNib {
//    float cellH = KMainScreenWidth*65/320;
//    float cellW = KMainScreenWidth-32;
//    
//    float labX = 20;
//    float labW = cellW - labX -8;
//    float labH = KMainScreenWidth* 18/320;
//    
//    float lab1Y = (cellH - 3*labH)/2;
//    self.label1.frame = CGRectMake(labX, lab1Y, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont boldSystemFontOfSize:13];
//
//    float lab2Y = lab1Y+labH;
//    self.label2.frame = CGRectMake(labX, lab2Y, labW, labH);
    self.label2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label2.font = [UIFont boldSystemFontOfSize:13];
//
//    float lab3Y = lab2Y+labH;
//    self.label3.frame = CGRectMake(labX, lab3Y, labW, labH);
    self.label3.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label3.font = [UIFont boldSystemFontOfSize:13];
    
    self.stateBtn.layer.masksToBounds = YES;
    self.stateBtn.layer.cornerRadius = 25;
    [self.stateBtn setBackgroundColor:kMainGrayBackColor];
    self.stateBtn.titleLabel.numberOfLines = 0;
    self.stateBtn.titleLabel.lineBreakMode = 0;
    self.stateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*12/320];
    [self.stateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)setupCellContentWith:(UNIRewardListModel*)model{
    int state = model.status;
    self.label1.text =[NSString stringWithFormat:@"订 单 号 : "] ;
    self.label2.text =[NSString stringWithFormat:@"下单时间 : "];
    if (state != 1) {
        self.label3.hidden = YES;
    }else{
        self.label3.hidden = NO;
        self.label3.text =[NSString stringWithFormat:@"取消时间 : "];}
    if (state == 0)
        [self.stateBtn setTitle:@"未领取" forState:UIControlStateNormal];
    else
        [self.stateBtn setTitle:@"已领取" forState:UIControlStateNormal];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
