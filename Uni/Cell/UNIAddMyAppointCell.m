//
//  UNIMyAppointCell.m
//  Uni
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAddMyAppointCell.h"
@implementation UNIAddMyAppointCell
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    float imgX = KMainScreenWidth>320?20:16;
    float imgY = 8;
    float imgWH =size.height - imgY*2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
   // img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImg = img;
    
    
    float labX = CGRectGetMaxX(img.frame)+15;
    float labW = size.width -labX;
    float labH = KMainScreenWidth>320?20:17;
    float lab1Y =size.height/2 - labH -2;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>320?17:14];
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    float lab1H = KMainScreenWidth>320?18:16;;
    float lab2Y = size.height/2+2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>320?15:13];
    lab2.textColor = kMainGrayBackColor;
    [self addSubview:lab2];
    self.subLab = lab2;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
