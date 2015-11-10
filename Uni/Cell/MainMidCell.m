//
//  MainMidCell.m
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMidCell.h"

@implementation MainMidCell

- (void)awakeFromNib {
}


-(void)setupBtnStyle1{
    _handleBtn.layer.borderColor = [UIColor clearColor].CGColor;
    _handleBtn.layer.borderWidth = 0;
    [_handleBtn setTitle:@"待确定" forState:UIControlStateNormal];
}

-(void)setupBtnStyle2{
    _handleBtn.layer.borderColor = [UIColor blackColor].CGColor;
    _handleBtn.layer.borderWidth = 1;
    [_handleBtn setTitle:@"马上预约" forState:UIControlStateNormal];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
