//
//  UNIAppointBotton.h
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTKeyboardTool.h"
@interface UNIAppointBotton : UIView<KeyboardToolDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nunField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *jiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *jianBnt;
@property (weak, nonatomic) IBOutlet UIButton *xunzhiBtn;
@property (weak, nonatomic) IBOutlet UILabel *menberLab;

-(void)setupUI;
@end
