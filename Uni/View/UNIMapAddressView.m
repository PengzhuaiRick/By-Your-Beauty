//
//  UNIMapAddressView.m
//  Uni
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIMapAddressView.h"
#import "UNIShopManage.h"
@implementation UNIMapAddressView
-(id)init{
    self = [super init];
    if (self) {
        //self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        //self.backgroundColor = [UIColor clearColor];
        //[self setupUI];
    }
    return self;
}
-(void)setupUI{
    UILabel* lab = [[UILabel alloc]init];
    lab.text = [[UNIShopManage getShopData] address];
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>320?14:12];
    lab.textColor = [UIColor whiteColor];
    [lab sizeToFit];
    float labY =8;
    lab.frame = CGRectMake(10, labY, lab.frame.size.width, lab.frame.size.height);
    [self addSubview:lab];
    
    UIButton* but = [UIButton buttonWithType:UIButtonTypeCustom];
    but.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
    [but setTitle:@"导航" forState:UIControlStateNormal];
    [but setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    float btnX = CGRectGetMaxX(lab.frame)+5;
    but.frame = CGRectMake(btnX, 0, KMainScreenWidth*40/320, CGRectGetMaxY(lab.frame)+8);
    [self addSubview:but];
    _navBtn = but;
    [[_navBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         NSLog(@"sdafsdsgf");
     }];
    
    self.frame = CGRectMake(0, 0, CGRectGetMaxX(but.frame)+10, CGRectGetMaxY(but.frame));
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    
}


@end
