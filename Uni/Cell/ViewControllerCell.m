//
//  ViewControllerCell.m
//  Uni
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "ViewControllerCell.h"

@implementation ViewControllerCell
-(id)initWithCellH:(float)cellH reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        cellHight = cellH;
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    float cellH = cellHight;
    
    float imgWH = cellH/3;
    float imgX = KMainScreenWidth*30/320;
    float imgY = (cellH - imgWH)/2;
    
    UIImageView* imgview = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    [self addSubview:imgview];
    imgview.contentMode = UIViewContentModeScaleAspectFit;
    self.mainImg = imgview;
    
    float lab3WH = imgWH/2;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, lab3WH, lab3WH)];
    lab3.center = CGPointMake(imgWH, 0);
    lab3.textColor = [UIColor whiteColor];
    lab3.backgroundColor = [UIColor colorWithHexString:kMainThemeColor];
    lab3.text = @"3";
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.layer.masksToBounds = YES;
    lab3.layer.cornerRadius = lab3WH/2;
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth*lab3WH/2/320];
    [imgview addSubview:lab3];
    self.numLab = lab3;
    
    float labX = CGRectGetMaxX(imgview.frame)+10;
    float labH = KMainScreenWidth*20/320;
    float labW = self.frame.size.width - labX;
    float labY = (cellH - labH)/2;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth*17/320];
    lab.lineBreakMode = 0;
    lab.numberOfLines = 0 ;
    [self addSubview:lab];
    self.mainLab = lab;

}

- (void)awakeFromNib {
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)getCellHeight{
    return KMainScreenWidth*50/320;
}

@end
