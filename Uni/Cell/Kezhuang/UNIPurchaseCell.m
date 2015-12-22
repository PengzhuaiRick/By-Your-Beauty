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
    
    float cellH = [[self class] CellHight];
    
    float imgWH =KMainScreenWidth*45/320;
    float imgX = 16;
    float imgY = (cellH - imgWH)/2;
    self.mainImg.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
    
    float lab1X = CGRectGetMaxX(self.mainImg.frame)+5;
    float lab1H = KMainScreenWidth*21/320;
    float lab1W = KMainScreenWidth* 145/320;
    float lab1Y = cellH/2 - lab1H;
    self.label1.frame = CGRectMake(lab1X, lab1Y, lab1W, lab1H);
    self.label1.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*14/320];
    
    float lab2Y = cellH/2 ;
    self.label2.frame = CGRectMake(lab1X, lab2Y, lab1W, lab1H);
    self.label2.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*14/320];
    
    float publicH = KMainScreenWidth* 23/320;
    
    float jiaW = KMainScreenWidth* 25/320;
    float jiaX = self.frame.size.width - 8 - jiaW;
    float jiaY = cellH/2 - publicH/2;
    self.jiabtn.frame =CGRectMake(jiaX, jiaY, jiaW, publicH);
    
    float fieldW = KMainScreenWidth* 30/320;
    float fieldX =jiaX - fieldW;
    self.countField.frame =CGRectMake(fieldX, jiaY, fieldW, publicH);
    
    float jianX =fieldX- jiaW;
    self.jianbtn.frame =CGRectMake(jianX, jiaY, jiaW, publicH);
    
    
    
    [[_jiabtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        int num = self.countField.text.intValue;
        if (num<999)
            self.countField.text = [NSString stringWithFormat:@"%d",++num];
        
    }];
    
    [[_jianbtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         int num = self.countField.text.intValue;
         if (num>1)
         self.countField.text = [NSString stringWithFormat:@"%d",--num];
         
     }];
    
    [self.countField.rac_textSignal subscribeNext:^(NSString* x) {
        if (x.intValue>999) {
            self.countField.text =@"999";
        }
    }];
}


-(void)setupCellContentWith:(id)model{
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(float)CellHight{
    return KMainScreenWidth*86/320;
}

@end
