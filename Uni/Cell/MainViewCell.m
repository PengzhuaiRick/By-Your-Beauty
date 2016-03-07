//
//  MainViewCell.m
//  Uni
//
//  Created by apple on 15/12/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainViewCell.h"
#import "UNIMyAppintModel.h"
#import "UNIMyProjectModel.h"
#import "UNIHttpUrlManager.h"
@implementation MainViewCell

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    cellH = size.height;
    
    float imgX = 16;
   // float imgWH =KMainScreenWidth>400?50:40;
    float imgWH =size.height/3.5;
    float imgY = (size.height - imgWH)/2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    [self addSubview:img];
    self.mainImage = img;
    // self.mainImage.backgroundColor = [UIColor blackColor];
    
    float lab3WH = imgWH*0.6;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, lab3WH, lab3WH)];
    lab3.center = CGPointMake(imgWH-3, 3);
    lab3.textColor = [UIColor whiteColor];
    lab3.backgroundColor = [UIColor colorWithHexString:kMainThemeColor];
    lab3.text = @"";
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.layer.masksToBounds = YES;
    lab3.layer.cornerRadius = lab3WH/2;
    lab3.font = [UIFont systemFontOfSize:lab3WH/2];
    [img addSubview:lab3];
    self.numLab = lab3;
    
    float btnWH =KMainScreenWidth*70/414;
    float btnY = (size.height - btnWH)/2;
    float btnX = size.width - imgX - btnWH;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.lineBreakMode = 0;
    [btn setTitle:@"马上\n预约" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*18/414];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btnWH/2;
    btn.layer.borderColor = [UIColor colorWithHexString:kMainThemeColor].CGColor;
    btn.layer.borderWidth = 1;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor ] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    UIColor* col = [UIColor colorWithHexString:kMainThemeColor];
    [btn setBackgroundImage:[self createImageWithColor:col] forState:UIControlStateNormal ];
    btn.hidden = YES;
    [self addSubview:btn];
    self.handleBtn =  btn;
    
    float labX = CGRectGetMaxX(img.frame)+20;
    float labW = size.width -labX*2;
    float labH = KMainScreenWidth* 20/320;
    float lab1Y = size.height/2 - labH - 2;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*16/414];
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    float lab2Y = size.height/2 +2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, labH)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth*14/414];
    lab2.textColor =[UIColor colorWithHexString:kMainTitleColor];
    lab2.lineBreakMode = 0;
    lab2.numberOfLines = 0;
    [self addSubview:lab2];
    self.subLab = lab2;
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(16, size.height-1, size.width-32, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
   }
-(void)setupCellWithData:(id)data type:(int)type andTotal:(int)total{
   
    if (type == 1) {
        self.handleBtn.hidden = YES;
         UNIMyAppintModel* info = data[0];
        if (info) {
            self.numLab.hidden=NO;
            self.numLab.text = [NSString stringWithFormat:@"%d",total];
            self.mainImage.image = [UIImage imageNamed:@"main_img_cell1"];
            
            self.mainLab.text = info.projectName;
            NSString* str = [info.time substringWithRange:NSMakeRange(0, info.time.length - 3)];
            NSString* str1 = [str stringByReplacingOccurrencesOfString:@"-" withString:@"."];
            self.subLab .text = [NSString stringWithFormat:@"我已预约:%@",str1];
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            self.numLab.hidden=YES;
            self.mainImage.image = [UIImage imageNamed:@"main_img_nodata1"];
            self.mainLab.text = @"已约完!";
            self.subLab .text = [UNIHttpUrlManager sharedInstance].APPOINT_DESC;
            self.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    if (type == 2) {
         self.numLab.hidden = YES;
        self.accessoryType = UITableViewCellAccessoryNone;
         UNIMyProjectModel* info =(UNIMyProjectModel*) data;
        if (info) {
            self.handleBtn.hidden = NO;
            NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,info.logoUrl];
            [self.mainImage sd_setImageWithURL:[NSURL URLWithString:str]];
            self.mainLab.text = info.projectName;
            self.subLab .text = [NSString stringWithFormat:@"剩余%d次",info.num];
            
        }else{
            self.handleBtn.hidden = YES;
            self.mainImage.image = [UIImage imageNamed:@"main_img_nodata2"];
            self.mainLab.text = @"马上购买去!";
//            CGRect subR =self.subLab.frame;
//            subR.size.width = self.mainLab.frame.size.width;
//            self.subLab.frame = subR;
            self.subLab .text = @"空空如也没关系,\n一大波超值套餐正来袭";
        }
    }
    
    
    [self.mainLab sizeToFit];
    [self.subLab sizeToFit];
    
    CGRect mainLR = self.mainLab.frame;
    mainLR.origin.y = self.mainImage.center.y - mainLR.size.height - 2;
    self.mainLab.frame = mainLR;
    
   
}
- (void)awakeFromNib {
    // Initialization code
}
#pragma mark 颜色转图片
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
