//
//  UNIEvaluateController.m
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIEvaluateController.h"
#import "UNIMyAppointInfoRequest.h"
#import "BTKeyboardTool.h"
@interface UNIEvaluateController ()<KeyboardToolDelegate>{
    int grades;//评级分数
}

@end

@implementation UNIEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
}
-(void)setupNavigation{
   self.title=@"服务评价";
}
-(void)setupUI{
    grades = 0;
    self.label1.text = self.data[0];
    self.label2.text = self.data[1];
    self.label3.text = self.data[2];
    
    self.mainView.layer.masksToBounds = YES;
    self.mainView.layer.cornerRadius = 10;
    
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.borderColor = [UIColor colorWithHexString:kMainTitleColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate=self;
    [tool dismissTwoBtn];
    self.textView.inputAccessoryView=tool;
    
    UIImage* img1 =[UIImage imageNamed:@"evaluate_btn_xing1"];
    UIImage* img2 =[UIImage imageNamed:@"evaluate_btn_xing2"];
    [self.xing1 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.xing1 setBackgroundImage:img2 forState:UIControlStateSelected];
    [self.xing1 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    
    [self.xing2 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.xing2 setBackgroundImage:img2 forState:UIControlStateSelected];
    [self.xing2 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    
    [self.xing3 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.xing3 setBackgroundImage:img2 forState:UIControlStateSelected];
    [self.xing3 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    
    [self.xing4 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.xing4 setBackgroundImage:img2 forState:UIControlStateSelected];
    [self.xing4 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    
    [self.xing5 setBackgroundImage:img1 forState:UIControlStateNormal];
    [self.xing5 setBackgroundImage:img2 forState:UIControlStateSelected];
    [self.xing5 setBackgroundImage:img2 forState:UIControlStateHighlighted];
    
    [[self.textView.rac_textSignal map:^id(NSString* value) {
        if (value.length>10 && value.length<500) {
            return @(YES);
        }else
            return @(NO);
    }]subscribeNext:^(NSNumber* x) {
        self.submitBnt.enabled = x.boolValue;
    }];
    
    
    [[self.submitBnt rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         [self startSubmitComment];
    }];
 }

#pragma mark 星星按钮评级
- (IBAction)xingxingTouchAction:(UIButton*)sender {
    grades = (int)sender.tag;
    for (int i=1 ; i<6; i++) {
        UIButton* btn = (UIButton*)[self.mainView viewWithTag:i];
        if (btn.tag<=sender.tag)
            btn.selected = YES;
        else
            btn.selected = NO;
    }
}

#pragma mark 开始提交评论
-(void)startSubmitComment{
    UNIMyAppointInfoRequest* req = [[UNIMyAppointInfoRequest alloc]init];
    [req postWithSerCode:@[API_PARAM_UNI,API_URL_GoodsAppraise] params:@{@"goodsId":@"",@"level":@(grades),@"content":self.textView.text}];
    req.rqAppraise =^(int code,NSString*tips,NSError* err){
        if (err) {
            [YIToast showText:err.localizedDescription];
            return ;
        }
        if (code==0) {
            
        }else
            [YIToast showText:tips];

    };
}

-(void)keyboardTool:(BTKeyboardTool*)tool buttonClick:(KeyBoardToolButtonType)type{
    if(type == kKeyboardToolButtonTypeDone)
        [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
