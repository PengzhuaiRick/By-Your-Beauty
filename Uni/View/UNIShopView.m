//
//  UNIShopView.m
//  Uni
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIShopView.h"
#import "AccountManager.h"


@implementation UNIShopView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        _shopId = [[AccountManager shopId]intValue];
    }
    return self;
}
-(void)setupUI{
    UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"appoint_img_pin"]];
    img.contentMode = UIViewContentModeScaleAspectFit;
    float imgWH = KMainScreenWidth>400?25:20,
    imgY = (self.frame.size.height - imgWH)/2,
    imgX=KMainScreenWidth>400?30:25;
    img.frame = CGRectMake(imgX, imgY, imgWH, imgWH);
    [self addSubview:img];
    
    float lab1X = CGRectGetMaxX(img.frame)+5;
    float lab1H = KMainScreenWidth>400?22:18;
    float lab1Y = self.frame.size.height/2 - lab1H-2;
    float lab1W = self.frame.size.width - lab1X  - 10;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab1Y, lab1W, lab1H)];
    lab1.text = [UNIShopManage getShopData].shopName;
    lab1.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    lab1.font = [UIFont systemFontOfSize:(KMainScreenWidth>400?16:14)];
    [self addSubview:lab1];
    _nameLab = lab1;
    
    float lab2Y = self.frame.size.height/2 +2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab2Y, lab1W, lab1H)];
    lab2.text = [UNIShopManage getShopData].address;
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab2.font = [UIFont systemFontOfSize:(KMainScreenWidth>400?15:13)];
    [self addSubview:lab2];
    _addressLab = lab2;
    
    img=nil;  lab1=nil;lab2=nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
