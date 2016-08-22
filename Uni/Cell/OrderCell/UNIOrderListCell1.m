//
//  UNIOrderListCell1.m
//  Uni
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderListCell1.h"

@implementation UNIOrderListCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    _mainLab.font = kWTFont(15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
