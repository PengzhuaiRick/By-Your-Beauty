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
#import "UNIMyPojectList.h"
//#import "UNIMyProjectModel.h"
@interface UNIAppointController ()<UNIMyPojectListDelegate>
{
    UNIAppointTop* appointTop;
    UNIAppontMid* appontMid;
    UNIAppointBotton* appointBotton;
}
@end

@implementation UNIAppointController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的项目";
    self.myScroller.backgroundColor = [UIColor colorWithHexString:@"e4e5e9"];
    [self setupTopScroller];
    [self setupMidScroller];
    [self setupBottomContent];
    [self regirstKeyBoardNotification];
}

#pragma mark 加载顶部Scroller
-(void)setupTopScroller{
    UNIAppointTop* top = [[NSBundle mainBundle]loadNibNamed:@"UNIAppointTop" owner:self options:nil].lastObject;
    top.frame = CGRectMake(8, 8, KMainScreenWidth-16,  KMainScreenWidth*170/320);
    top.model = self.model;
    [top setupUI:top.frame];
    [self.myScroller addSubview:top];
    appointTop = top;
}

#pragma mark 加载中部Scroller
-(void)setupMidScroller{
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(appointTop.frame)+8,KMainScreenWidth-16 , KMainScreenWidth*0.05)];
    view.image =[UIImage imageNamed:@"mian_img_cellH"];
    UILabel* lab = [[UILabel alloc]initWithFrame:
                    CGRectMake(5, 2,  view.frame.size.width, KMainScreenWidth*0.05)];
    lab.text=@"预约项目";
    lab.textColor = [UIColor colorWithHexString:@"575757"];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.043];
    [view addSubview:lab];
    [self.myScroller addSubview:view];

    UNIAppontMid* mid = [[NSBundle mainBundle]loadNibNamed:@"UNIAppontMid" owner:self options:nil].lastObject;
    mid.frame = CGRectMake(8, CGRectGetMaxY(view.frame), KMainScreenWidth-16,  KMainScreenWidth*160/320);
    [mid setupUI];
    [self.myScroller addSubview:mid];
    appontMid = mid;
    
    UIImageView* view1 = [[UIImageView alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(mid.frame), KMainScreenWidth-16, 5)];
    view1.image =[UIImage imageNamed:@"main_img_cellF"];
    [self.myScroller addSubview:view1];
    
    [[mid.addProBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         UIStoryboard* stroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UNIMyPojectList* list = [stroy instantiateViewControllerWithIdentifier:@"UNIMyPojectList"];
         list.delegate = self;
         [self.navigationController pushViewController:list animated:YES];
     }];

}
#pragma mark 加载底部Scroller
-(void)setupBottomContent{
//    UIButton* addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    float wh = KMainScreenWidth* 60/320;
//    addBtn.frame = CGRectMake((KMainScreenWidth-wh)/2, CGRectGetMaxY(appontMid.frame), wh, wh);
    UNIAppointBotton* botton = [[NSBundle mainBundle]loadNibNamed:@"UNIAppointBotton" owner:self options:nil].lastObject;
    botton.frame = CGRectMake(8, CGRectGetMaxY(appontMid.frame)+13, KMainScreenWidth-16,  KMainScreenWidth*120/320);
    [botton setupUI];
    [self.myScroller addSubview:botton];
    appointBotton = botton;
    
    
        [[botton.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         UNIMypointRequest* req = [[UNIMypointRequest alloc]init];
         [req postWithSerCode:@[API_PARAM_UNI,API_URL_SetAppoint] params:@{@"userId":@(1),
                                                                           @"token":@"abcdxxa",
                                                                           @"shopId":@(1),
                                                                           @"projectId":@(2),
                                                                           @"date":@"2015-11-24",
                                                                           @"costTime":@(50),
                                                                           @"num":@(botton.member)}];
         req.resetAppoint=^(NSString* order,NSString* tips,NSError* err){
             if (err) {
                 [YIToast showText:[err localizedDescription]];
                 return ;
             }
             if (order) {
                 
             }else
                  [YIToast showText:tips];
         };
     }];
    [[botton.jiaBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         if (botton.member<self->appointTop.maxNum) {
             botton.member++;
             botton.nunField.text = [NSString stringWithFormat:@"%d",botton.member];
         }
        
     }];
    
    [[botton.jianBnt rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         if (botton.member >1)
             botton.member--;
         botton.nunField.text = [NSString stringWithFormat:@"%d",botton.member];
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

#pragma mark UNIMyPojectListDelegate 代理实现方法
-(void)UNIMyPojectListDelegateMethod:(id)model{
    [appontMid addProject:model];
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
