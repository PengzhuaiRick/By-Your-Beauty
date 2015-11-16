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
@interface LoginController (){
    
    __weak IBOutlet UITextField *codeField;    //验证码
    __weak IBOutlet UITextField *phoneField;
    __weak IBOutlet UITextField *nikeName;
    __weak IBOutlet UIButton *maleBtn;
    __weak IBOutlet UIButton *femaleBtn;
    __weak IBOutlet UIButton *codeBtn;         //验证码
    __weak IBOutlet UIButton *loginBtn;
    
    RACSignal *phoneSignal;
    RACSignal *codeFieldSignal;
    RACSignal *nikeSignal;
    
    NSTimer* time;
    int countDown;
}
@property (weak, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *thirldCell;

@property(nonatomic,assign)int sex;
@end

@implementation LoginController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sex = 2;
    [self setupPhoneField];
    [self setupCodeField];
    [self setupCodeBtn];
    [self setupNikeName];
    [self setupLoginBtn];
}

#pragma mark 设置手机号码
-(void)setupPhoneField{
    UITextField* teft = phoneField;
    [[phoneField.rac_textSignal
     filter:^BOOL(NSString* value) {

         BOOL le =NO;//是否能走下一步
         if (value.length>0) {
             char r = [value characterAtIndex:value.length-1];
             if (r<48||r>57){
                 NSString *str=[NSString stringWithCString:&r  encoding:NSUTF8StringEncoding];
                 teft.text = [value stringByReplacingOccurrencesOfString:str withString:@""];
             }
         }
         
        if (value.length == 11)
            le = YES;
        else if (value.length>11)
            teft.text = [value substringToIndex:11];
        
        return le;
    }]subscribeNext:^(NSString* x) {
        if([self isMobileNumber:x]){
            NSLog(@"yes");

        }else{
            NSLog(@"no");
        }
       
    }];
    
    phoneSignal =
    [phoneField.rac_textSignal
     map:^id(NSString *text) {
         if(![self isMobileNumber:text])
             return @(NO);
        return @(text.length == 11?YES:NO);
     }];

}

#pragma mark 设置验证码输入框
-(void)setupCodeField{
     UITextField* teft = codeField;
    [[codeField.rac_textSignal
     filter:^BOOL(NSString* value) {
        BOOL le =NO;
        if (value.length>0) {
            char r = [value characterAtIndex:value.length-1];
            if (r<48||r>57){
                NSString *str=[NSString stringWithCString:&r  encoding:NSUTF8StringEncoding];
                teft.text = [value stringByReplacingOccurrencesOfString:str withString:@""];
            }
        }
         if (value.length == 6)
             le = YES;
         else if (value.length>6)
             teft.text = [value substringToIndex:6];
         
        return le;
    }]subscribeNext:^(id x) {
        
    }];
    
    codeFieldSignal =[codeField.rac_textSignal
                      map:^id(NSString* value) {
        return @(value.length == 6?YES:NO);
    }];
}

#pragma mark 设置验证码按钮
-(void)setupCodeBtn{
    UIButton* btn = codeBtn ;
    UITextField* field = phoneField;
    countDown =60 ;
    __block NSTimer* t1 = time;
    
    codeBtn.enabled = NO;
    [RAC(codeBtn,enabled) = phoneSignal map:^id(NSNumber* value) {
        NSLog(@"%@",value);
        return value;
    }];
    
    [[codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
        [LLARingSpinnerView RingSpinnerViewStart];
        UNILoginViewRequest* request = [[UNILoginViewRequest alloc]init];
         [request postWithSerCode:@[API_PARAM_SSMS,
                                    API_URL_Login]
                           params:@{@"phone":field.text}];
        
        request.rqvertifivaBlock = ^(NSString* ph,
                                     NSString* llt,
                                     NSString* rc,
                                     NSString*tip,
                                     NSError* er){
            [LLARingSpinnerView RingSpinnerViewStop];
            if (llt) {
                if (self.thirldCell.alpha==1) {
                    CGRect p1 = self.firstCell.frame;
                    CGRect p2 = self.secondCell.frame;
                    p1.origin.y+=44;
                    p2.origin.y+=44;
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        self.thirldCell.alpha = 0;
                        self.firstCell.frame = p1;
                        self.secondCell.frame =p2;
                    }];

                }
            }else{
                if (self.thirldCell.alpha == 0) {
                    CGRect p1 = self.firstCell.frame;
                    CGRect p2 = self.secondCell.frame;
                    p1.origin.y-=44;
                    p2.origin.y-=44;
                    [UIView animateWithDuration:0.5 animations:^{
                        self.thirldCell.alpha = 1;
                        self.firstCell.frame = p1;
                        self.secondCell.frame =p2;
                    }];

                }
            }
            
            if (rc != nil){
                btn.enabled = NO;
                t1 = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(sixtySecondCountDown)
                                                    userInfo:nil
                                                     repeats:YES];
            }
        };
 
    }];
 
}
#pragma mark 验证码定时器事件
-(void)sixtySecondCountDown{
    if (countDown>1) {
        countDown -- ;
        NSString* str = [NSString stringWithFormat:@"%ds",countDown];
        [codeBtn setTitle:str forState:UIControlStateNormal];
    }else
        [self timerStop];
    
}

#pragma mark 定时器强制停止
-(void)timerStop{
    [time invalidate];
    time = nil;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.enabled=YES;
    countDown = 60;
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
    RAC(loginBtn,enabled) = [RACSignal combineLatest:@[phoneSignal,codeFieldSignal]
                                              reduce:^id(NSNumber* phone,
                                                         NSNumber* code){
          return @([phone boolValue]&&[code boolValue]);
    }];
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
        [LLARingSpinnerView RingSpinnerViewStart];
         
         id sx = @(self.sex); //默认性别
         if (self.thirldCell.alpha==0)
             sx=@"";
         else{
             if (self->nikeName.text.length==0) {
                 [YIToast showWithText:@"请输入昵称!"];
                 return ;
             }
            
         }
        UNILoginViewRequest* request = [[UNILoginViewRequest alloc]init];
        [request postWithSerCode:@[API_PARAM_UNI,
                                   API_URL_Login]
                                params:@{@"code":field1.text,
                                            @"password":field2.text,
                                            @"name":field3.text,
                                            @"sex":sx}];
        
        request.rqloginBlock = ^(int userId,
                                 int shopId,
                                 NSString* token,
                                 NSString* tips,
                                 NSError* er){
             [LLARingSpinnerView RingSpinnerViewStop];
            if (er==nil) {
                //保存信息
                [AccountManager setToken:token];
                [AccountManager setUserId:@(userId)];
                [AccountManager setShopId:@(shopId)];
                //跳转
                self.view.window.backgroundColor = [UIColor whiteColor];
                AppDelegate* app = [UIApplication sharedApplication].delegate;
                [app setupViewController];
            }else
                NSLog(@"%@",er);
           // [YIToast showWithText:tips];
        };
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)log:(id)sender {
    self.view.window.backgroundColor = [UIColor whiteColor];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    [app setupViewController];
    
}

- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString * CU = @"^1([3-8][0-8])\\d{8}$";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    if (([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
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
