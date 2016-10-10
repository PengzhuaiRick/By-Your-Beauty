//
//  UNIAppointDetailCell.m
//  Uni
//
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetailCell.h"
#import "UNIMyAppointInfoModel.h"
@implementation UNIAppointDetailCell
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        cellS = cellSize;
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    
    float imgX = 16;
    float imgY = KMainScreenWidth* 16 /320;
    float imgWH =size.height - imgY*2;
    
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImage = img;
    
//    float itW = KMainScreenWidth>400?50:45;
//    float itH = KMainScreenWidth>400?55:50;
//    float itX = size.width - imgX - itW;
//    float itY = (size.height - itH)/2;
//    UIImageView* itImg = [[UIImageView alloc]initWithFrame:CGRectMake(itX, itY, itW, itH)];
//    itImg.image = [UIImage imageNamed:@"appoint_img_intime"];
//    //itImg.hidden=YES;
//    itImg.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:itImg];
//    self.intimeImg = itImg;
    
    
    float lab3WH = KMainScreenWidth*58/414;
    float lab3Y =  (size.height - lab3WH)/2;
    float lab3X = size.width - imgX- lab3WH;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab3Y, lab3WH, lab3WH)];
    lab3.textColor = [UIColor colorWithHexString:kMainThemeColor];
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.font = kWTFont(15);
    lab3.layer.masksToBounds = YES;
    lab3.layer.cornerRadius = lab3WH/2;
    lab3.layer.borderWidth =1;
    [self addSubview:lab3];
    self.stateLab = lab3;
   
    
    float labX = CGRectGetMaxX(img.frame)+10;
    float labW = size.width - labX-2*imgX -lab3WH;
    float labH = size.height/2 ;
    float lab1Y = 0;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
//lab1.textColor = [UIColor blackColor];
    lab1.font = kWTFont(15);
    lab1.lineBreakMode = 0 ;
    lab1.numberOfLines = 0;
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    
    float lab1H = KMainScreenWidth*17/320;
    float lab2Y = size.height/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.font = kWTFont(14);
    lab2.textColor = [UIColor colorWithHexString:kMainPinkColor];
    [self addSubview:lab2];
    self.subLab = lab2;
   
    
    float lab4W = KMainScreenWidth*150/320;
    float lab4Y =CGRectGetMaxY(lab2.frame);
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab4Y, lab4W, lab1H)];
    lab4.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab4.font = kWTFont(15);
    [self addSubview:lab4];
    self.timeLab = lab4;
   
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(imgX, size.height-1, size.width-2*imgX, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
    
}

-(void)setupCellContentWith:(id)model{
    UNIMyAppointInfoModel* info = model;
     //NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,info.url];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:info.url]
                      placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    self.mainLab.text = info.projectName;
    self.subLab.text = [NSString stringWithFormat:@"预约时间 : %@",[info.date substringToIndex:16]];
    self.timeLab.text =[NSString stringWithFormat:@"服务时长 : %d分钟",info.costTime ];
   // str=nil;
    
    NSString* titel = nil;
    UIColor* stateColor = nil;
    switch (info.status) {
        case 0:
            titel = @"待确认";
            stateColor = [UIColor colorWithHexString:@"955fce"];
            break;
        case 1:
            titel = @"待服务";
            stateColor = [UIColor colorWithHexString:kMainPinkColor];
            break;
        case 2:
            titel = @"已完成";
            stateColor = [UIColor colorWithHexString:@"b38951"];
            break;
        case 3:
            titel = @"已取消";
            stateColor = [UIColor colorWithHexString:kMainBackGroundColor];
            break;
    }
    if (info.ifIntime == 1) {
        titel = @"准时";
        stateColor = [UIColor colorWithHexString:kMainPinkColor];
    }
    
    self.stateLab.text = titel;
    self.stateLab.textColor = stateColor;
    self.stateLab.layer.borderColor =stateColor.CGColor;
    
}
-(void)setupCellContentWith1:(id)model{
    UNIMyAppointInfoModel* info = model;
   // NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,info.url];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:info.url]
                      placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    self.mainLab.text = info.projectName;
    self.subLab.text = [NSString stringWithFormat:@"预约时间 : %@",[info.date substringToIndex:16]];
    self.timeLab.text =[NSString stringWithFormat:@"服务时长 : %d分钟",info.costTime ];
    //str=nil;
    NSString* titel = @"";
    UIColor* stateColor = nil;
    switch (info.status) {
        case 2:
            titel = @"已完成";
            stateColor = [UIColor colorWithHexString:kMainThemeColor];
            break;
        case 3:
            titel = @"已取消";
            stateColor = [UIColor colorWithHexString:kMainTitleColor];
            break;
    }
    self.stateLab.text = titel;
    self.stateLab.textColor = stateColor;
    
//    if (info.ifIntime == 1) {
//        self.intimeImg.hidden=NO;
//        self.stateLab.hidden=YES;
//        CGRect mainR = self.mainLab.frame;
//        mainR.size.width = cellS.width - mainR.origin.x -16 - self.intimeImg.frame.size.width;
//        self.mainLab.frame = mainR;
//        
//        CGRect subR = self.subLab.frame;
//        subR.size.width = cellS.width - subR.origin.x - 16 - self.intimeImg.frame.size.width;
//        self.subLab.frame = subR;
//        
//    }else if (info.ifIntime == 0){
//        self.intimeImg.hidden=YES;
//        self.stateLab.hidden=NO;
//        
//        CGRect mainR = self.mainLab.frame;
//        mainR.size.width = cellS.width - mainR.origin.x -16;
//        self.mainLab.frame = mainR;
//        
//        CGRect subR = self.subLab.frame;
//        subR.size.width = cellS.width - subR.origin.x - 16;
//        self.subLab.frame = subR;
//    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
