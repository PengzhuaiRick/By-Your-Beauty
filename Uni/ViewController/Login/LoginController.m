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

@interface LoginController ()<KeyboardToolDelegate>{
    
      UITextField *codeField;    //验证码
      UITextField *phoneField;
      UITextField *nikeName;
      UIButton *maleBtn;
      UIButton *femaleBtn;
      UIButton *codeBtn;         //验证码
      UIButton *loginBtn;
    UIImageView *headImge;
    
    RACSignal *phoneSignal;
    RACSignal *codeFieldSignal;
    RACSignal *nikeSignal;
    
    //NSTimer* time;
    int countDown;
    int imgH;
    int bShu;
    int cellH;
}
@property (strong, nonatomic)  UITableViewCell *secondCell;
@property (strong, nonatomic)  UITableViewCell *firstCell;
@property (strong, nonatomic)  UITableViewCell *thirldCell;

@property(nonatomic,assign)int sex; // 男1 女2
@end

@implementation LoginController
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillShowNotification
                                                 object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:UIKeyboardWillHideNotification
                                                 object:nil];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _sex = 2;
    [self setupUI];
    [self setupFooterView];
   // [self setupPhoneField];
//    [self setupCodeField];
//    [self setupCodeBtn];
 //   [self setupNikeName];
  //  [self setupLoginBtn];
   // [self setupSexBtn];
    [self regirstKeyBoardNotification];
}
-(void)setupFooterView{
    UIView* footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 100)];
    self.tableView.tableFooterView = footer;
    
    float btnWH = KMainScreenWidth* 70/320;
    float btnX = (footer.frame.size.width -btnWH)/2;
    float btnY = 30;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*17/320];
    [btn setBackgroundColor:[UIColor colorWithHexString:kMainGreenBackColor]];
    btn.layer.masksToBounds=YES;
    btn.layer.cornerRadius = btnWH/2;
    [footer addSubview:btn];
    loginBtn = btn;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellH;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* name = @"cell";
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:name];
    if (indexPath.row ==  0) {
        [self setupFirstCell:cell];
        self.firstCell = cell;
    }
    if (indexPath.row ==  1) {
         [self setupSecondCell:cell];
        self.secondCell = cell;
    }
    if (indexPath.row ==  2) {
        [self setupThirdCell:cell];
        self.thirldCell = cell;
    }
    return cell;
}
-(void)setupFirstCell:(UITableViewCell*)cell{
    float imgX = 30;
    float imgWH = cellH /2;
    float imgY = (cellH - imgWH )/2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.image = [UIImage imageNamed:@"login_img_phone"];
    [cell addSubview:img];
    
    float tetX = CGRectGetMaxX(img.frame)+5;
    float tetW = self.tableView.frame.size.width - imgX - tetX;
    UITextField* field = [[UITextField alloc]initWithFrame:CGRectMake(tetX, imgY, tetW, imgWH)];
    field.placeholder = @"请输入手机号码";
    field.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    [cell addSubview:field];
    phoneField = field;
    
    float layY = CGRectGetMaxY(img.frame);
    float layW = CGRectGetMaxX(field.frame) - imgX;
    CALayer* lay = [CALayer layer];
    lay.frame = CGRectMake(imgX, layY, layW, 0.5);
    lay.backgroundColor = kMainGrayBackColor.CGColor;
    [cell.layer addSublayer:lay];
    
    [self setupPhoneField];
}
-(void)setupSecondCell:(UITableViewCell*)cell{
    float imgX = 30;
    float imgWH = cellH /2;
    float imgY = (cellH - imgWH )/2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.image = [UIImage imageNamed:@"login_img_code"];
    [cell addSubview:img];
    
    float btnW = KMainScreenWidth* 100/320;
    float btnX = self.tableView.frame.size.width - imgX - btnW;
    float btnH = imgWH+5;
    float btnY = imgY-5;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [btn setTitle:@"获取验证码" forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 5;
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
    [btn setBackgroundColor:[UIColor colorWithHexString:kMainThemeColor]];
    [cell addSubview:btn];
    codeBtn = btn;
    
    float tetX = CGRectGetMaxX(img.frame)+5;
    float tetW = self.tableView.frame.size.width - imgX - tetX - btnW;
    UITextField* field = [[UITextField alloc]initWithFrame:CGRectMake(tetX, imgY, tetW, imgWH)];
    field.placeholder = @"请输入验证码";
    field.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    [cell addSubview:field];
    codeField = field;
    
    float layY = CGRectGetMaxY(img.frame);
    float layW = CGRectGetMaxX(field.frame)- imgX - 10;
    CALayer* lay = [CALayer layer];
    lay.frame = CGRectMake(imgX, layY, layW, 0.5);
    lay.backgroundColor = kMainGrayBackColor.CGColor;
    [cell.layer addSublayer:lay];
        
    [self setupCodeField];
    [self setupCodeBtn];
}
-(void)setupThirdCell:(UITableViewCell*)cell{
    float imgX = 30;
    float imgWH = cellH /2;
    float imgY = (cellH - imgWH )/2;
    UIImageView* img = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, imgY, imgWH, imgWH)];
    img.image = [UIImage imageNamed:@"login_img_nike"];
    [cell addSubview:img];
    
    float btnW = KMainScreenWidth* 100/320/2;
    float btnX = self.tableView.frame.size.width - imgX - btnW;
    float btnH = imgWH;
    float btnY = imgY ;
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [btn setTitle:@"先生" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.tag = 1;
    [cell addSubview:btn];
    maleBtn = btn;
    
    float btn1X = btnX - btnW;
    UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(btn1X, btnY, btnW, btnH);
    [btn1 setTitle:@"女士" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*12/320];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.tag = 2;
    [cell addSubview:btn1];
    femaleBtn = btn1;

    
    float tetX = CGRectGetMaxX(img.frame)+5;
    float tetW = self.tableView.frame.size.width - imgX - tetX - btnW*2 - 10;
    UITextField* field = [[UITextField alloc]initWithFrame:CGRectMake(tetX, imgY, tetW, imgWH)];
    field.placeholder = @"请输入昵称";
    field.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    [cell addSubview:field];
    nikeName = field;
    
    float layY = CGRectGetMaxY(img.frame);
    float layW = CGRectGetMaxX(field.frame)- imgX;
    CALayer* lay = [CALayer layer];
    lay.frame = CGRectMake(imgX, layY, layW, 0.5);
    lay.backgroundColor = kMainGrayBackColor.CGColor;
    [cell.layer addSublayer:lay];
    
    [self setupNikeName];
    [self setupSexBtn];
    [self setupLoginBtn];
    [self addBTkeyBoardTool];
}


-(void)setupUI{
    UIImage* topimage =[UIImage imageNamed:@"login_img_header"];
    CGFloat headerH =topimage.size.width*KMainScreenHeight/KMainScreenWidth;
    int nun = KMainScreenWidth;
    switch (nun) {
        case 320:
            bShu = 5;
            cellH = 47;
            break;
        case 375:
            bShu = 30;
            cellH = 55;
            break;
        case 414:
            bShu = 60;
            cellH = 70;
            break;
    }
    imgH =headerH+bShu;
    self.tableView.contentInset = UIEdgeInsetsMake(imgH, 0, 0, 0);
    headImge = [[UIImageView alloc]initWithFrame:CGRectMake(0, -imgH, KMainScreenWidth, headerH)];
    headImge.image =topimage;
    headImge.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView addSubview:headImge];
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
            [YIToast showText:@"请输入正确的电话号码"];
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
    
    codeBtn.enabled = NO;
    [RAC(codeBtn,enabled) = phoneSignal map:^id(NSNumber* value) {
        return value;
    }];
    
    [[codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
        [LLARingSpinnerView RingSpinnerViewStart];
         [self.view endEditing:YES];
        UNILoginViewRequest* request = [[UNILoginViewRequest alloc]init];
         [request postWithoutUserIdSerCode:@[API_PARAM_SSMS,
                                    API_URL_Login]
                           params:@{@"phone":field.text}];
        
        request.rqvertifivaBlock = ^(NSString* ph,
                                     NSString* llt,
                                     NSString* rc,
                                     NSString*tip,
                                     NSError* er){
            dispatch_async(dispatch_get_main_queue(), ^{
                [LLARingSpinnerView RingSpinnerViewStop];
                if (llt) {
                    if (self.thirldCell.alpha==1) {
                        CGRect p1 = self.firstCell.frame;
                        CGRect p2 = self.secondCell.frame;
                        p1.origin.y+=20;
                        p2.origin.y+=20;
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
                        p1.origin.y-=20;
                        p2.origin.y-=20;
                        [UIView animateWithDuration:0.5 animations:^{
                            self.thirldCell.alpha = 1;
                            self.firstCell.frame = p1;
                            self.secondCell.frame =p2;
                        }];
                        
                    }
                }
                if (rc != nil){
                    btn.enabled = NO;
                    self->countDown = 60;
                    [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(sixtySecondCountDown:)
                                                   userInfo:nil
                                                    repeats:YES];
                    
                }else
                    [YIToast showText:@"获取验证码失败"];
            });
            
        };
 
    }];
 
}
#pragma mark 验证码定时器事件
-(void)sixtySecondCountDown:(NSTimer*)time1{
    if (countDown>1) {
        countDown -- ;
        NSString* str = [NSString stringWithFormat:@"%ds",countDown];
        [codeBtn setTitle:str forState:UIControlStateNormal];
    }else
        [self timerStop:time1];
}

#pragma mark 定时器强制停止
-(void)timerStop:(NSTimer*)time1{
    [time1 invalidate];
    time1 = nil;
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.enabled=YES;
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
     subscribeNext:^(UIButton* x) {
         [self.view endEditing:YES];
         id sx = @(self.sex); //默认性别
         if (self.thirldCell.alpha==0)
             sx=@"";
         
         else{
             if (self->nikeName.text.length==0) {
                 [YIToast showWithText:@"请输入昵称!"];
                 return ;
             }
         }
         x.enabled = NO;
         [LLARingSpinnerView RingSpinnerViewStart];
        UNILoginViewRequest* request = [[UNILoginViewRequest alloc]init];
        [request postWithoutUserIdSerCode:@[API_PARAM_UNI,
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
            x.enabled = YES;
             [LLARingSpinnerView RingSpinnerViewStop];
            if (er==nil) {
                if (!token){
                    [YIToast showText:@"登陆失败"];
                    return ;
                }
                //保存信息
                [AccountManager setToken:token];
                [AccountManager setUserId:@(userId)];
                [AccountManager setShopId:@(shopId)];
                [AccountManager setLocalLoginName:field1.text];
                //跳转
                self.view.window.backgroundColor = [UIColor whiteColor];
                AppDelegate* app = [UIApplication sharedApplication].delegate;
                [app setupViewController];
            }else
                [YIToast showText:NETWORKINGPEOBLEM];
           // [YIToast showWithText:tips];
        };
        
    }];
}
#pragma mark 设置男女性别按钮
-(void)setupSexBtn{
    UIImage* image1 =[UIImage imageNamed:@"login_btn_sex1"];
    UIImage* image2 =[UIImage imageNamed:@"login_btn_sex2"];
    
    [maleBtn setImage:image2 forState:UIControlStateNormal];
    [femaleBtn setImage:image2 forState:UIControlStateNormal];
    
    [maleBtn setImage:image1 forState:UIControlStateSelected];
    [femaleBtn setImage:image1 forState:UIControlStateSelected];
    
    [maleBtn setImage:image1 forState:UIControlStateHighlighted];
    [femaleBtn setImage:image1 forState:UIControlStateHighlighted];
    
    femaleBtn.selected = YES;
    
    [[maleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         self->femaleBtn.selected = NO;
         x.selected = YES;
         self.sex = (int)x.tag;
    }];
    
    [[femaleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(UIButton* x) {
         self->maleBtn.selected = NO;
         x.selected=YES;
         self.sex = (int)x.tag;
     }];

}
#pragma mark 添加键盘BTkeyBoardTool
-(void)addBTkeyBoardTool{
    BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
    tool.toolDelegate=self;
    //[tool dismissTwoBtn];
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
    CGRect re =CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);

    NSDictionary *info = [notifi userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;

    UITextField* field = [self findFirstResponder];
    switch (field.tag) {
        case 4:{
            float xx = imgH+cellH+keyboardSize.height-KMainScreenHeight;
            if (xx>0) {
                re.origin.y-=xx;
                self.tableView.frame = re;}}
            break;
        case 5:{
            float xx = imgH+cellH*2+keyboardSize.height-KMainScreenHeight;
            if (xx>0) {
                re.origin.y-=xx;
               // re.size.height-=keyboardSize.height;
                self.tableView.frame = re;}}
            break;
        case 6:{
            float xx = imgH+cellH*3+keyboardSize.height-KMainScreenHeight;
            if (xx>0) {
                re.origin.y-=xx;
                self.tableView.frame = re;}}
            break;}
}
#pragma mark 键盘隐藏
-(void)keyboardWillHide:(NSNotification*)notifi{
    self.tableView.frame = CGRectMake(0, 0, KMainScreenWidth, KMainScreenHeight);
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
    NSString * CU = @"^1([3-8][0-9])\\d{8}$";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    if (([regextestcu evaluateWithObject:mobileNum] == YES))
        return YES;
    else
        return NO;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat y = scrollView.contentOffset.y; //如果有导航控制器，这里应该加上导航控制器的高度64
    if (y< -imgH) {
        CGRect frame = headImge.frame;
        frame.origin.y = y;
        frame.size.height = -y-bShu;
        headImge.frame = frame;
    }
    
}




@end
