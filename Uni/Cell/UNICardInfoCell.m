//
//  UNICardInfoCell.m
//  Uni
//
//  Created by apple on 15/12/3.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNICardInfoCell.h"
#import "UNIMyAppointInfoModel.h"
@implementation UNICardInfoCell
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    
    float imgXY = 16;
    float imgWH =size.height - imgXY*2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgXY, imgXY, imgWH, imgWH)];
    //img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImage = img;
    
    
    float itW = KMainScreenWidth>400?50:45;
    float itH = KMainScreenWidth>400?55:50;
    float itX = size.width - imgXY - itW;
    float itY = (size.height - itH)/2;
    UIImageView* itImg = [[UIImageView alloc]initWithFrame:CGRectMake(itX, itY, itW, itH)];
    itImg.image = [UIImage imageNamed:@"appoint_img_intime"];
    itImg.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:itImg];
    self.img2 = itImg;
    
    
    float labX = CGRectGetMaxX(img.frame)+10;
    float labW = size.width - labX-imgXY - itW;
    float labH = KMainScreenWidth>400?20:17;
    float lab1Y = size.height/2 - labH - 2;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:13];
    lab1.numberOfLines = 0;
    lab1.lineBreakMode = 0;
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    
    float lab1H = KMainScreenWidth>400?19:16;
    float lab2Y = size.height/2+2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:12];
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [self addSubview:lab2];
    self.subLab = lab2;
    
    
    float lab3W = itW;
    float lab3X = itX;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab2Y, lab3W, lab1H)];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:12];
    lab3.textAlignment = NSTextAlignmentCenter;
    [self addSubview:lab3];
    self.stateLab = lab3;
   
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(imgXY, size.height-1, size.width-2*imgXY, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
    LAY=nil; img=nil;  lab3=nil; lab2=nil; lab1=nil; itImg=nil;
}


-(void)setupCellContentWith:(id)model{
    UNIMyAppointInfoModel* info = model;
    NSString* imgUrl = info.logoUrl;
    NSArray* arr = [info.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    //NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgUrl];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                      placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    self.mainLab.text = info.projectName;
    [self.mainLab sizeToFit];
    CGRect mR = self.mainLab.frame;
    mR.origin.y = self.mainImage.center.y - mR.size.height - 2;
    self.mainLab.frame = mR;
    
    NSString* text2 = [info.date substringWithRange:NSMakeRange(5, 11)];
    self.subLab.text = text2;
    NSString* titel = nil;
    switch (info.status) {
//        case 0:
//            titel = @"待确认";
//            break;
//        case 1:
//            titel = @"待服务";
//            break;
        case 2:{
            titel = @"已完成";
            self.stateLab.textColor = [UIColor colorWithHexString:kMainThemeColor];
        }
            break;
        case 3:{
            self.stateLab.textColor = [UIColor colorWithHexString:kMainTitleColor];
            titel = @"已取消";
        }
            break;
    }
    self.stateLab.text = titel;

    
    if (info.ifIntime == 0) {
        self.img2.hidden=YES;
        self.stateLab.hidden =NO;
    }else{
        self.img2.hidden=NO;
        self.stateLab.hidden =YES;
    }
    imgUrl=nil;
    arr = nil;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
