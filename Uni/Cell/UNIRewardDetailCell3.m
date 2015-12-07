//
//  UNIRewardDetailCell3.m
//  Uni
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardDetailCell3.h"

@implementation UNIRewardDetailCell3

- (void)awakeFromNib {
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label2.textColor = kMainGrayBackColor;
    self.label3.textColor = kMainGrayBackColor;
}


-(void)setupCellContentWith:(id)model{
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
