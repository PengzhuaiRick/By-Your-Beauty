//
//  UNIAppointBotton.m
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointBotton.h"

@implementation UNIAppointBotton


-(void)setupUI:(CGRect)frace{
    
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate=self;
    [tool dismissTwoBtn];
    self.nunField.inputAccessoryView = tool;
    [self.nunField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    self.xunzhiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*10/320];
    self.menberLab.font= [UIFont boldSystemFontOfSize:KMainScreenWidth*14/320];
    self.nunField.font= [UIFont boldSystemFontOfSize:KMainScreenWidth*14/320];
    
    self.sureBtn.titleLabel.numberOfLines = 0;
    self.sureBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.sureBtn setTitle:@"确定\n预约" forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*17/320];
    
    
    float uiH = 0;
    
    float xuzhiW = KMainScreenWidth*140/320;
    float xuzhiH = KMainScreenWidth*26/320;
    float xuzhiX = 0;
    self.xunzhiBtn.frame = CGRectMake(xuzhiX, uiH, xuzhiW, xuzhiH);
    
    float jiaW = KMainScreenWidth*25/320;
    float jiaH = KMainScreenWidth*21/320;
    float jiaX = frace.size.width - jiaW -8;
    self.jiaBtn.frame = CGRectMake(jiaX, uiH, jiaW, jiaH);
    
    float fieldW = KMainScreenWidth*28/320;
    float fieldH = KMainScreenWidth*21/320;
    float fieldX = jiaX - fieldW - 2;
    self.nunField.frame = CGRectMake(fieldX,uiH, fieldW, fieldH);
    
    float jianW = KMainScreenWidth*25/320;
    float jianH = KMainScreenWidth*21/320;
    float jianX = fieldX - jianW - 2;
    self.jianBnt.frame = CGRectMake(jianX,uiH, jianW, jianH);

    float memberW = KMainScreenWidth*45/320;
    float memberH = KMainScreenWidth*21/320;
    float memberX = jianX - memberW - 2;
    self.menberLab.frame = CGRectMake(memberX,uiH, memberW, memberH);
    
    float sureWH = KMainScreenWidth*70/320;
    float sureX = (frace.size.width - sureWH)/2 ;
    float sureY = frace.size.height - sureWH - 10;
    self.sureBtn.frame = CGRectMake(sureX,sureY, sureWH, sureWH);


}

-(void)keyboardTool:(BTKeyboardTool *)tool buttonClick:(KeyBoardToolButtonType)type{
    if(type == kKeyboardToolButtonTypeDone){
        [self endEditing:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
