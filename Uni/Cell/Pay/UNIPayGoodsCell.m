//
//  UNIPayGoodsCell.m
//  Uni
//
//  Created by apple on 16/8/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIPayGoodsCell.h"

@implementation UNIPayGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.font = kWTFont(15);
    _label2.font = kWTFont(15);
    
    _numView.layer.masksToBounds=YES;
    _numView.layer.cornerRadius = _numView.frame.size.height/2;
    _numView.layer.borderWidth = 1;
    _numView.layer.borderColor = [UIColor colorWithHexString:@"959595"].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
