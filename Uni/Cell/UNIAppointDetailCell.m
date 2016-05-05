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
   // img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImage = img;
    
    float itW = KMainScreenWidth>400?50:45;
    float itH = KMainScreenWidth>400?55:50;
    float itX = size.width - imgX - itW;
    float itY = (size.height - itH)/2;
    UIImageView* itImg = [[UIImageView alloc]initWithFrame:CGRectMake(itX, itY, itW, itH)];
    itImg.image = [UIImage imageNamed:@"appoint_img_intime"];
    //itImg.hidden=YES;
    itImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:itImg];
    self.intimeImg = itImg;
   
    
    float labX = CGRectGetMaxX(img.frame)+10;
    float labW = size.width - labX-2*imgX -itW;
    float labH = size.height/2 ;
    float lab1Y = 0;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
//lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>400?17:14];
    lab1.lineBreakMode = 0 ;
    lab1.numberOfLines = 0;
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    
    float lab1H = KMainScreenWidth*17/320;
    float lab2Y = size.height/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:13];
    lab2.textColor = [UIColor colorWithHexString:kMainThemeColor];
    [self addSubview:lab2];
    self.subLab = lab2;
   
    
    float lab3Y = CGRectGetMaxY(lab2.frame);
    float lab3W = KMainScreenWidth*50/320;
    float lab3X = size.width - imgX- lab3W;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab3Y, lab3W, lab1H)];
     lab3.textColor = [UIColor colorWithHexString:kMainThemeColor];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:13];
    [self addSubview:lab3];
    self.stateLab = lab3;
   
    
    float lab4W = KMainScreenWidth*150/320;
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab3Y, lab4W, lab1H)];
    lab4.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab4.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:13];
    [self addSubview:lab4];
    self.timeLab = lab4;
   
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(imgX, size.height-1, size.width-2*imgX, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
    LAY=nil; img = nil; lab4=nil;  lab3=nil;  lab2=nil;lab1=nil; itImg = nil;
    
}

-(void)setupCellContentWith:(id)model{
    UNIMyAppointInfoModel* info = model;
     //NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,info.url];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:info.url] placeholderImage:nil];
    self.mainLab.text = info.projectName;
    self.subLab.text = [NSString stringWithFormat:@"预约时间 : %@",[info.date substringToIndex:16]];
    self.timeLab.text =[NSString stringWithFormat:@"服务时长 : %d分钟",info.costTime ];
   // str=nil;
    
    NSString* titel = nil;
    UIColor* stateColor = nil;
    switch (info.status) {
        case 0:
            titel = @"待确认";
            stateColor = [UIColor colorWithHexString:kMainTitleColor];
            break;
        case 1:
            titel = @"待服务";
            stateColor = [UIColor colorWithHexString:kMainThemeColor];
            break;
        case 2:
            titel = @"已完成";
            stateColor = [UIColor colorWithHexString:kMainThemeColor];
            break;
        case 3:
            titel = @"已取消";
            stateColor = [UIColor colorWithHexString:kMainBackGroundColor];
            break;
    }
    self.stateLab.text = titel;
    self.stateLab.textColor = stateColor;
    
    if (info.ifIntime == 1) {
        self.intimeImg.hidden=NO;
        self.stateLab.hidden=YES;
        
        CGRect mainR = self.mainLab.frame;
        mainR.size.width = cellS.width - mainR.origin.x -16 - self.intimeImg.frame.size.width;
        self.mainLab.frame = mainR;
        
        CGRect subR = self.subLab.frame;
        subR.size.width = cellS.width - subR.origin.x - 16 - self.intimeImg.frame.size.width;
        self.subLab.frame = subR;

        
    }else if (info.ifIntime == 0){
        self.intimeImg.hidden=YES;
        self.stateLab.hidden=NO;
        
        CGRect mainR = self.mainLab.frame;
        mainR.size.width = cellS.width - mainR.origin.x -16;
        self.mainLab.frame = mainR;
        
        CGRect subR = self.subLab.frame;
        subR.size.width = cellS.width - subR.origin.x - 16;
        self.subLab.frame = subR;
        
    }
    
}
-(void)setupCellContentWith1:(id)model{
    UNIMyAppointInfoModel* info = model;
   // NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,info.url];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:info.url] placeholderImage:nil];
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
    
    if (info.ifIntime == 1) {
        self.intimeImg.hidden=NO;
        self.stateLab.hidden=YES;
        CGRect mainR = self.mainLab.frame;
        mainR.size.width = cellS.width - mainR.origin.x -16 - self.intimeImg.frame.size.width;
        self.mainLab.frame = mainR;
        
        CGRect subR = self.subLab.frame;
        subR.size.width = cellS.width - subR.origin.x - 16 - self.intimeImg.frame.size.width;
        self.subLab.frame = subR;
        
    }else if (info.ifIntime == 0){
        self.intimeImg.hidden=YES;
        self.stateLab.hidden=NO;
        
        CGRect mainR = self.mainLab.frame;
        mainR.size.width = cellS.width - mainR.origin.x -16;
        self.mainLab.frame = mainR;
        
        CGRect subR = self.subLab.frame;
        subR.size.width = cellS.width - subR.origin.x - 16;
        self.subLab.frame = subR;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
