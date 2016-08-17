//
//  UNIAboutUsController.m
//  Uni
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIAboutUsController.h"

@interface UNIAboutUsController ()
@property (weak, nonatomic) IBOutlet UIImageView *rotationImg;
@property (weak, nonatomic) IBOutlet UILabel *mainLab;

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
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(navigationControllerLeftBarAction)];
    
}

-(void)setupUI{
    _mainLab.font = kWTFont(14);
    
    NSMutableAttributedString *string =[[NSMutableAttributedString alloc]initWithString:_mainLab.text];
    long number = KMainScreenWidth* 14/414;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:number];//调整行间距
    
    [string addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_mainLab.text length])];
    
    _mainLab.attributedText = string;

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
