//
//  UNIAddAndDelectCell.m
//  Uni
//
//  Created by apple on 16/3/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIAddAndDelectCell.h"
#import "UNIMyProjectModel.h"
@implementation UNIAddAndDelectCell
-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}

-(void)setupUI:(CGSize)size{
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(size.width - size.height, 0, size.height, size.height);
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    btn.enabled = NO;
    btn.backgroundColor = [UIColor colorWithHexString:kMainThemeColor];
    [self addSubview:btn];
    _delectBtn = btn;
   
    
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = [UIColor whiteColor];
    view.multipleTouchEnabled=YES;
    [self addSubview:view];
    _moveView = view;
    
    
    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureRecognizer:)];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [view addGestureRecognizer:swipe];
    
    
    UISwipeGestureRecognizer* swipe1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureRecognizer:)];
     swipe1.direction = UISwipeGestureRecognizerDirectionRight;
    [view addGestureRecognizer:swipe1];
    
    
    float imgX = KMainScreenWidth>400?20:16;
    float imgY = 8;
    float imgWH =size.height - imgY*2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    // img.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:img];
    self.mainImg = img;
    
    
    float labX = CGRectGetMaxX(img.frame)+15;
    float labW = size.width -labX;
    float labH = KMainScreenWidth>400?20:17;
    float lab1Y =size.height/2 - labH -2;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    float lab1font =(KMainScreenWidth>400?17:14);
    lab1.font = [UIFont systemFontOfSize:lab1font];
    [view addSubview:lab1];
    self.mainLab = lab1;
    
    
    float lab1H = KMainScreenWidth>400?18:16;;
    float lab2Y = size.height/2+2;
    float lab2font =(KMainScreenWidth>400?16:13);
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, lab1H)];
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab2.font = [UIFont systemFontOfSize:lab2font];
    lab2.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [view addSubview:lab2];
    self.subLab = lab2;
    
    CALayer* LAY = [CALayer layer];
    LAY.frame = CGRectMake(imgX, size.height-1, size.width-2*imgX, 1);
    LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
    [view.layer addSublayer:LAY];
    LAY=nil;
    view=nil;lab2=nil;lab1=nil;img=nil;swipe1=nil;swipe=nil; btn=nil;

}


-(void)swipeGestureRecognizer:(UISwipeGestureRecognizer*)swipe{
    float x = 0;
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        x = 0;
        self.delectBtn.enabled = NO;
    }
    if (swipe.direction ==UISwipeGestureRecognizerDirectionLeft) {
        x = - _delectBtn.frame.size.height;
        self.delectBtn.enabled = YES;
    }
    CGRect moveR = _moveView.frame;
    moveR.origin.x = x;
    [UIView animateWithDuration:0.2 animations:^{
        self.moveView.frame = moveR;
    }];

}

-(void)setupCellContent:(id)model1{
    UNIMyProjectModel* model = model1;
    NSString* imgUrl = model.logoUrl;
    NSArray* arr = [model.logoUrl componentsSeparatedByString:@","];
    if (arr.count>0)
        imgUrl = arr[0];
    
   // NSString* str = [NSString stringWithFormat:@"%@%@",API_IMG_URL,imgUrl];
    [self.mainImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                    placeholderImage:nil];
    
    self.mainLab.text = model.projectName;
    self.subLab.text = [NSString stringWithFormat:@"服务时长%d分钟",model.costTime];
    
    CGRect moveR = _moveView.frame;
    moveR.origin.x = 0;
    self.moveView.frame = moveR;
    
    model=nil;
    imgUrl=nil;
    arr=nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
