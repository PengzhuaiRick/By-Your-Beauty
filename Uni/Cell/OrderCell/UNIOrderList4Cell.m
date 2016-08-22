//
//  UNIOrderList4Cell.m
//  Uni
//
//  Created by apple on 16/8/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderList4Cell.h"

@implementation UNIOrderList4Cell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.font = kWTFont(15);
    
    _handleBtn.layer.masksToBounds = YES;
    _handleBtn.layer.cornerRadius = 5;
    _handleBtn.titleLabel.font = kWTFont(15);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
