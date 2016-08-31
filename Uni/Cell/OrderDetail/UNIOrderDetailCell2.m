//
//  UNIOrderDetailCell2.m
//  Uni
//
//  Created by apple on 16/8/31.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderDetailCell2.h"

@implementation UNIOrderDetailCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    _title1.font= kWTFont(15);
    _title2.font= kWTFont(15);
    _title3.font= kWTFont(15);
    
    _label1.font= kWTFont(15);
    _label2.font= kWTFont(15);
    _label3.font= kWTFont(15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
