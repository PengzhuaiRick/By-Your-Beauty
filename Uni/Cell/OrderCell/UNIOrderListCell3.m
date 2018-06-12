//
//  UNIOrderListCell3.m
//  Uni
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderListCell3.h"

@implementation UNIOrderListCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.font = kWTFont(15);
    _label2.font = kWTFont(15);
    _label3.font = kWTFont(15);
    _label4.font = kWTFont(15);
    _label5.font = kWTFont(15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
