//
//  UNIGoodsCell4.m
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIGoodsCell4.h"

@implementation UNIGoodsCell4

- (void)awakeFromNib {
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 65/2;
    self.submitBtn.titleLabel.numberOfLines = 0;
    self.submitBtn.titleLabel.lineBreakMode = 0;
    [self.submitBtn setTitle:@"立即\n购买" forState:UIControlStateNormal];
 
}

-(void)setupCellContentWith:(id)model{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
