//
//  UNIRewardDetail.m
//  Uni
//  我的奖励订单详细界面
//  Created by apple on 15/12/7.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardDetail.h"
#import "UNIRewardDetailCell1.h"
#import "UNIRewardDetailCell2.h"
#import "UNIRewardDetailCell3.h"
@interface UNIRewardDetail ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView* myTable;
@end

@implementation UNIRewardDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTableView];
}
-(void)setupNavigation{
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
}

-(void)setupTableView{
    float tabX = 10;
    float tabY = 64+8;
    float tabW = KMainScreenWidth - tabX*2;
    float tabH = KMainScreenHeight - tabX - tabY;
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.layer.masksToBounds=YES;
    tabview.layer.cornerRadius = 10;
    tabview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:tabview];
    self.myTable =tabview;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float num =0;
    switch (indexPath.row) {
        case 0:
            num =75;
            break;
        case 1:
              num =85;
            break;
        case 2:
              num =135;
            break;
    }
    return num;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UNIRewardDetailCell1* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIRewardDetailCell1" owner:self options:nil].lastObject;
        [cell setupCellContentWith:nil];
        return cell;
    }
    if (indexPath.row == 1) {
        UNIRewardDetailCell2* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIRewardDetailCell2" owner:self options:nil].lastObject;
        [cell setupCellContentWith:nil];
        return cell;
    }
    if (indexPath.row == 2) {
        UNIRewardDetailCell3* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIRewardDetailCell3" owner:self options:nil].lastObject;
        [cell setupCellContentWith:nil];
        return cell;
    }return nil;
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
