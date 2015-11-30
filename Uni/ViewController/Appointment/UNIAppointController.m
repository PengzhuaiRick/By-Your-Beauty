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
    
    self.title =self.model.projectName;
    [self setupMyScroller];
    [self setupTopScroller];
    [self setupMidScroller];
    [self setupBottomContent];
    [self regirstKeyBoardNotification];
}

-(void)setupMyScroller{
    self.myScroller.backgroundColor = [UIColor colorWithHexString:@"e4e5e9"];
    if (KMainScreenHeight<568)
        self.myScroller.contentSize = CGSizeMake(KMainScreenWidth, 568);
    else
        self.myScroller.contentSize = CGSizeMake(KMainScreenWidth, KMainScreenHeight-64);
    
    

}

#pragma mark 加载顶部Scroller
-(void)setupTopScroller{
    UNIAppointTop* top = [[NSBundle mainBundle]loadNibNamed:@"UNIAppointTop" owner:self options:nil].lastObject;
    CGRect scrollerR = _myScroller.frame;
    top.frame = CGRectMake(8, 8, scrollerR.size.width-16,KMainScreenWidth*170/320);
    top.layer.masksToBounds=YES;
    top.layer.cornerRadius = 5;
    top.model = self.model;
    [top setupUI:top.frame];
    [self.myScroller addSubview:top];
    appointTop = top;
}

#pragma mark 加载中部Scroller
-(void)setupMidScroller{
   // CGRect scrollerR = _myScroller.frame;
    UNIAppontMid* mid = [[UNIAppontMid alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(appointTop.frame)+8, KMainScreenWidth-16, KMainScreenWidth*185/320)];
    [self.myScroller addSubview:mid];
    appontMid = mid;
    
    
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
    
     CGRect scrollerR = _myScroller.frame;
    UNIAppointBotton* botton = [[NSBundle mainBundle]loadNibNamed:@"UNIAppointBotton" owner:self options:nil].lastObject;
    botton.frame = CGRectMake(8, CGRectGetMaxY(appontMid.frame)+13, scrollerR.size.width-16,  KMainScreenWidth*120/320);
    [botton setupUI];
    [self.myScroller addSubview:botton];
    appointBotton = botton;
    
    
        [[botton.sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         UNIMypointRequest* req = [[UNIMypointRequest alloc]init];
         //NSString* date = [NSString stringWithFormat:@"%@ %@",appointTop.selectDay,appointTop.selectTime];
         NSDictionary* dic = @{@"projectId":@"2",
                               @"date":@"2015-11-29 14:30:00",
                               @"costTime":@"30",
                               @"num":@(1)
                               };
         NSDictionary* dic1 = @{@"projectId":@"2",
                               @"date":@"2015-11-29 15:00:00",
                               @"costTime":@"30",
                               @"num":@(1)
                               };
         NSMutableArray* arr = [NSMutableArray array];
         [arr addObject:dic1];
         //[arr addObject:dic];
         [req postWithSerCode:@[API_PARAM_UNI,API_URL_SetAppoint] params:@{@"userId":@(1),
                                                                           @"token":@"abcdxxa",
                                                                           @"shopId":@(1),
                                                                           @"data":arr
                                                                          }];
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
    
    //加号
    [[botton.jiaBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         if (self->appointTop.member<self->appointTop.maxNum) {
             self->appointTop.member++;
             //botton.nunField.text = [NSString stringWithFormat:@"%d",self->appointTop.member];
         }
        
     }];
    
    //减号
    [[botton.jianBnt rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         if (self->appointTop.member >1)
             self->appointTop.member--;
        // botton.nunField.text = [NSString stringWithFormat:@"%d",botton.member];
     }];
    
    // 人数 每次修改都会调用
    [RACObserve(appointTop, member)subscribeNext:^(id x) {
        botton.nunField.text = [NSString stringWithFormat:@"%d",self->appointTop.member];
    }];
    
    //检测键盘输入人数 是否数字并判断是否超过最大值
    [botton.nunField.rac_textSignal subscribeNext:^(NSString* value) {
        if (value.length>0) {
            char r = [value characterAtIndex:value.length-1];
            if (r<48||r>57){
                NSString *str=[NSString stringWithCString:&r  encoding:NSUTF8StringEncoding];
                value = [value stringByReplacingOccurrencesOfString:str withString:@""];
            }
        }
        int num = value.intValue;
        if (num>self->appointTop.maxNum) {
            num =self->appointTop.maxNum;
            [YIToast showText:@"已到达可预约最大人数"];
        }else if(num<1)
            num = 1;
        botton.nunField.text = [NSString stringWithFormat:@"%d",num];
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
    [appontMid.myTableView reloadData];
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
