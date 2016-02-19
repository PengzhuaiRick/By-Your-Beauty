//
//  MainMidCell.m
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMidCell.h"
@implementation MainMidCell


-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
     self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    float imgX = KMainScreenWidth* 16 /320;
    float imgY = KMainScreenWidth* 15 /320;
    float imgWH =size.height - imgY*2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImage = img;
    
    
    float labX = CGRectGetMaxX(img.frame)+10;
    float labW = size.width - labX-2*imgX;
    float labH = size.height/2 - imgY;
    float lab1Y = imgY;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*15/320];
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    float lab1H = KMainScreenWidth*17/320;
    float lab2Y = size.height/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    lab2.textColor = kMainGrayBackColor;
    [self addSubview:lab2];
    self.subLab = lab2;
    
    float lab3Y = CGRectGetMaxY(lab2.frame);
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab3Y, labW, lab1H)];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    [self addSubview:lab3];
    self.stateLab = lab3;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


-(void)setupCellContent:(id)model1 andType:(int)type{

    if (type == 1) {
        UNIMyAppintModel* model = model1;
        NSString* imgUrl = model.logoUrl;
        NSArray* arr = [model.logoUrl componentsSeparatedByString:@","];
        if (arr.count>0)
            imgUrl = arr[0];
        NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgUrl];
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:str]
                          placeholderImage:[UIImage imageNamed:@"main_img_cell1"]];
        self.mainLab.text = model.projectName;
        
        NSString* time = [model.time substringToIndex:model.time.length-3];
        NSString* str1 = [time stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.subLab .text =str1;
        
        NSString* btnTitle = @"";
        switch (model.status) {
            case 0:
                btnTitle = @"待确认";
                self.stateLab.textColor =kMainGrayBackColor;
                break;
            case 1:
                btnTitle = @"待服务";
                self.stateLab.textColor = [UIColor colorWithHexString:kMainThemeColor];
                break;
            case 2:
                btnTitle = @"已完成";
                break;
            case 3:
                btnTitle = @"已取消";
                break;
        }
        self.stateLab.text = btnTitle;
    }
    if (type == 2) {
        UNIMyProjectModel* model = model1;
        NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,model.logoUrl];
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:str]
                          placeholderImage:[UIImage imageNamed:@"main_img_cell1"]];
        self.mainLab.text = model.projectName;
        self.subLab .text =[NSString stringWithFormat:@"剩余%d次",model.num];

    }
}

//-(void)setAppointCell:(id)model and:(int)num and:(int)type{
//    UNIMyRewardModel* info = model;
//        if (type==1){
//        self.mainLab.text = [NSString stringWithFormat:@"%d次",info.rewardNum];
//        self.mainImage.image = [UIImage imageNamed:@"evaluete_img_reward"];
//    }
//    else{
//        self.mainLab.text = [NSString stringWithFormat:@"准时到店满%d次",info.rewardNum];
//        self.mainImage.image = [UIImage imageNamed:@"card_img_ITreward"];
//    }
//    self.subLab.text = info.goods;
//}

@end
