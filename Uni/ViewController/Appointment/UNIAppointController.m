//
//  UNIAppointController.m
//  Uni
//  预约界面
//  Created by apple on 15/11/24.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointController.h"
#import "UNIAppointTop.h"
#import "UNIAppontMid.h"
#import "UNIAppointBotton.h"
@interface UNIAppointController ()
{
    UNIAppointTop* appointTop;
    UNIAppontMid* appontMid;
    UNIAppointBotton* appointBotton;
}
@end

@implementation UNIAppointController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTopScroller];
    [self setupMidScroller];
    [self setupBottomContent];
    [self regirstKeyBoardNotification];
}

#pragma mark 加载顶部Scroller
-(void)setupTopScroller{
    UNIAppointTop* top = [[NSBundle mainBundle]loadNibNamed:@"UNIAppointTop" owner:self options:nil].lastObject;
    top.frame = CGRectMake(0, 0, KMainScreenWidth,  KMainScreenWidth*170/320);
    [top setupUI:top.frame];
    [self.myScroller addSubview:top];
    appointTop = top;
}

#pragma mark 加载中部Scroller
-(void)setupMidScroller{
    UNIAppontMid* mid = [[NSBundle mainBundle]loadNibNamed:@"UNIAppontMid" owner:self options:nil].lastObject;
    mid.frame = CGRectMake(0, CGRectGetMaxY(appointTop.frame), KMainScreenWidth,  KMainScreenWidth*150/320);
    [mid setupUI];
    [self.myScroller addSubview:mid];
    appontMid = mid;
}
#pragma mark 加载底部Scroller
-(void)setupBottomContent{
//    UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    float wh = KMainScreenWidth* 60/320;
//    addBtn.frame = CGRectMake((KMainScreenWidth-wh)/2, CGRectGetMaxY(appontMid.frame), wh, wh);
    UNIAppointBotton* botton = [[NSBundle mainBundle]loadNibNamed:@"UNIAppointBotton" owner:self options:nil].lastObject;
    botton.frame = CGRectMake(0, CGRectGetMaxY(appontMid.frame)+5, KMainScreenWidth,  KMainScreenWidth*170/320);
    [botton setupUI];
    [self.myScroller addSubview:botton];
    appointBotton = botton;
    
    
    [[botton.addProBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         
     }];
    [[botton.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         
     }];
    
}

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
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification*)notifi{
    NSDictionary *info = [notifi userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    self.view.frame = CGRectMake(0, -keyboardSize.height, KMainScreenWidth, KMainScreenHeight);
}
#pragma mark 键盘隐藏
-(void)keyboardWillHide:(NSNotification*)notifi{
    self.view.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
