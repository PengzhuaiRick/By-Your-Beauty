//
//  UNIAboutUsController.m
//  Uni
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIAboutUsController.h"

@interface UNIAboutUsController ()

@end

@implementation UNIAboutUsController
-(void)viewWillAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"关于我们"];
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"关于我们"];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
}
-(void)setupNavigation{
    self.title = @"关于我们";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction)];
    
}

-(void)setupUI{
    float viewY =64+15;
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0,viewY, KMainScreenWidth, KMainScreenHeight - viewY)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    UIImage* img = [UIImage imageNamed:@"login_img_header"];
    float imgW = KMainScreenWidth/6;
    float imgH = img.size.height * imgW / img.size.width;
    float imgX =( view.frame.size.width - imgW )/ 2;
    UIImageView* imgview = [[UIImageView alloc]init];
    imgview.frame = CGRectMake(imgX, 20, imgW, imgH);
    imgview.image = img;
    [view addSubview:imgview];
    
    float k = KMainScreenWidth>400?90:40;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(imgview.frame)+k, KMainScreenWidth-30, KMainScreenWidth*15/320)];
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?18:14];
    lab.textColor = [UIColor colorWithHexString:kMainBlackTitleColor];
    lab.numberOfLines = 0;
    lab.lineBreakMode = 0;
    lab.text = @"广州由你电子商务有限公司（简称由你）于2015年创立，是澳亚集团旗下的一家互联网技术公司。依托于多年运营的经验及渠道资源，由你电子商务公司致力于为美容院提供O2O一体化营销解决方案，为消费者打造跨场景、极致高效与专业的美容消费体验。";
    [lab sizeToFit];
    [view addSubview:lab];
    
    
    float labH = KMainScreenWidth* 80/320;
    float labY = view.frame.size.height - labH ;
    UILabel* lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, labY, KMainScreenWidth, labH)];
    lab1.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab1.textAlignment = NSTextAlignmentCenter;
    lab1.font = [UIFont systemFontOfSize:KMainScreenWidth*11/320];
    lab1.numberOfLines = 0;
    lab1.lineBreakMode = 0;
    lab1.text = @"广州由你电子商务有限公司 版权所有\n Copyright @2014-2021.\n All Rights Reserved";
    [view addSubview:lab1];

}
-(void)navigationControllerLeftBarAction{
    [self.navigationController popViewControllerAnimated:YES];
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
