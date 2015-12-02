//
//  UNIAppointDetall1Cell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetall1Cell.h"

@implementation UNIAppointDetall1Cell

- (void)awakeFromNib {
    //float cellH = KMainScreenWidth*75/320;
    float cellW = KMainScreenWidth-16;
    
    float labX = 16;
    float labW = cellW - labX - 16;
    float labH = KMainScreenWidth* 25/320;
    
    float lab1Y = 5;
    self.label1.frame = CGRectMake(labX, lab1Y, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*12/320];
    
    float lab2Y = lab1Y+labH;
    self.label2.frame = CGRectMake(labX, lab2Y, labW, labH);
    self.label2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label2.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*12/320];
    
    float lab3Y = lab2Y+labH;
    self.label3.frame = CGRectMake(labX, lab3Y, labW, labH);
    self.label3.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label3.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*12/320];

}

-(void)setupCellContentWith:(id)model{
    self.label1.text = @"订 单 号 : 9912341234";
    self.label2.text = @"下单时间 :2015-12-01 12:30";
    self.label3.text = @"取消时间 :2015-12-01 12:30";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
