//
//  LoginController.m
//  Uni
//
//  Created by apple on 15/11/10.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "LoginController.h"
#import "AppDelegate.h"
#import "UNILoginViewModel.h"

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
}
@end

@implementation LoginController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPhoneField];
    [self setupCodeField];
    [self setupCodeBtn];
    [self setupNikeName];
    [self setupLoginBtn];
}

-(void)setupPhoneField{
    UITextField* teft = phoneField;
    [[phoneField.rac_textSignal
     filter:^BOOL(NSString* value) {

         BOOL le =NO;
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
             return @(text.length == 11?YES:NO);
     }];

}

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
    
    codeFieldSignal =[codeField.rac_textSignal map:^id(NSString* value) {
        return @(value.length == 6?YES:NO);
    }];
}

-(void)setupCodeBtn{
    codeBtn.enabled = NO;
    [RAC(codeBtn,enabled) = phoneSignal map:^id(NSNumber* value) {
        NSLog(@"%@",value);
        return value;
    }];
    [[codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        NSLog(@"hahah ");
    }];
}

-(void)setupNikeName{
    nikeSignal =[nikeName.rac_textSignal map:^id(NSString* value) {
       return  @(value.length > 3?YES:NO);
    }];
}

-(void)setupLoginBtn{
    loginBtn.enabled = NO;
    RAC(loginBtn,enabled) = [RACSignal combineLatest:@[phoneSignal,codeFieldSignal,nikeSignal]
                                              reduce:^id(NSNumber* phone,NSNumber* code,NSNumber* nike){
          return @([phone boolValue]&&[code boolValue]&&[nike boolValue]);
    }];
    [[loginBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
         NSLog(@" heheh ehahah ");
        self.view.window.backgroundColor = [UIColor whiteColor];
        AppDelegate* app = [UIApplication sharedApplication].delegate;
        [app setupViewController];
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
