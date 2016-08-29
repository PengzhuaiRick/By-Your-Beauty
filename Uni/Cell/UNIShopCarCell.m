//
//  UNIShopCarCell.m
//  Uni
//
//  Created by apple on 16/8/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIShopCarCell.h"

@implementation UNIShopCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.font = kWTFont(14);
    _label2.font = kWTFont(13);
    _label3.font = kWTFont(14);
    _numField.font = kWTFont(13);
    
    _numView.layer.masksToBounds = YES;
    _numView.layer.cornerRadius = _numView.frame.size.height/2;
    _numView.layer.borderWidth = 1;
    _numView.layer.borderColor = [UIColor colorWithHexString:@"959595"].CGColor;
    
    _mainimg.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    _mainimg.layer.borderWidth = 1;
    
    [_selectBtn setImage:[UIImage imageNamed:@"addpro_btn_selelct1"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"addpro_btn_selelct2"] forState:UIControlStateSelected];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
