//
//  UNIRewardListXibCell.m
//  Uni
//
//  Created by apple on 16/8/17.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIRewardListXibCell.h"
#import "UNIRewardListModel.h"
@implementation UNIRewardListXibCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    
    _label1.font = kWTFont(15);
    _label2.font = kWTFont(15);
    _label3.font = kWTFont(15);
    _stateBtn.titleLabel.font = kWTFont(14);
    
    _backView.layer.masksToBounds=YES;
    _backView.layer.cornerRadius = 5;
    _backView.layer.borderColor = [UIColor colorWithHexString:@"d5d5d5"].CGColor;
    _backView.layer.borderWidth =1;
    
    _stateBtn.layer.masksToBounds=YES;
    _stateBtn.layer.borderWidth = 1;
    _stateBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _stateBtn.titleLabel.numberOfLines = 0;
    _stateBtn.titleLabel.lineBreakMode = 0;
    [_stateBtn setTitle:@"马上\n预约" forState:UIControlStateNormal];
    
    float h =_stateBtn.frame.size.height;
    _stateBtn.layer.cornerRadius =(KMainScreenWidth* h /414)/2;
}
-(void)setupCellContentWith:(id)model{
    UNIRewardListModel* info = model;
    NSString* imgUrl = info.logoUrl;
    NSArray* arr = [info.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                    placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    self.label1.text =info.projectName;
    self.label2.text =[NSString stringWithFormat:@"规格: %@     x%d",info.specifications,info.num];
    self.label3.text = [info.time substringWithRange:NSMakeRange(5, 11)];
    
    if (info.status==0) {
        self.stateBtn.enabled=YES;
        [self.stateBtn setTitle:@"到店\n领取" forState:UIControlStateNormal];
        self.stateImg.image = [UIImage imageNamed:@"main_btn_cell2"];
        
    }else{
        self.stateBtn.enabled=NO;
        [self.stateBtn setTitle:@"已领取" forState:UIControlStateNormal];
        self.stateImg.image = [UIImage imageNamed:@"main_btn_cell3"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
