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
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    
    float imgX = KMainScreenWidth* 10 /320;
    float imgY = KMainScreenWidth* 16 /320;
    float imgWH =size.height - imgY*2;
    
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImage = img;
    
    float itW = KMainScreenWidth* 40/320;
    float itH = KMainScreenWidth* 45/320;
    float itX = size.width - imgX - itW;
    float itY = (size.height - itH)/2;
    UIImageView* itImg = [[UIImageView alloc]initWithFrame:CGRectMake(itX, itY, itW, itH)];
    itImg.image = [UIImage imageNamed:@"appoint_img_intime"];
    itImg.hidden=YES;
    [self addSubview:itImg];
    self.intimeImg = itImg;
    
    float labX = CGRectGetMaxX(img.frame)+10;
    float labW = size.width - labX-2*imgX -itW;
    float labH = size.height/2 ;
    float lab1Y = 0;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>320?17:14];
    lab1.lineBreakMode = 0 ;
    lab1.numberOfLines = 0;
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    float lab1H = KMainScreenWidth*17/320;
    float lab2Y = size.height/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>320?16:13];
    lab2.textColor = [UIColor colorWithHexString:kMainThemeColor];
    [self addSubview:lab2];
    self.subLab = lab2;
    
    float lab3Y = CGRectGetMaxY(lab2.frame);
    float lab3W = KMainScreenWidth*50/320;
    float lab3X = size.width - imgX- lab3W;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab3Y, lab3W, lab1H)];
     lab3.textColor = [UIColor colorWithHexString:kMainThemeColor];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth>320?16:13];
    [self addSubview:lab3];
    self.stateLab = lab3;
    
    float lab4W = KMainScreenWidth*150/320;
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab3Y, lab4W, lab1H)];
    lab4.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab4.font = [UIFont systemFontOfSize:KMainScreenWidth>320?16:13];
    [self addSubview:lab4];
    self.timeLab = lab4;
    
}

-(void)setupCellContentWith:(id)model{
    UNIMyAppointInfoModel* info = model;
     NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,info.url];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"function_img_scell4"]];
    self.mainLab.text = info.projectName;
    self.subLab.text = [NSString stringWithFormat:@"预约时间 : %@",[info.createTime substringToIndex:16]];
    self.timeLab.text =[NSString stringWithFormat:@"服务时长 : %d分钟",info.costTime ];
    NSString* titel = nil;
    UIColor* stateColor = nil;
    switch (info.status) {
        case 0:
            titel = @"待确认";
            stateColor = [UIColor blackColor];
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
    }else if (info.ifIntime == 0){
        self.intimeImg.hidden=YES;
        self.stateLab.hidden=NO;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
