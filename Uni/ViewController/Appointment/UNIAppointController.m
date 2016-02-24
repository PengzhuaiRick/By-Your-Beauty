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
#import "UNIMyPojectList.h"
#import "AccountManager.h"

//#import "UNIMyProjectModel.h"
@interface UNIAppointController ()<UNIMyPojectListDelegate,UNIAppontMidDelegate>
{
    UNIAppointTop* appointTop;
    UNIAppontMid* appontMid;
    //UNIAppointBotton* appointBotton;
    UIButton* sureBtn; //马上预约按钮
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
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupMyScroller{
    self.myScroller.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    if (KMainScreenHeight<568)
        self.myScroller.contentSize = CGSizeMake(KMainScreenWidth, 568);
    else
        self.myScroller.contentSize = CGSizeMake(KMainScreenWidth, KMainScreenHeight-64);
}

#pragma mark 加载顶部Scroller
-(void)setupTopScroller{
    UNIAppointTop* top = [[UNIAppointTop alloc]initWithFrame:CGRectMake(0,0, KMainScreenWidth,KMainScreenWidth*250/320) andModel:self.model];
    [self.myScroller addSubview:top];
    appointTop = top;
}

#pragma mark 加载中部Scroller
-(void)setupMidScroller{
   // CGRect scrollerR = _myScroller.frame;
    UNIAppontMid* mid = [[UNIAppontMid alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(appointTop.frame)+10, KMainScreenWidth-20, KMainScreenWidth*130/320) andModel:_model];
    mid.delegate = self;
    [self.myScroller addSubview:mid];
    appontMid = mid;
    
    
    [[mid.addProBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:nil];
         UIStoryboard* stroy = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UNIMyPojectList* list = [stroy instantiateViewControllerWithIdentifier:@"UNIMyPojectList"];
         list.projectIdArr = mid.myData;
         list.delegate = self;
         [self.navigationController pushViewController:list animated:YES];
     }];

}
#pragma mark 加载底部Scroller
-(void)setupBottomContent{
    float btnWH = KMainScreenWidth>320?80:70;
    float btnY = _myScroller.contentSize.height -btnWH - 10;
    float btnX = (KMainScreenWidth - btnWH)/2;
    
    UIButton* btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    [btn setTitle:@"马上\n预约" forState:UIControlStateNormal];
    //[btn setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    btn.titleLabel.lineBreakMode = 0;
    btn.titleLabel.numberOfLines = 0;
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth>320?18:16];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius = btnWH/2;
    btn.layer.borderWidth = 0.5;
    btn.layer.borderColor =[UIColor colorWithHexString:kMainThemeColor].CGColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:kMainThemeColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:kMainThemeColor]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forState:UIControlStateHighlighted];
    [_myScroller addSubview:btn];
    sureBtn = btn;
    
    //检测是否有 预约时间点 存在，选择了预约时间点 才能进行 确定预约 否则预约按钮不可点击
    [RACObserve(appointTop, selectTime)
    subscribeNext:^(NSString* x) {
        self->sureBtn.enabled =x.length>0;
    }];
    
    
        [[sureBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
#ifdef IS_IOS9_OR_LATER
         UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"是否确定预约?" message:nil preferredStyle:UIAlertControllerStyleAlert];
         UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
         [alertController addAction:cancelAction];
         
         UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"预约" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [self startAppoint];
         }];
         [alertController addAction:sureAction];
         [self presentViewController:alertController animated:YES completion:nil];
#else
         [UIAlertView showWithTitle:@"是否确定预约?" message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"预约"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
             if (buttonIndex == 1) {
                 [self startAppoint];
             }
         }];
#endif
        
             }];
}

-(void)startAppoint{
             [LLARingSpinnerView RingSpinnerViewStart1];
             UNIMypointRequest* req = [[UNIMypointRequest alloc]init];
             NSMutableArray* arr = [NSMutableArray array];
              NSString* date = [NSString stringWithFormat:@"%@ %@",self->appointTop.selectDay,self->appointTop.selectTime];
             int num = appointTop.nunField.text.intValue;
             for (UNIMyProjectModel* model in self->appontMid.myData) {
    
                 NSDictionary* dic1 = @{@"projectId":@(model.projectId),
                                        @"date":date,
                                        @"costTime":@(model.costTime),
                                        @"num":@(num)
                                        };
                  [arr addObject:dic1];
             }
             [req postWithSerCode:@[API_PARAM_UNI,API_URL_SetAppoint]
                           params:@{@"data":arr}];
             dispatch_async(dispatch_get_main_queue(), ^{
                 [LLARingSpinnerView RingSpinnerViewStop1];
                 req.resetAppoint=^(NSString* order,NSString* tips,NSError* err){
                     if (err) {
                         [YIToast showText:NETWORKINGPEOBLEM];
                         return ;
                     }
                     if (order) {
                         //[YIToast showText:@"预约成功"];
#ifdef IS_IOS9_OR_LATER
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"您的预约信息已提交,请等待店家确认.\n预约结果以短信回复为准" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //[self locationNotificationTask:nil];
         [self locationNotificationTask:order];
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
#else
    [UIAlertView showWithTitle:@"您的预约信息已提交,请等待店家确认.\n预约结果以短信回复为准" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
            [self locationNotificationTask:order];
    }];
#endif
                     }else
                         [YIToast showText:@"预约失败"];
                 };
    
             });

}

#pragma mark 添加本地通知任务
-(void)locationNotificationTask:(NSString*)order{

   UILocalNotification *localNotification = [[UILocalNotification alloc] init];

    NSArray* array = [appointTop.selectTime componentsSeparatedByString:@":"];
    int seleZhong = [array[0] intValue];
    NSString* sele = [NSString stringWithFormat:@"%@ %d:%@:00",appointTop.selectDay,--seleZhong,array[1]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSDate* strDate = [dateFormatter dateFromString:sele];
    //设置本地通知的触发时间（如果要立即触发，无需设置）
    localNotification.fireDate =strDate;
    
    //localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    //设置本地通知的时区
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    //设置通知的内容
    localNotification.alertBody =  @"您预约的服务时间还有一小时";
    //设置通知动作按钮的标题
    localNotification.alertAction = @"查看";
    //设置提醒的声音，可以自己添加声音文件，这里设置为默认提示声
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    //设置通知的相关信息，这个很重要，可以添加一些标记性内容，方便以后区分和获取通知的信息
    
    
    NSDictionary *infoDic = @{@"OrderId":order,@"useId":[AccountManager userId]};
    localNotification.userInfo = infoDic;
    //在规定的日期触发通知
   [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
    NSDictionary* dib = @{@"time":strDate,@"OrderId":order,@"useId":[AccountManager userId]};
    NSUserDefaults* user = [NSUserDefaults standardUserDefaults];
    NSArray* appointArr = [user objectForKey:@"appointArr"];
    NSMutableArray* arr;
    if (appointArr.count>0)
        arr =[NSMutableArray arrayWithArray:appointArr];
    else
        arr =[NSMutableArray array];
    
    [arr addObject:dib];
    [user setObject:arr forKey:@"appointArr"];
    [user synchronize];
    
    //预约成功刷新界面
    [[NSNotificationCenter defaultCenter] postNotificationName:APPOINTANDREFLASH object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
-(void)UNIMyPojectListDelegateMethod:(NSArray *)arr{
    //UNIMyProjectModel* info = model;
    [appontMid addProject:arr];
    [self modifitacteAppontMid];
}

-(void)UNIAppontMidDelegateMethod{
    [self modifitacteAppontMid];
}

-(void)modifitacteAppontMid{
    // 添加项目和减少项目的时候 修改 appontMid 的高度 和 sureBtn 的位置
    NSArray* x = appontMid.myData;
        float yy =x.count*self->appontMid.cellH + 35+CGRectGetMinY(self->appontMid.frame)+CGRectGetMaxY(self->appontMid.lab1.frame);
        float viewH =x.count*self->appontMid.cellH + 35+CGRectGetMaxY(self->appontMid.lab1.frame)+10;
        if (yy<=self->sureBtn.frame.origin.y) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect btnRe = self->sureBtn.frame;
                btnRe.origin.x = (self->_myScroller.frame.size.width - btnRe.size.width)/2;
                self-> sureBtn.frame = btnRe;
            }];
        }else{
            viewH = self->_myScroller.contentSize.height - CGRectGetMinY(self->appontMid.frame) - 10;
            CGRect btnRe = self->sureBtn.frame;
            btnRe.origin.x = self->_myScroller.frame.size.width - 10 - btnRe.size.width;
            self-> sureBtn.frame = btnRe;
        }
        
        
        CGRect midRec =self-> appontMid.frame;
        midRec.size.height = viewH ;
        self-> appontMid.frame = midRec;
        
        CGRect tabRe = self->appontMid.myTableView.frame;
        tabRe.size.height = viewH - CGRectGetMaxY(self->appontMid.lab1.frame) - 50;
        self->appontMid.myTableView.frame =tabRe;
        
        CGRect addRec = self->appontMid.addProBtn.frame;
        addRec.origin.y =midRec.size.height - 45;
        self->appontMid.addProBtn.frame =addRec;
    
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
