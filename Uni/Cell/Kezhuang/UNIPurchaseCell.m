//
//  UNIPurchaseCell.m
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIPurchaseCell.h"

@implementation UNIPurchaseCell

- (void)awakeFromNib {
    self.layer.masksToBounds=YES;
    self.layer.cornerRadius = 5;
   
}

-(void)setupCellContentWith:(id)model{
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
