//
//  LoginController.m
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LoginController.h"
#import "AppDelegate.h"
#import "AccountManager.h"
#import "UNILoginViewRequest.h"
#import "BTKeyboardTool.h"
#import "UNILoginShopList.h"

@interface LoginController ()<KeyboardToolDelegate,UITextFieldDelegate>{
    
   // RACSignal *phoneSignal;
    RACSignal *codeFieldSignal;
    RACSignal *nikeSignal;
    
    NSTimer* time;
    int countDown;
   // int imgH;
    int bShu;
    //int cellH;
    
    NSDate* ServierTime; //服务器时间
    
    __weak IBOutlet UITextField *phoneField;
    __weak IBOutlet UITextField *codeField;
    __weak IBOutlet UITextField *nikeName;
    __weak IBOutlet UIButton *maleBtn;
    __weak IBOutlet UIButton *femaleBtn;
    __weak IBOutlet UIButton *codeBtn;
    __weak IBOutlet UIButton *loginBtn;
    __weak IBOutlet UIButton *customBtn;//游客登录接口
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIImageView *rotationImg;//旋转光圈
@property (weak, nonatomic) IBOutlet UIImageView *logImg;//
@property (weak, nonatomic) IBOutlet UIImageView *ziImg;//美丽由你图片


@property(nonatomic,assign)int sex; // 男1 女2
@end

@implementation LoginController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"登录界面"];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"登录界面"];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _sex = 2;
    [self setupUI];
    [self startRequest];
    [self regirstKeyBoardNotification];
    [self imageMove];
}

-(void)imageMove{
    __weak LoginController* myself = self;
    CGRect re1 = _rotationImg.frame;
    CGRect re2 = _logImg.frame;
    re1.origin.y = 70;
    re2.origin.y =re1.origin.y+(re1.size.height - re2.size.height)/2;
    [UIView animateWithDuration:1 animations:^{
        myself.rotationImg.frame = re1;
        myself.logImg.frame = re2;
        myself.ziImg.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 animations:^{
             myself.scrollerView.alpha = 1;
        }];
       
    }];
}
-(void)setupUI{
    _scrollerView.scrollEnabled = KMainScreenHeight<500;
    [self rotationTheImg];
    [self modificateUI];
    [self setupPhoneField];
    
    [self setupCodeField];
    [self setupCodeBtn];
    
    [self setupNikeName];
    
    [self setupSexBtn];
    [self setupLoginBtn];
    [self addBTkeyBoardTool];
}
-(void)modificateUI{
    for (int i = 1; i<6; i++) {
        UIView *view = [_scrollerView viewWithTag:i];
        view.layer.masksToBounds=YES;
        view.layer.cornerRadius = view.frame.size.height/2;
    }
    
    phoneField.text = [AccountManager localLoginName];
    phoneField.font=kWTFont(16);
    codeField.font = kWTFont(16);
    nikeName.font = kWTFont(16);
    codeBtn.titleLabel.font = kWTFont(16);
    loginBtn.titleLabel.font = kWTFont(18);
    
    [_scrollerView setContentSize:CGSizeMake(KMainScreenWidth, KMainScreenHeight*1.2)];
}

-(void)startRequest{
//    UNILoginViewRequest* rq = [[UNILoginViewRequest alloc]init];
//    rq.rqfirstUrl=^(int code){
//        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupTouristBtn];
//        });
//    };
//    [rq firstRequestUrl];
}

-(void)setupTouristBtn{
    UNILoginViewRequest* req = [[UNILoginViewRequest alloc]init];
    [req postWithSerCode:@[API_URL_RetCode] params:nil];
    req.rqtouristBtn = ^(int code,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            self->customBtn.hidden=YES;
            if (code == INAUDIT) {
                self->customBtn.hidden=NO;
                [[self->customBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
                 subscribeNext:^(UIButton* x) {
                     x.enabled = NO;
                     [LLARingSpinnerView RingSpinnerViewStart1andStyle:1];
                     UNILoginViewRequest* request = [[UNILoginViewRequest alloc]init];
                     [request postWithoutUserIdSerCode:@[API_URL_Login]
                                                params:@{@"code":@"13267208242",
                                                         @"password":@"000000",
                                                         @"name":@"哈哈",
                                                         @"sex":@(1)}];
                     
                     request.rqloginBlock = ^(int extra,
                                              NSArray* array,
                                              NSString* tips,
                                              NSError* er){
                         x.enabled = YES;
                         [LLARingSpinnerView RingSpinnerViewStop1];
                         if (er==nil) {
                             if (array.count==0){
                                 [UIAlertView showWithTitle:@"登陆失败" message:tips style:UIAlertViewStyleDefault cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {                                 }];
                                 return ;
                             }
                             if(array.count==1){
                                 UNILoginShopModel* model = array[0];
                                 //保存信息
                                 [AccountManager setToken:model.token];
                                 //[AccountManager setUserId:@(model.userId)];
                                 [AccountManager setShopId:@(model.shopId)];
                                 //[AccountManager setLocalLoginName:@"13267208242"];
                                 
                                 [self log:nil];
                             }else if (array.count>1){
                                 UNILoginShopList* list = [[UNILoginShopList alloc]init];
                                 list.extra = extra;
                                 list.phone = @"13267208242";
                                 list.randcode = @"000000";
                                 list.myData = [NSMutableArray arrayWithArray:array];
                                 UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:list];
                                 [self presentViewController:nav animated:YES completion:nil];
                             }
                        }else
                             [YIToast showText:NETWORKINGPEOBLEM];
                         // [YIToast showWithText:tips];
                     };
                     
                 }];
            }
        });
    };
}



#pragma mark 设置手机号码
-(void)setupPhoneField{
    

   // UITextField* teft = phoneField;
    [[phoneField.rac_textSignal
     filter:^BOOL(NSString* value) {
         
         BOOL le =NO;//是否能走下一步
         if (value.length>0) {
             char r = [value characterAtIndex:value.length-1];
             if (r<48||r>57){
                 NSString *str=[NSString stringWithCString:&r  encoding:NSUTF8StringEncoding];
                 self->phoneField.text = [value stringByReplacingOccurrencesOfString:str withString:@""];
             }
         }
         
        if (value.length == 11)
            le = YES;
        else if (value.length>11)
            self->phoneField.text = [value substringToIndex:11];
         
//         if (value.length < 11){
//             self->codeBtn.layer.borderWidth = 1;
//             self->codeBtn.backgroundColor = [UIColor clearColor];
//         }
        
        return le;
    }]subscribeNext:^(NSString* x) {
        if([self isMobileNumber:x]){
//            self->codeBtn.layer.borderWidth = 0;
//            self->codeBtn.backgroundColor = [UIColor colorWithHexString:kMainPinkColor];
            
        }else{
            NSLog(@"no");
            [YIToast showText:@"请输入正确的电话号"];
        }
       
    }];
}

#pragma mark 设置验证码输入框
-(void)setupCodeField{
//     UITextField* teft = codeField;
//    [[codeField.rac_textSignal
//     filter:^BOOL(NSString* value) {
//        BOOL le =NO;
//        if (value.length>0) {
//            char r = [value characterAtIndex:value.length-1];
//            if (r<48||r>57){
//                NSString *str=[NSString stringWithCString:&r  encoding:NSUTF8StringEncoding];
//                teft.text = [value stringByReplacingOccurrencesOfString:str withString:@""];
//            }
//        }
//         if (value.length == 6)
//             le = YES;
//         else if (value.length>6)
//             teft.text = [value substringToIndex:6];
//         
//        return le;
//    }]subscribeNext:^(id x) {
//        
//    }];
    
    codeFieldSignal =[codeField.rac_textSignal
                      map:^id(NSString* value) {
        //return @(value.length == 6?YES:NO);
                          return @(value.length>0);
    }];
}

#pragma mark 设置验证码按钮
-(void)setupCodeBtn{
    //UIButton* btn = codeBtn ;
    UITextField* field = phoneField;
    
//    [[codeBtn rac_signalForControlEvents:UIControlEventTouchDown]
//     subscribeNext:^(UIButton* x) {
//         x.layer.borderWidth = 1;
//         x.backgroundColor = [UIColor clearColor];
//     }];
//    
//    [[codeBtn rac_signalForControlEvents:UIControlEventTouchDragExit]
//     subscribeNext:^(UIButton* x) {
//         x.layer.borderWidth = 0;
//         x.backgroundColor = [UIColor colorWithHexString:kMainPinkColor];
//     }];
    
    
    [[codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
        if (self->phoneField.text.length!=11) {
             return ;
         }
        [LLARingSpinnerView RingSpinnerViewStart1andStyle:1];
        // x.enabled=NO;
         [self.view endEditing:YES];
        UNILoginViewRequest* request = [[UNILoginViewRequest alloc]init];
         [request postWithoutUserIdSerCode:@[API_URL_Verify]
                           params:@{@"phone":field.text}];
        
        request.rqvertifivaBlock = ^(int status,
                                     int sex,
                                     NSString* name,
                                     NSString* ph,
                                     long st,
                                     NSString* rc,
                                     NSString*tip,
                                     NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                [LLARingSpinnerView RingSpinnerViewStop1];
                self->codeField.text = @"";
                if (er) {
                    x.enabled=YES;
                    [YIToast showWithText:NETWORKINGPEOBLEM];
                    return ;
                }
                
                if(!ph){
                    x.enabled=YES;
                    [UIAlertView showWithTitle:tip message:nil style:UIAlertViewStyleDefault cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {}];
                    return ;
                }
                self.sex = sex;
                self->nikeName.text = name;
                if (sex == 1)
                    [self maleBtnSelect];
                if (sex == 2)
                    [self femaleBtnSelect];
                
                if (ph != nil){
                   // btn.enabled = NO;
                    self->countDown = 60;
                    //self->ServierTime = [NSDate dateWithTimeIntervalSince1970:st];
                    self->ServierTime = [NSDate date];
                    
                   self->time=[NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(sixtySecondCountDown:)
                                                   userInfo:nil
                                                    repeats:YES];
                    
                }
                   
            });
            
        };
 
    }];
 
}
#pragma mark 验证码定时器事件
-(void)sixtySecondCountDown:(NSTimer*)time1{
    if (countDown>1) {
        int t = [[NSDate date] timeIntervalSinceDate:ServierTime];
        countDown = 60-t;
        NSString* str = [NSString stringWithFormat:@"%ds",countDown];
        [codeBtn setTitle:str forState:UIControlStateNormal];
        phoneField.enabled=NO;
        
    }else
        [self timerStop:time];
}

#pragma mark 定时器强制停止
-(void)timerStop:(NSTimer*)time1{
    [time invalidate];
    time = nil;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.enabled=YES;
    phoneField.enabled=YES;
}

#pragma mark 设置昵称输入框
-(void)setupNikeName{
    nikeSignal =[nikeName.rac_textSignal map:^id(NSString* value) {
       return  @(value.length > 3?YES:NO);
    }];
}

#pragma mark 设置登陆按钮
-(void)setupLoginBtn{
    UITextField* field1 = phoneField;
    UITextField* field2 = codeField;
    UITextField* field3 = nikeName;
    loginBtn.enabled = NO;
    RAC(loginBtn,enabled) = [RACSignal combineLatest:@[codeFieldSignal]
                                              reduce:^id(NSNumber* code){
//                                                  if (code.boolValue) {
//                                                      self->loginBtn.backgroundColor = [UIColor colorWithHexString:kMainPinkColor];
//                                                      self->loginBtn.layer.borderWidth = 0;
//                                                  }else{
//                                                      self->loginBtn.backgroundColor = [UIColor clearColor];
//                                                      self->loginBtn.layer.borderWidth = 1;
//
//                                                  }
                                                  return @([code boolValue]);
                                              }];

    
//    [[loginBtn rac_signalForControlEvents:UIControlEventTouchDown]
//     subscribeNext:^(UIButton* x) {
//         x.layer.borderWidth = 1;
//         x.backgroundColor = [UIColor clearColor];
//     }];
//    [[loginBtn rac_signalForControlEvents:UIControlEventTouchDragExit]
//     subscribeNext:^(UIButton* x) {
//         x.layer.borderWidth = 0;
//         x.backgroundColor = [UIColor colorWithHexString:kMainPinkColor];
//     }];
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
          x.layer.borderWidth = 0;
         x.backgroundColor = [UIColor colorWithHexString:kMainPinkColor];
         [self.view endEditing:YES];
         //id sx = @(self.sex); //默认性别
         if (self->nikeName.text.length==0) {
#ifdef IS_IOS9_OR_LATER
             UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"请输入称谓名!" message:nil preferredStyle:UIAlertControllerStyleAlert];
             
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
             [alertController addAction:cancelAction];
             [self presentViewController:alertController animated:YES completion:nil];
#else
             [UIAlertView showWithTitle:@"请输入称谓名!" message:nil style:UIAlertViewStyleDefault cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                 if (buttonIndex>0)
                     [[UIApplication sharedApplication]openURL:[NSURL URLWithString:url]];
             }];
#endif

                 return ;
             }
         
         x.enabled = NO;
         [LLARingSpinnerView RingSpinnerViewStart1andStyle:1];
        UNILoginViewRequest* request = [[UNILoginViewRequest alloc]init];
        [request postWithoutUserIdSerCode:@[API_URL_Login]
                                params:@{@"code":field1.text,
                                            @"password":field2.text,
                                            @"name":field3.text,
                                            @"sex":@(self.sex)}];
        
        request.rqloginBlock = ^(int extra,
                                 NSArray* array,
                                 NSString* tips,
                                 NSError* er){
            x.enabled = YES;
             [LLARingSpinnerView RingSpinnerViewStop1];
            if (er==nil) {
                if (array.count == 0){
                    [UIAlertView showWithTitle:tips message:tips style:UIAlertViewStyleDefault cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {}];

                    return ;
                }
                if (array.count == 1) {
                    UNILoginShopModel* model = array[0];
                    //保存信息
                    [AccountManager setToken:model.token];
                    //[AccountManager setUserId:@(model.userId)];
                    [AccountManager setShopId:@(model.shopId)];
                    [AccountManager setLocalLoginName:field1.text];
                    
                    //保存用户上次登录的电话号码
                   // [[NSUserDefaults standardUserDefaults]setObject:field1.text forKey:LASTUSERLOGINNAME];
                    
                    //跳转
                    [self log:nil];
                }
                if (array.count > 1) {
                    UNILoginShopList* list = [[UNILoginShopList alloc]init];
                    list.extra = extra;
                    list.phone = field1.text;
                    list.randcode = field2.text;
                    list.myData = [NSMutableArray arrayWithArray:array];
                    UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:list];
                    [self presentViewController:nav animated:YES completion:nil];
                }
            }else
                [YIToast showText:NETWORKINGPEOBLEM];
        };
        
    }];
}
#pragma mark 设置男女性别按钮
-(void)setupSexBtn{
 

    UIImage* image2 =[UIImage imageNamed:@"login_btn_sfemale"];
    UIImage* image3 =[UIImage imageNamed:@"login_btn_male"];
    UIImage* image5 =[UIImage imageNamed:@"login_btn_male1"];
    UIImage* image6 =[UIImage imageNamed:@"login_btn_female1"];
    
    [maleBtn setImage:image5 forState:UIControlStateNormal];
    [femaleBtn setImage:image6 forState:UIControlStateNormal];
    
    [maleBtn setImage:image3 forState:UIControlStateSelected];
    [femaleBtn setImage:image2 forState:UIControlStateSelected];

    [maleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [femaleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
     [maleBtn setTitleColor:[UIColor colorWithHexString:@"af6ff0"] forState:UIControlStateSelected];
     [femaleBtn setTitleColor:[UIColor colorWithHexString:kMainPinkColor] forState:UIControlStateSelected];

    
    [[maleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         self->femaleBtn.selected = NO;
         x.selected=YES;
         self.sex = 1;
         //[self maleBtnSelect];
    }];
    
    [[femaleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         self->maleBtn.selected = NO;
         x.selected=YES;
         self.sex = 2;
         //[self femaleBtnSelect];
    }];
}
#pragma mark 选中男性按钮
-(void)maleBtnSelect{
     self.sex = 1;
     UIImage* image4 =[UIImage imageNamed:@"login_btn_smale"];
     UIImage* image1 =[UIImage imageNamed:@"login_btn_female"];
    
    [maleBtn setImage:image4 forState:UIControlStateNormal];
    [femaleBtn setImage:image1 forState:UIControlStateNormal];
    
    [maleBtn setTitleColor:[UIColor colorWithHexString:kMainPinkColor] forState:UIControlStateNormal];
    [femaleBtn setTitleColor:[UIColor colorWithHexString:@"af6ff0"] forState:UIControlStateNormal];
}
#pragma mark 选中女性按钮
-(void)femaleBtnSelect{
    self.sex = 2;
    UIImage* image4 =[UIImage imageNamed:@"login_btn_male"];
    UIImage* image1 =[UIImage imageNamed:@"login_btn_sfemale"];
    
    [maleBtn setImage:image4 forState:UIControlStateNormal];
    [femaleBtn setImage:image1 forState:UIControlStateNormal];
    
    [maleBtn setTitleColor:[UIColor colorWithHexString:@"af6ff0"] forState:UIControlStateNormal];
    [femaleBtn setTitleColor:[UIColor colorWithHexString:kMainPinkColor] forState:UIControlStateNormal];
}

#pragma mark 添加键盘BTkeyBoardTool
-(void)addBTkeyBoardTool{
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate=self;
    [tool dismissTwoBtn];
    phoneField.inputAccessoryView=tool;
    codeField.inputAccessoryView=tool;
    nikeName.inputAccessoryView=tool;
    phoneField.tag = 4;
    codeField.tag = 5;
    nikeName.tag = 6;
}

-(void)keyboardTool:(BTKeyboardTool*)tool buttonClick:(KeyBoardToolButtonType)type{
    switch (type)
    {
        case kKeyboardToolButtonTypeDone:
            [self.view endEditing:YES];
            break;
        case kKeyboardToolButtonTypeNext:{//下一个
            UITextField *responder=[self findFirstResponder];
            //取出下一个响应者
            int tag =(int)responder.tag+1;
            if (tag>6)
                tag=6;
            UITextField *newResponder=(UITextField*)[self.view viewWithTag:tag];
            //传递第一响应者
            [newResponder becomeFirstResponder];}
            break;
        case kKeyboardToolButtonTypePervious:{//上一个
            UITextField *responder=[self findFirstResponder];
            //取出下一个响应者
            int tag =(int)responder.tag-1;
            if (tag<4)
                tag=4;
            UITextField *newResponder=(UITextField*)[self.view viewWithTag:tag];
            //传递第一响应者
            [newResponder becomeFirstResponder];}
            break;}

}

#pragma mark 检查当前哪个textField 是第一响应者
-(UITextField*)findFirstResponder{
    NSArray* textFields = @[phoneField,codeField,nikeName];
    for (UITextField* textfield in textFields) {
        if ([textfield respondsToSelector:@selector(isFirstResponder)]&&[textfield isFirstResponder]) {
            return textfield;
        }
    }
    return nil;
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
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification*)notifi{

     [self.scrollerView setContentOffset:CGPointMake(0, KMainScreenHeight*0.2) animated:YES];
}
#pragma mark 键盘隐藏
-(void)keyboardWillHide:(NSNotification*)notifi{
    //self.scrollerView.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
    [self.scrollerView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)log:(id)sender {
    //self.view.window.backgroundColor = [UIColor whiteColor];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [app setupViewController];
    
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * CU = @"^1([3-8][0-9])\\d{8}$";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    if (([regextestcu evaluateWithObject:mobileNum] == YES))
        return YES;
    else
        return NO;
    
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

#pragma mark 旋转光圈 开始旋转
-(void)rotationTheImg{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10000000000000;
    [_rotationImg.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
   // [self performSelector:@selector(rotationTheImg) withObject:nil afterDelay:2.5];
}

@end
