//
//  UNIAppointDetail2Cell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetail2Cell.h"

@implementation UNIAppointDetail2Cell

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    
    float imgX = 16;
    float imgWH =KMainScreenWidth>400?25:20;
    float imgY = (size.height-imgWH)/2;
    
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    img.image =[UIImage imageNamed:@"appoint_img_pin"];
    [self addSubview:img];
    self.mainImg = img;
   
    
     //UNIShopManage* manager = [UNIShopManage getShopData];
    
    float labX = CGRectGetMaxX(img.frame)+10;
    float labW = size.width - labX;
    float labH = KMainScreenWidth>400?19:14;
    float labY = size.height/2 - labH - 2;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, labY, labW, labH)];
   // lab1.text = manager.shortName;
    lab1.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:12];
    lab1.lineBreakMode = 0 ;
    lab1.numberOfLines = 0;
    [self addSubview:lab1];
    self.label1 = lab1;
    
    
    float lab2H = KMainScreenWidth>400?18:13;
    float lab2Y =  size.height/2 +2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab2H)];
    //lab2.text =manager.address;
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>400?14:11];
    lab2.lineBreakMode = 0 ;
    lab2.numberOfLines = 0;
    [self addSubview:lab2];
    _label2 =  lab2;
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(imgX, size.height-1, size.width-2*imgX, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
    LAY=nil;  img = nil; lab1=nil; lab2=nil;
}

-(void)setupCellContentWithName:(NSString*)name andAdress:(NSString*)adress{
    self.label1.text = name;
    self.label2.text = adress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
