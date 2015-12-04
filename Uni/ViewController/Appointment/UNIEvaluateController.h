//
//  UNIEvaluateController.h
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIEvaluateController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UIImageView *mainImg;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *xing1;
@property (weak, nonatomic) IBOutlet UIButton *xing2;
@property (weak, nonatomic) IBOutlet UIButton *xing3;
@property (weak, nonatomic) IBOutlet UIButton *xing4;
@property (weak, nonatomic) IBOutlet UIButton *xing5;
@property (weak, nonatomic) IBOutlet UIButton *submitBnt;

@property(nonatomic,strong)NSArray* data;
@end
