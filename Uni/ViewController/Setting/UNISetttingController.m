//
//  UNISetttingController.m
//  Uni
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNISetttingController.h"
#import "UNIAboutUsController.h"
#import "UNILawViewController.h"
#import "AccountManager.h"
#import "UNIShopManage.h"
#import "AppDelegate.h"
#import "UNAlertShowController.h"
@interface UNISetttingController ()
@property(nonatomic,copy)NSString* phone;
@property (weak, nonatomic) IBOutlet UIImageView *apertureImg;//旋转光圈
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UILabel *crLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;//退出按钮

@end

@implementation UNISetttingController
-(void)viewWillAppear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=YES;
        }
    }
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"设置页面"];
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSArray* array =self.containController.view.gestureRecognizers;
    for (UIGestureRecognizer* ges in array) {
        if ([ges isKindOfClass:[UIPanGestureRecognizer class]]) {
            ges.enabled=NO;
        }
    }
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"设置页面"];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
    [self requestTheUniPhone];
}
-(void)setupNavigation{
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

-(void)setupUI{
    _logoutBtn.layer.masksToBounds=YES;
    _logoutBtn.layer.cornerRadius = _logoutBtn.frame.size.height/2;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row == 1) {
//        UNIAboutUsController* ab = [[UNIAboutUsController alloc]init];
//        [self.navigationController pushViewController:ab animated:YES];
//    }
//    if (indexPath.row == 2) {
//        UNILawViewController* ab = [[UNILawViewController alloc]init];
//        [self.navigationController pushViewController:ab animated:YES];
//    }if (indexPath.row == 0) {
//        if (!self.phone)
//            return;
//
//        NSString* str = [NSString stringWithFormat:@"是否拨打电话%@",self.phone];
//        [UIAlertView showWithTitle:str message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"拨打"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
//            if (buttonIndex == 1) {
//                //NSString* tel = @"tel://02038904856";
//                NSString* tel =[NSString stringWithFormat:@"tel://%@",self.phone];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
//            }
//        }];
//        [[BaiduMobStat defaultStat]logEvent:@"btn_setting_call" eventLabel:@"设置拨打电话按钮"];
//    }
//    
//}//02038904856
-(void)cleanAndJump{
    [AccountManager clearAll];
    [UNIShopManage cleanShopinfo];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    AppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate judgeFirstTime];
}


#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 联系我们 方法
- (IBAction)contactUsAction:(id)sender {
    if (!self.phone)
        return;
    
    NSString* str = [NSString stringWithFormat:@"是否拨打电话%@",self.phone];
    [UIAlertView showWithTitle:str message:nil cancelButtonTitle:@"取消" otherButtonTitles:@[@"拨打"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            //NSString* tel = @"tel://02038904856";
            NSString* tel =[NSString stringWithFormat:@"tel://%@",self.phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
    }];
    [[BaiduMobStat defaultStat]logEvent:@"btn_setting_call" eventLabel:@"设置拨打电话按钮"];
}
#pragma mark 关于我们 方法
- (IBAction)aboutUsAction:(id)sender {
//    UNIAboutUsController* ab = [[UNIAboutUsController alloc]init];
//    [self.navigationController pushViewController:ab animated:YES];
    
    UIStoryboard* st = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
    UIViewController* view =[st instantiateViewControllerWithIdentifier:@"UNIAboutUsController"];
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark 退出 方法
- (IBAction)logOut:(id)sender {
    
    UIStoryboard* story = [UIStoryboard storyboardWithName:@"Guide" bundle:nil];
    UNAlertShowController* view = [story instantiateViewControllerWithIdentifier:@"UNAlertShowController"];
    view.view.backgroundColor = [UIColor clearColor];
    
    // 设置代理信号
    view.delegateSignal = [RACSubject subject];
    
    __weak UNISetttingController* myself =self;
    // 订阅代理信号
    [view.delegateSignal subscribeNext:^(id x) {
        [myself cleanAndJump];
    }];

    if (IOS_VERSION>=8.0)
        view.modalPresentationStyle=UIModalPresentationOverCurrentContext;
    else
        self.modalPresentationStyle=UIModalPresentationCurrentContext;
    
    [self presentViewController:view animated:NO completion:^{
        //  view.view.superview.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.3 animations:^{
            
        }];
        
    }];

}

#pragma mark 请求公司电话
-(void)requestTheUniPhone{
    __weak UNISetttingController* myself = self;
    UNILawRequest * req = [[UNILawRequest alloc]init];
    req.getUniPhone=^(int code,NSString* phone,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (phone)
            myself.phone = phone;
        else
           [YIToast showText:tips];
    };
    [req postWithSerCode:@[API_URL_getUNIPhone] params:nil];
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
