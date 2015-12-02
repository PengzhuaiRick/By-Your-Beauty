//
//  UNIAppointDetail.m
//  Uni
//  预约详情界面
//  Created by apple on 15/12/2.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIAppointDetail.h"
#import "UNIAppointDetall1Cell.h"
#import "UNIAppointDetailCell.h"
#import "UNIAppointDetail2Cell.h"
@interface UNIAppointDetail ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UNIAppointDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cellH = 0;
    switch (indexPath.row) {
        case 0:
            cellH = KMainScreenWidth * 75 /320;
            break;
        case 1:
            cellH = KMainScreenWidth * 100 /320;
            break;
        case 2:
            cellH = KMainScreenWidth * 250 /320;
            break;
    }
    return cellH;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
           UNIAppointDetall1Cell* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIAppointDetall1Cell" owner:self options:nil].lastObject;
            [cell setupCellContentWith:nil];
            return cell;
        }
            break;
        case 1:{
            UNIAppointDetailCell* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIAppointDetailCell" owner:self options:nil].lastObject;
            [cell setupCellContentWith:nil];
            return cell;
        }
            break;
        case 2:{
            UNIAppointDetail2Cell* cell =[[NSBundle mainBundle]loadNibNamed:@"UNIAppointDetail2Cell" owner:self options:nil].lastObject;
            [cell setupCellContentWith:nil];
            return cell;
        }
            break;
            
    }
    return nil;
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
