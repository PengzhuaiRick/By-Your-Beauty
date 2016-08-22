//
//  WTOrderDetailCell1.m
//  Welfare Treasure
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WTOrderDetailCell1.h"

@implementation WTOrderDetailCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    _title1.font = kWTFont(15);
    _title2.font = kWTFont(15);
    _title3.font = kWTFont(15);
    
    _lable1.font = kWTFont(15);
    _lable2.font = kWTFont(15);
    _lable3.font = kWTFont(15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
