//
//  WTOrderDetailCell2.m
//  Welfare Treasure
//
//  Created by apple on 16/6/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WTOrderDetailCell2.h"

@implementation WTOrderDetailCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    _title1.font= kWTFont(15);
    _title2.font= kWTFont(15);
    _title3.font= kWTFont(15);
    _title4.font= kWTFont(15);
    
    _label1.font= kWTFont(15);
    _label2.font= kWTFont(15);
    _label3.font= kWTFont(15);
    _label4.font= kWTFont(15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
