//
//  MainMidCell.m
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMidCell.h"
#import <CoreText/CoreText.h>
@implementation MainMidCell


-(id)initWithCellSize:(CGSize)cellSize reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:0 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI:cellSize];
    }
    return self;
}
-(void)setupUI:(CGSize)size{
    float imgX = 8;
    float imgY = KMainScreenWidth* 8 /320;
    float imgWH =size.height - imgY*2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:img];
    self.mainImage = img;
    
    float btnX = size.width - 8 - imgWH;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, imgY, imgWH, imgWH);
    [self addSubview:btn];
    self.handleBtn =  btn;
    
    float labX = CGRectGetMaxX(img.frame);
    float labW = size.width - CGRectGetMaxX(img.frame)*2;
    float labH = KMainScreenWidth* 17/320;
    float lab1Y = size.height/2 - labH;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab1Y, labW, labH)];
    lab1.textColor = [UIColor colorWithHexString:@"ee4c7d"];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
    [self addSubview:lab1];
    self.mainLab = lab1;
    
    float lab2Y = size.height/2;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(labX, lab2Y, labW, labH)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
    [self addSubview:lab2];
    self.subLab = lab2;
    
}
- (void)awakeFromNib {
    self.mainLab.textColor = [UIColor colorWithHexString:@"ee4c7d"];
    self.mainLab.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
    self.subLab.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
    self.mainImage.contentMode = UIViewContentModeScaleAspectFit;
   }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)updateFrame:(CGRect)re{
   
    int uiX = 8;
    int uiY = 8;
    _mainImage.frame = CGRectMake(uiX, uiY, CELLH-uiY*2, CELLH-uiY*2);
    
    _handleBtn.frame = CGRectMake(re.size.width-uiX- (CELLH-uiY*2),
                                  uiY, CELLH-uiY*2, CELLH-uiY*2);
    
    float mainLabW = re.size.width-(CELLH-uiY*2)*2-uiX*2;
    float mainLabH = CELLH/2-8;
    _mainLab.frame = CGRectMake(CGRectGetMaxX(_mainImage.frame)+10, 8, mainLabW, mainLabH);
    
    _subLab.frame = CGRectMake(CGRectGetMaxX(_mainImage.frame)+10, CGRectGetMaxY(_mainLab.frame)+8, mainLabW, mainLabH);

}
-(void)setupCellContent:(id)model1 andType:(int)type{
    if (type==1) {
        UNIMyAppintModel* model = model1;
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]
                          placeholderImage:[UIImage imageNamed:@"main_img_cell1"]];
        self.mainLab.text = model.projectName;
        NSString* time = [model.time substringToIndex:model.time.length-3];
        
        NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:time];
        long number = KMainScreenWidth* 2/320;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
        [attributedString addAttribute:(NSString*)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attributedString length])];
        self.subLab.attributedText = attributedString;

        NSString* btnTitle = @"";
        switch (model.status) {
            case 0:
                btnTitle = @"待确认";
                break;
            case 1:
                btnTitle = @"待服务";
                break;
            case 2:
                btnTitle = @"已完成";
                break;
            case 3:
                btnTitle = @"已取消";
                break;
        }
        [self.handleBtn setTitle:btnTitle forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:[UIColor colorWithHexString:kMainTitleColor] forState:UIControlStateNormal];
        self.handleBtn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*0.036];
        [self.handleBtn setBackgroundImage:[UIImage imageNamed:@"main_btn_cell1"] forState:UIControlStateNormal];
    }
    else if (type == 2){
        UNIMyProjectModel* model = model1;
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:model.logoUrl]
                          placeholderImage:[UIImage imageNamed:@"main_img_cell1"]];
        self.mainLab.text = model.projectName;
        
        self.subLab.text = [NSString stringWithFormat:@"剩余次数             %i次",model.num];
        
        [self.handleBtn setTitle:@"马上\n预约" forState:UIControlStateNormal];
        [self.handleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.handleBtn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*0.035];
        self.handleBtn.titleLabel.numberOfLines = 0;
        self.handleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.handleBtn setBackgroundImage:[UIImage imageNamed:@"appoint_btn_sure"] forState:UIControlStateNormal];
       
    }
}

-(void)setAppointCell:(id)model and:(int)num and:(int)type{
    UNIMyRewardModel* info = model;
    [self.handleBtn setBackgroundImage:[UIImage imageNamed:@"main_btn_cell1"] forState:UIControlStateNormal];
    [self.handleBtn setTitle:[NSString stringWithFormat:@"%d次",num] forState:UIControlStateNormal];
    
    if (type==1){
        self.mainLab.text = [NSString stringWithFormat:@"预约成功满%d次",info.rewardNum];
        self.mainImage.image = [UIImage imageNamed:@"evaluete_img_reward"];
    }
    else{
        self.mainLab.text = [NSString stringWithFormat:@"准时到店满%d次",info.rewardNum];
        self.mainImage.image = [UIImage imageNamed:@"card_img_ITreward"];
    }
    self.subLab.text = info.goods;
}

@end
