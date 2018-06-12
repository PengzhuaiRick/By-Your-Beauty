//
//  UNIPayStyleCell.m
//  Uni
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIPayStyleCell.h"

@implementation UNIPayStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.font =kWTFont(14);
    [_handleBtn setImage:[UIImage imageNamed:@"addpro_btn_selelct1"] forState:UIControlStateNormal];
    [_handleBtn setImage:[UIImage imageNamed:@"addpro_btn_selelct2"] forState:UIControlStateSelected];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
