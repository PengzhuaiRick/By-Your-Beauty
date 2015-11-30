//
//  UNIAppointBotton.m
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointBotton.h"

@implementation UNIAppointBotton


-(void)setupUI{
    
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
    self.sureBtn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*15/320];
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
