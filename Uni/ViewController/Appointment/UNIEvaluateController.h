//
//  UNIEvaluateController.h
//  Uni
//  服务评价
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UNIEvaluateController : UIViewController
@property (strong, nonatomic)  UIView *mainView;
@property (strong, nonatomic)  UILabel *label1;
@property (strong, nonatomic)  UILabel *label2;
@property (strong, nonatomic)  UILabel *label3;
@property (strong, nonatomic)  UIImageView *mainImg;
@property (strong, nonatomic)  UITextView *textView;
@property (strong, nonatomic)  UIButton *xing1;
@property (strong, nonatomic)  UIButton *xing2;
@property (strong, nonatomic)  UIButton *xing3;
@property (strong, nonatomic)  UIButton *xing4;
@property (strong, nonatomic)  UIButton *xing5;
@property (strong, nonatomic)  UIButton *submitBnt;

@property(nonatomic,strong)NSArray* data;
@end
