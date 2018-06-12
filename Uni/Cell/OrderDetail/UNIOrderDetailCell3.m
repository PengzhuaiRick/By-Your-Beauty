//
//  UNIOrderDetailCell3.m
//  Uni
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderDetailCell3.h"

@implementation UNIOrderDetailCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    _mianimg.layer.borderWidth = 1;
    _mianimg.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    
    _label1.font = kWTFont(14);
    _label2.font = kWTFont(14);
    _label3.font = kWTFont(14);
    _label4.font = kWTFont(14);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
