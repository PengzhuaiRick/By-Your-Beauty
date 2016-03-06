//
//  UNIShopListCell.m
//  Uni
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIShopListCell.h"
#import "UNIShopModel.h"

@implementation UNIShopListCell
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    float imgX = KMainScreenWidth>320?20:16;
//    float imgY = 15;
//    float imgWH =size.height - imgY*2;
//    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
//    //img.contentMode = UIViewContentModeScaleAspectFit;
//    [self addSubview:img];
//    self.mainImage = img;
    
    
//    float labX = CGRectGetMaxX(img.frame)+10;
//    float labW = size.width - labX-2*imgX;
    float labX = 16;
    float labW = size.width - labX-2*labX;
    float labH = KMainScreenWidth* 15/320;
    float lab1Y = size.height/2 - labH-2;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor blackColor];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*16/414];
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    float lab1H = KMainScreenWidth*20/414;
    float lab2Y = size.height/2-2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth*15/414];
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [self addSubview:lab2];
    self.subLab = lab2;
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(labX, size.height-1, size.width-2*labX, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [self.layer addSublayer:LAY];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


-(void)setupCellContent:(id)model{
    UNIShopModel* info = model;
    NSString* sre = [NSString stringWithFormat:@"%@%@",API_IMG_URL,info.logoUrl];
    [self.mainImage sd_setImageWithURL:[NSURL URLWithString:sre]];
    self.mainLab.text = info.shortName;
    self.subLab.text = info.address;
    [self.subLab sizeToFit];
    
}


@end
