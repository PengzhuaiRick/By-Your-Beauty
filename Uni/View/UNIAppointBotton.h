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
@property (assign, nonatomic) int member;//人数

@property (weak, nonatomic) IBOutlet UITextField *nunField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *jiaBtn;
@property (weak, nonatomic) IBOutlet UIButton *jianBnt;
@property (weak, nonatomic) IBOutlet UIButton *xunzhiBtn;

-(void)setupUI;
@end
