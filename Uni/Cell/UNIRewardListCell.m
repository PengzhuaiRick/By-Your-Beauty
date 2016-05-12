//
//  UNIRewardListCell.m
//  Uni
//
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardListCell.h"
#import "UNIRewardListModel.h"
@implementation UNIRewardListCell
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    
    float imgX = 16;
    float imgY = KMainScreenWidth* 10 /320;
    float imgWH =size.height - imgY*2;
    
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImg = img;
//    [self.mainImg sd_setImageWithURL:nil
//                    placeholderImage:[UIImage imageNamed:@"evaluete_img_reward"]];
    
    
    float lab3WH = KMainScreenWidth*70/414;
    float lab3Y =(size.height - lab3WH)/2;
    float lab3X = size.width - imgX - lab3WH;
//    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab3Y, lab3WH, lab3WH)];
//    lab3.textColor = [UIColor colorWithHexString:kMainTitleColor];
//    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
//    lab3.textColor = [UIColor whiteColor];
//    lab3.textAlignment = NSTextAlignmentCenter;
//    lab3.lineBreakMode = 0;
//    lab3.numberOfLines = 0;
//    lab3.layer.masksToBounds = YES;
//    lab3.layer.cornerRadius = lab3WH/2;
//    [self addSubview:lab3];
//    self.stateBtn = lab3;
//    self.stateBtn.text= @"到店\n领取";
//    [self.stateBtn setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(lab3X, lab3Y, lab3WH, lab3WH);
    btn.titleLabel.font =[UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    btn.titleLabel.lineBreakMode = 0;
    btn.titleLabel.numberOfLines = 0;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = lab3WH/2;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor colorWithHexString:kMainThemeColor].CGColor;
    [self addSubview:btn];
    self.stateBtn = btn;

    
    float labX = CGRectGetMaxX(img.frame)+5;
    float labW = size.width -2*imgX -lab3WH - imgWH;
    float labH = size.height/2;
    float lab1Y = 0;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
   // lab1.text = @"ALBION 爽肤精体液";
    [self addSubview:lab1];
    self.label1 = lab1;
    
    float lab1H = KMainScreenWidth*17/320;
    float lab2Y = size.height/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>400?14:12];
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    //lab2.text = @"规格: 330ml       x1";
    [self addSubview:lab2];
    self.label2 = lab2;
    

    float lab4Y = CGRectGetMaxY(lab2.frame);
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab4Y, labW, lab1H)];
    lab4.font = [UIFont systemFontOfSize:KMainScreenWidth>400?14:12];
    lab4.textColor = [UIColor colorWithHexString:kMainThemeColor];
   // lab4.text = @"9-21 15:20";
    [self addSubview:lab4];
    
    self.label3 = lab4;
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(imgX, size.height-1, size.width-2*imgX, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
    
    LAY=nil; lab4=nil; lab2=nil; lab1=nil;  img=nil;
}


-(void)setupCellContentWith:(id)model{
    UNIRewardListModel* info = model;
    NSString* imgUrl = info.logoUrl;
    NSArray* arr = [info.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                    placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
    self.label1.text =info.projectName;
    self.label2.text =[NSString stringWithFormat:@"规格: %@     x%d",info.specifications,info.num];
    self.label3.text = [info.time substringWithRange:NSMakeRange(5, 11)];
    
    if (info.status==0) {
        //         self.stateBtn.text= @"到店\n领取";
        self.stateBtn.enabled=YES;
        self.stateBtn.layer.borderWidth = 1;
        //[self.stateBtn setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
        [self.stateBtn setTitle:@"到店\n领取" forState:UIControlStateNormal];
        [self.stateBtn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateNormal];
    }else{
        // self.stateBtn.text= @"已领取";
        self.stateBtn.enabled=NO;
        self.stateBtn.layer.borderWidth = 0;
        [self.stateBtn setTitle:@"已领取" forState:UIControlStateNormal];
        [self.stateBtn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainTitleColor]] forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

@end
