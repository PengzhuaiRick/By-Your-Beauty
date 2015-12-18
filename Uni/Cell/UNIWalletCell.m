//
//  UNIWalletCell.m
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIWalletCell.h"

@implementation UNIWalletCell

- (void)awakeFromNib {
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont boldSystemFontOfSize:13];
  
    self.label2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label2.font = [UIFont boldSystemFontOfSize:13];
    
    self.stateBtn.layer.masksToBounds = YES;
    self.stateBtn.layer.cornerRadius = 25;
    self.stateBtn.layer.borderColor = [UIColor blackColor].CGColor;
    self.stateBtn.layer.borderWidth = 0.5;
    self.stateBtn.titleLabel.numberOfLines = 0;
    self.stateBtn.titleLabel.lineBreakMode = 0;
    self.stateBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*11/320];
    [self.stateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

}

-(void)setupCellContentWith:(id)model{
    
    self.mainImag.image = [UIImage imageNamed:@"KZ_img_wallet"];
    self.label1.text=@"日本皇室酵素风吕护理";
    self.label2.text=@"2015-09-21 15:21";
    
    [self.stateBtn setTitle:@"+25.00" forState:UIControlStateNormal];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
