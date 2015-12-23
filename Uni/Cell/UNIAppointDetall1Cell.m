//
//  UNIAppointDetall1Cell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetall1Cell.h"

@implementation UNIAppointDetall1Cell

- (void)awakeFromNib {
    float cellH = KMainScreenWidth*65/320;
    float cellW = KMainScreenWidth-32;
    
    float labX = 20;
    float labW = cellW - labX -8;
    float labH = KMainScreenWidth* 18/320;
    
    float lab1Y = (cellH - 3*labH)/2;
    self.label1.frame = CGRectMake(labX, lab1Y, labW, labH);
    self.label1.textColor = [UIColor colorWithHexString:kMainThemeColor];
    self.label1.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
    
    float lab2Y = lab1Y+labH;
    self.label2.frame = CGRectMake(labX, lab2Y, labW, labH);
    self.label2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label2.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];
    
    float lab3Y = lab2Y+labH;
    self.label3.frame = CGRectMake(labX, lab3Y, labW, labH);
    self.label3.textColor = [UIColor colorWithHexString:kMainTitleColor];
    self.label3.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*13/320];

}

-(void)setupCellContentWith:(NSArray*)model{
    int state = [model[0] intValue];
    self.label1.text =[NSString stringWithFormat:@"订 单 号 : %@",model[1]] ;
    NSString* text1 = [model[2] substringToIndex:16];
    self.label2.text =[NSString stringWithFormat:@"下单时间 : %@",text1];
    if (state != 3) {
        self.label3.hidden = YES;
    }else{
        self.label3.text =[NSString stringWithFormat:@"取消时间 : %@",[model[3] substringToIndex:16]];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
