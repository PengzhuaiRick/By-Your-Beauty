//
//  UNIVIPMemberCell.m
//  Uni
//
//  Created by apple on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIVIPMemberCell.h"

@implementation UNIVIPMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = KMainScreenWidth* 5/414;
    
    _mainLab.font = kWTFont(14);
    _subLab.font = kWTFont(14);
    _handleBtn.titleLabel.font = kWTFont(14);
    
    _handleBtn.layer.masksToBounds = YES;
    // _handleBtn.layer.cornerRadius =_handleBtn.frame.size.height/2;
    _handleBtn.layer.borderWidth = 1;
    _handleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _handleBtn.titleLabel.numberOfLines = 0;
    _handleBtn.titleLabel.lineBreakMode = 0;
    [_handleBtn setTitle:@"马上\n预约" forState:UIControlStateNormal];
    
    float h =_handleBtn.frame.size.height;
    _handleBtn.layer.cornerRadius =(KMainScreenWidth* h /414)/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
