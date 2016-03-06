//
//  UNIEvaluateController.m
//  Uni
//  服务评价
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIEvaluateController.h"
#import "UNIMyAppointInfoRequest.h"
#import "BTKeyboardTool.h"
@interface UNIEvaluateController ()<KeyboardToolDelegate,UITextViewDelegate>{
    int grades;//评级分数
    BOOL first; //是否第一次输入
}

@end

@implementation UNIEvaluateController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupBaseUI];
    [self setupUI];
    [self regirstKeyBoardNotification];
}
-(void)setupNavigation{
   self.title=@"服务评价";
     self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}
-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupBaseUI{
    float viewX = 0;
    float viewY = 64+15;
    float viewW = KMainScreenWidth;
    float viewH = KMainScreenHeight ;
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(viewX, viewY, viewW, viewH)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    self.mainView = view;
    
    UIImage* image = [UIImage imageNamed:@"evaluate_img_top"];
    float imgX = 0;
    float imgY =0;
    float imgW = viewW;
    float imgH =image.size.height*imgW/image.size.width;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY,imgW, imgH)];
    img.image = image;
    [view addSubview:img];
    self.mainImg =img;
    
    float lab1X = 16;
    float lab1H = KMainScreenWidth * 20/320;
    float lab1Y = imgH - lab1H-10;
    float lab1W = imgW - lab1X*2;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(lab1X, lab1Y,lab1W, lab1H)];
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*14/320];
    lab1.textColor = [UIColor whiteColor];
    [img addSubview:lab1];
    self.label1 = lab1;
    
    
    float lab2X = 16 ;
    float lab2H = KMainScreenWidth * 20/320;
    float lab2Y = CGRectGetMaxY(img.frame)+10;
    float lab2W = viewW - 2*lab2X;
    UILabel* lab2 = [[UILabel alloc]initWithFrame:CGRectMake(lab2X, lab2Y,lab2W, lab2H)];
    lab2.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:13];
    lab2.textColor = [UIColor colorWithHexString:kMainThemeColor];
    [view addSubview:lab2];
    self.label2 = lab2;
    
    
    float lab3X = 16 ;
    float lab3H = KMainScreenWidth * 20/320;
    float lab3Y = CGRectGetMaxY(lab2.frame)+8;
    float lab3W = viewW - 2*lab2X;
    UILabel* lab3 = [[UILabel alloc]initWithFrame:CGRectMake(lab3X, lab3Y,lab3W, lab3H)];
    lab3.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:13];
    lab3.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [view addSubview:lab3];
    self.label3 = lab3;
    
    float lab4X = 16 ;
    float lab4H = KMainScreenWidth * 20/320;
    float lab4Y = CGRectGetMaxY(lab3.frame)+12;
    float lab4W = viewW /2;
    UILabel* lab4 = [[UILabel alloc]initWithFrame:CGRectMake(lab4X, lab4Y, lab4W, lab4H)];
    lab4.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:13];
     lab4.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab4.text = @"服务满意度";
    [view addSubview:lab4];
    
    
    float btnX = viewW/2;
    float btnY =lab4Y;
    float btnHW = KMainScreenWidth*25/320;

    UIImage* img1 =[UIImage imageNamed:@"evaluate_btn_xing1"];
    for (int i = 0; i<5; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame =CGRectMake(btnX+i*(btnHW+5), btnY, btnHW, btnHW);
        [btn setBackgroundImage:img1 forState:UIControlStateNormal];
        btn.selected = YES;
        btn.tag = i+1;
        [view addSubview:btn];
        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             [self xingxingTouchAction:btn];
         }];

        switch (i) {
            case 0:
                self.xing1 = btn;
                break;
            case 1:
               self.xing2 = btn;
                break;
            case 2:
               self.xing3 = btn;
                break;
            case 3:
               self.xing4 = btn;
                break;
            case 4:
                self.xing5 = btn;
                break;
        }
    }
    
    float textX = 16;
    float textY = btnY + btnHW +16;
    float textW = viewW - 2*textX;
    float textH = KMainScreenWidth *120 /320;
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(textX, textY, textW, textH)];
    textView.text = @"  写下你对本次服务宝贵意见,长度在50-100字以内.";
    textView.textColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    textView.font = [UIFont systemFontOfSize:KMainScreenWidth>400?15:13];
    textView.delegate = self;
    [view addSubview:textView];
    self.textView = textView;

    float btWH =KMainScreenWidth*70/414;
    float btX = (KMainScreenWidth - btWH)/2;
    float btY = CGRectGetMaxY(textView.frame)+30;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame =CGRectMake(btX, btY, btWH, btWH);
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth>400?18:15];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = btWH/2;
    btn.layer.borderColor =[UIColor colorWithHexString:kMainThemeColor].CGColor;
    btn.layer.borderWidth = 0.5;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    
    [view addSubview:btn];
    self.submitBnt = btn;

}
-(void)setupUI{
    grades = 5;
    first = YES;
    self.label1.text =self.model.projectName ;
    self.label2.text =[NSString stringWithFormat:@"预约时间: %@",self.model.date];
    self.label3.text =[NSString stringWithFormat:@"订单编号: %@",self.order];

    
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
- (void)xingxingTouchAction:(UIButton*)sender {
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
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIMyAppointInfoRequest* req = [[UNIMyAppointInfoRequest alloc]init];
    [req postWithSerCode:@[API_PARAM_UNI,API_URL_SetServiceAppraise]
                  params:@{@"goodsId":@(self.model.projectId),@"level":@(grades),@"content":self.textView.text,@"order":self.order,@"projectName":self.model.projectName,@"shopId":@(_shopId)}];
    req.rqAppraise =^(int code,NSString*tips,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            if (err) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (code==0) {
                [YIToast showText:@"评论成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }

        });
        
    };
}

-(void)keyboardTool:(BTKeyboardTool*)tool buttonClick:(KeyBoardToolButtonType)type{
    if(type == kKeyboardToolButtonTypeDone)
        [self.view endEditing:YES];
    
}

#pragma mark 注册键盘是事件
-(void)regirstKeyBoardNotification{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)keyboardWillShow:(NSNotification*)notification{
    self.mainView.frame = CGRectMake(self.mainView.frame.origin.x,
                                     -100,
                                     self.mainView.frame.size.width,
                                     self.mainView.frame.size.height);
}
-(void)keyboardWillHide:(NSNotification*)notification{
    self.mainView.frame = CGRectMake(0,
                                     64+15,
                                     self.mainView.frame.size.width,
                                     self.mainView.frame.size.height);
}

-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
    [super viewDidDisappear:animated];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (first) {
        first = NO;
        textView.text =@"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

#pragma mark 颜色转图片
-(UIImage*)createImageWithColor:(UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
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
