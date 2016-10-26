//
//  MainCell.m
//  Uni
//
//  Created by apple on 16/8/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MainCell.h"
#import "UNIMyAppintModel.h"
#import "UNIMyProjectModel.h"
#import "UNIHttpUrlManager.h"
@implementation MainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = 0;
    self.backgroundColor = [UIColor clearColor];
    
    _backView.layer.masksToBounds = YES;
    _backView.layer.cornerRadius = KMainScreenWidth* 5/414;
    
    _mainLab.font = kWTFont(14);
    _subLab.font = kWTFont(14);
    _handleBtn.titleLabel.font = kWTFont(14);
    _numLab.layer.masksToBounds = YES;
    float h1 =_numLab.frame.size.height;
    _numLab.layer.cornerRadius = (KMainScreenWidth* h1/414)/2;
    
    _handleBtn.layer.masksToBounds = YES;
   // _handleBtn.layer.cornerRadius =_handleBtn.frame.size.height/2;
    _handleBtn.layer.borderWidth = 1;
    _handleBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    _handleBtn.titleLabel.numberOfLines = 0;
    _handleBtn.titleLabel.lineBreakMode = 0;
    [_handleBtn setTitle:@"马上\n预约" forState:UIControlStateNormal];
    
    float h =_handleBtn.frame.size.height;
    _handleBtn.layer.cornerRadius =(KMainScreenWidth* h /414)/2;

}

#pragma mark 设置 第一次个Cell 预约详情
-(void)setupFirstCell:(id)data andTotal:(int)total{
    if(data){
        UNIMyAppintModel* info = data[0];
        [_handleBtn setTitle:@"查看\n详情" forState:UIControlStateNormal];
        _handleImg.image = [UIImage imageNamed:@"main_btn_cell1"];
        self.numLab.hidden=NO;
        self.numLab.text = [NSString stringWithFormat:@"%d",total];
        [self startTheMsgNumAnimation];
        self.mainImage.image = [UIImage imageNamed:@"main_img_cell1"];
        self.mainLab.text = info.projectName;
        
        CGRect mainR = self.mainImage.frame;
        CGRect numR = self.numLab.frame;
        mainR.size.width = mainR.size.width - 10;
        self.mainImage.frame =mainR;
    
        numR.origin.x = numR.origin.x - 10;
        self.numLab.frame = numR;
        
        NSString* str = [info.time substringWithRange:NSMakeRange(0, info.time.length - 3)];
        NSString* str1 = [str stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        self.subLab .text = [NSString stringWithFormat:@"我已预约:%@",str1];
        _handleBtn.hidden = NO;
        _handleImg.hidden =NO;
    }else{
        self.numLab.hidden=YES;
        self.mainImage.image = [UIImage imageNamed:@"main_img_nodata1"];
        self.mainLab.text = @"已约完!";
        self.subLab .text = [UNIHttpUrlManager sharedInstance].APPOINT_DESC;
        _handleBtn.hidden = YES;
        _handleImg.hidden = YES;

    
    }
    
}

#pragma mark 设置 预约项目的cell
-(void)setupOtherCell:(id)data{
    self.numLab.hidden=YES;
    if(data){
         UNIMyProjectModel* info =(UNIMyProjectModel*) data;
        [self.mainImage sd_setImageWithURL:[NSURL URLWithString:info.logoUrl]
                          placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
        self.mainLab.text = info.projectName;
        self.subLab .text = [NSString stringWithFormat:@"剩余%d次",info.num];
        [_handleBtn setTitle:@"马上\n预约" forState:UIControlStateNormal];
        _handleImg.image = [UIImage imageNamed:@"main_btn_cell2"];
    }
   
}

#pragma mark 最后一个cell  自定义预约内容
-(void)setupCustomCell{
    self.textLabel.text =nil;
    self.numLab.hidden = YES;
    self.mainImage.image = [UIImage imageNamed:@"main_img_cell4"];
    self.mainLab.text = [UNIHttpUrlManager sharedInstance].SELF_APPOINT_TITLE;
    self.subLab .text = [UNIHttpUrlManager sharedInstance].SELF_APPOINT_CONTENT;
    _handleImg.image = [UIImage imageNamed:@"main_btn_cell2"];
  }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark 消息数量 放大缩小的弹性动画
-(void)startTheMsgNumAnimation{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    //方式1：放大再缩小（类似系统alert）
    //如果需要更好的效果
    //可以添加 .keyTimes 属性。
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.3, 1.3, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .5;
    animation.repeatCount = 1;
    
    [_numLab.layer addAnimation:animation forKey:@"showAlert"];
    [self performSelector:@selector(startTheMsgNumAnimation) withObject:nil afterDelay:4];
}


@end
