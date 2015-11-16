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

-(void)updateFrame:(CGRect)re{
   
    int uiX = 8;
    int uiY = 8;
    _mainImage.frame = CGRectMake(uiX, uiY, CELLH-uiY*2, CELLH-uiY*2);
    
    _handleBtn.frame = CGRectMake(re.size.width-uiX- (CELLH-uiY*2),
                                  uiY, CELLH-uiY*2, CELLH-uiY*2);
    
    float mainLabW = re.size.width-(CELLH-uiY*2)*2-uiX*2;
    float mainLabH = CELLH/2-8;
    _mainLab.frame = CGRectMake(CGRectGetMaxX(_mainImage.frame)+10, 8, mainLabW, mainLabH);
    
    _subLab.frame = CGRectMake(CGRectGetMaxX(_mainImage.frame)+10, CGRectGetMaxY(_mainLab.frame), mainLabW, mainLabH);

}

@end
