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
    self.mainLab.textColor = [UIColor colorWithHexString:@"ee4c7d"];
    self.mainLab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.045];
    self.subLab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.04];
    self.mainImage.contentMode = UIViewContentModeScaleAspectFit;
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
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
    
    _subLab.frame = CGRectMake(CGRectGetMaxX(_mainImage.frame)+10, CGRectGetMaxY(_mainLab.frame)+8, mainLabW, mainLabH);

}
-(void)setupCellContent:(id)model1 andType:(int)type{
    if (type==1) {
        UNIMyAppintModel* model = model1;
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]
                          placeholderImage:[UIImage imageNamed:@"main_img_cell1"]];
        self.mainLab.text = model.projectName;
        self.subLab.text = model.time;
        if (model.status == 1)
            [self.handleBtn setTitle:@"待确认" forState:UIControlStateNormal];
        else if (model.status == 2)
            [self.handleBtn setTitle:@"待服务" forState:UIControlStateNormal];
        self.handleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.036];
        [self.handleBtn setBackgroundImage:[UIImage imageNamed:@"main_btn_cell1"] forState:UIControlStateNormal];
    }
    else if (type == 2){
        UNIMyProjectModel* model = model1;
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]
                          placeholderImage:[UIImage imageNamed:@"main_img_cell1"]];
        self.mainLab.text = model.projectName;
        self.subLab.text = [NSString stringWithFormat:@"剩余次数         %i",model.num];
        [self.handleBtn setTitle:@"立即\n预约" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.handleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.035];
        self.handleBtn.titleLabel.numberOfLines = 0;
        self.handleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.handleBtn setBackgroundImage:[UIImage imageNamed:@"appoint_btn_sure"] forState:UIControlStateNormal];
       
    }
}

-(void)setAppointCell:(id)model and:(int)num and:(int)type{
    UNIMyRewardModel* info = model;
    [self.handleBtn setBackgroundImage:[UIImage imageNamed:@"main_btn_cell1"] forState:UIControlStateNormal];
    [self.handleBtn setTitle:[NSString stringWithFormat:@"%d次",num] forState:UIControlStateNormal];
    
    if (type==1){
        self.mainLab.text = [NSString stringWithFormat:@"预约成功满%d次",info.rewardNum];
        self.mainImage.image = [UIImage imageNamed:@"evaluete_img_reward"];
    }
    else{
        self.mainLab.text = [NSString stringWithFormat:@"准时到店满%d次",info.rewardNum];
        self.mainImage.image = [UIImage imageNamed:@"card_img_ITreward"];
    }
    self.subLab.text = info.goods;
}

@end
