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
    float imgX = KMainScreenWidth>400?20:16;
    float imgY = 8;
    float imgWH =size.height - imgY*2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
   // img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImg = img;
    
    
    float labX = CGRectGetMaxX(img.frame)+15;
    float labW = size.width -labX;
    float labH = KMainScreenWidth>400?20:17;
    float lab1Y =size.height/2 - labH -2;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    float lab1font =(KMainScreenWidth>400?17:14);
    lab1.font = [UIFont systemFontOfSize:lab1font];
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    float lab1H = KMainScreenWidth>400?18:16;;
    float lab2Y = size.height/2+2;
    float lab2font =(KMainScreenWidth>400?16:13);
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab2.font = [UIFont systemFontOfSize:lab2font];
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [self addSubview:lab2];
    self.subLab = lab2;
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(imgX, size.height-1, size.width-2*imgX, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
