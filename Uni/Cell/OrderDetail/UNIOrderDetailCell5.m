//
//  UNIOrderDetailCell5.m
//  Uni
//
//  Created by apple on 16/8/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderDetailCell5.h"

@implementation UNIOrderDetailCell5

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.font = kWTFont(14);
    _label2.font = kWTFont(14);
    _label3.font = kWTFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
