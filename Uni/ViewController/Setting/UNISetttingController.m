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
@interface UNISetttingController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSString* phone;
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
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction:)];
    
}

-(void)setupUI{
    float labH = KMainScreenWidth* 80/320;
    float labY = KMainScreenHeight - labH ;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, labY, KMainScreenWidth, labH)];
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth*10/320];
    lab.numberOfLines = 0;
    lab.lineBreakMode = 0;
    lab.text = @"广州由你电子商务有限公司 版权所有\n Copyright @2014-2021.\n All Rights Reserved";
    [self.view addSubview:lab];
    
    float tabY = 64;
    float tabH = KMainScreenHeight - tabY - labH;
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY,KMainScreenWidth, tabH) style:UITableViewStylePlain];
    tab.delegate = self;
    tab.dataSource = self;
    tab.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tab];
    tab.tableFooterView = [UIView new];
    [self setupTabHeaderView:tab];
}
-(void)setupTabHeaderView:(UITableView*)tab{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, KMainScreenWidth*150/320)];
    
    UIImage* img = [UIImage imageNamed:@"login_img_header"];
    float imgW = KMainScreenWidth/6;
    float imgH = img.size.height * imgW / img.size.width;
    float imgX =( view.frame.size.width - imgW )/ 2;
    UIImageView* imgview = [[UIImageView alloc]init];
    imgview.frame = CGRectMake(imgX, 20, imgW, imgH);
    imgview.image = img;
    [view addSubview:imgview];
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imgview.frame), KMainScreenWidth, KMainScreenWidth*15/320)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?13:10];
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab.text = @"由你";
    [view addSubview:lab];
    tab.tableHeaderView = view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"联系我们";
            break;
        case 1:
            cell.textLabel.text = @"关于我们";
            break;
        case 2:
            cell.textLabel.text = @"法律声明";
            break;
    }
    cell.textLabel.textColor= [UIColor colorWithHexString:kMainBlackTitleColor];
    cell.textLabel.font = [UIFont systemFontOfSize:KMainScreenWidth*13/320];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        UNIAboutUsController* ab = [[UNIAboutUsController alloc]init];
        [self.navigationController pushViewController:ab animated:YES];
    }
    if (indexPath.row == 2) {
        UNILawViewController* ab = [[UNILawViewController alloc]init];
        [self.navigationController pushViewController:ab animated:YES];
    }if (indexPath.row == 0) {
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
    
}//02038904856
#pragma mark 功能按钮事件
-(void)navigationControllerLeftBarAction:(UIBarButtonItem*)bar{
    if (self.containController.closing) {
        [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWOPEN object:nil];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:CONTAITVIEWCLOSE object:nil];
    }
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
