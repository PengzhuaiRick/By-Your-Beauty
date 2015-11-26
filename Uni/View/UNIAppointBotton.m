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
    self.member =1;
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate=self;
    [tool dismissTwoBtn];
    self.nunField.inputAccessoryView = tool;
    [self.nunField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //[self regirstKeyBoardNotification];
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
