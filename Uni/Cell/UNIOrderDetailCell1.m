//
//  UNIOrderDetailCell.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderDetailCell1.h"
#import "UNIOrderListModel.h"
@implementation UNIOrderDetailCell1

-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    float imgXY =16;
    float imgWH = size.height - 2*imgXY;
    UIImageView* img= [[UIImageView alloc]initWithFrame:CGRectMake(imgXY, imgXY, imgWH, imgWH)];
    //img.image = [UIImage imageNamed:@"card_img_bg2"];
    //img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImg = img;

    
    float lab1X = CGRectGetMaxX(img.frame)+5;
    float lab1W = size.width - lab1X -2*imgXY -KMainScreenWidth*60/320;
    float lab1H = size.height/2;
    float lab1Y = 0;
   
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab1Y, lab1W, lab1H)];
    lab1.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    lab1 .font =[UIFont systemFontOfSize:KMainScreenWidth>400?17:14];
    lab1.numberOfLines = 0;
    lab1.lineBreakMode = 0;
    [self addSubview:lab1];
    self.lab1 = lab1;
    
    
    
    float lab2W = KMainScreenWidth*60/320;
    float lab2X = size.width - lab2W - imgXY;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab1Y, lab2W, lab1H)];
    lab2.textColor =[UIColor colorWithHexString:kMainTitleColor];
    lab2.textAlignment=NSTextAlignmentRight;
    lab2 .font =[UIFont systemFontOfSize:KMainScreenWidth>400?16:13];
    [self addSubview:lab2];
    self.lab2 = lab2;
    
    float lab3Y = size.height/2;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab3Y, lab1W, lab1H)];
    lab3.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab3 .font =[UIFont systemFontOfSize:KMainScreenWidth>400?14:12];
    [self addSubview:lab3];
    self.lab3 = lab3;
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(imgXY, size.height-1, size.width-2*imgXY, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
}
-(void)setupCellContent:(id)model{
    UNIOrderListModel*info = model;
    NSString* imgUrl = info.logoUrl;
    NSArray* arr = [info.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    
    NSString* url = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgUrl];
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    self.lab1.text =info.projectName;
    self.lab2.text = [NSString stringWithFormat:@"￥%@",info.price];
    self.lab3.text = [NSString stringWithFormat:@"数量 x%d",info.num];
}

@end
