//
//  UNIOrderDetailController.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderDetailController.h"

#import "UNIOrderDetailCell1.h"
#import "UNIOrderDetailCell3.h"
#import "WTOrderDetailCell1.h"
#import "WTOrderDetailCell2.h"

#import "UNIShopManage.h"
#import "YILocationManager.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UNIOrderListModel.h"
#import "UNITransfromX&Y.h"
@interface UNIOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView* topTableView;
@end

@implementation UNIOrderDetailController

-(void)viewWillAppear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"订单详情"];
    [super viewWillAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"订单详情"];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupTableView];
}
-(void)setupNavigation{
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setupTableView{
    float tabX = 0;
    float tabY = 64;
    float tabH = KMainScreenWidth;
    float tabW = KMainScreenWidth- tabY;
    UITableView* top = [[UITableView alloc]initWithFrame:CGRectMake(tabX, tabY, tabW, tabH) style:UITableViewStylePlain];
    top.delegate = self;
    top.dataSource = self;
    top.separatorStyle = 0;
    [self.view addSubview:top];
    _topTableView = top;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float cellH = 0;
    if (indexPath.section == 0) {
        cellH = KMainScreenWidth* 74/414;
        return cellH;
    }
    if (indexPath.section == 1) {
        cellH = KMainScreenWidth* 110/414;
        return cellH;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {
            
        }
        return cellH;
    }
    
    
    return cellH;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num=1;
    if (section == 2)
        num = 5;
    
    return num;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        switch (indexPath.section) {
            case 0:{
                UNIOrderDetailCell1* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIOrderDetailCell1" owner:self options:nil].lastObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }break;
            case 1:{
                WTOrderDetailCell1* cell = [[NSBundle mainBundle]loadNibNamed:@"WTOrderDetailCell1" owner:self options:nil].lastObject;
                return cell;
            }break;
            case 2:{
                UNIOrderDetailCell3* cell=[[NSBundle mainBundle]loadNibNamed:@"UNIOrderDetailCell3" owner:self options:nil].lastObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }break;
        }
    
        UITableViewCell* cell= [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell4"];
        }
        UNIShopManage* manager = [UNIShopManage getShopData];
        switch (indexPath.row) {
            case 0:{
                cell.imageView.image = nil;

                NSString* name = manager.shortName;
                cell.textLabel.text =[NSString stringWithFormat:@"请您尽快到%@美容院领取您的宝贝!",name];
                cell.textLabel.textColor = [UIColor colorWithHexString:kMainThemeColor];
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.lineBreakMode = 0;
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.selectionStyle = 0;
                [cell.textLabel sizeToFit];
                CALayer* LAY = [CALayer layer];
                LAY.frame = CGRectMake(16, (KMainScreenWidth*44/320)-1, tableView.frame.size.width-32, 1);
                LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
                [cell.layer addSublayer:LAY];
                return cell;
            }break;
            case 1:{
                cell.imageView.image = [UIImage imageNamed:@"appoint_img_pin"];
                cell.textLabel.text =manager.address;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                CALayer* LAY = [CALayer layer];
                LAY.frame = CGRectMake(16, (KMainScreenWidth*44/320)-1, tableView.frame.size.width-32, 1);
                LAY.backgroundColor = [UIColor colorWithHexString:kMainSeparatorColor].CGColor;
                [cell.layer addSublayer:LAY];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }break;

            case 2:{
                cell.imageView.image = [UIImage imageNamed:@"evaluate_img_phone"];
                cell.textLabel.text =manager.telphone;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }break;


        }
    
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark 调用其他地图APP
-(void)callOtherMapApp{
     UNIShopManage* manager = [UNIShopManage getShopData];
    UNITransfromX_Y* xy = [[UNITransfromX_Y alloc]initWithView:self.view withEndCoor:CLLocationCoordinate2DMake(manager.x.doubleValue, manager.y.doubleValue) withAim:manager.shopName];
    [xy setupUI];
    
}


#pragma mark 调用电话功能
-(void)callPhoneToShop{
//    UNIShopManage* manager = [UNIShopManage getShopData];
//    NSString* tel = [NSString stringWithFormat:@"tel://%@",manager.telphone];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
    
    UNIShopManage* manager = [UNIShopManage getShopData];
    NSString* tips=[NSString stringWithFormat:@"是否拨打电话:%@",manager.telphone];;
    NSArray* arr =@[@"拨打"];
    if (manager.telphone.length<11){
        tips=@"暂无店铺电话号码！";
        arr=nil;
    }
    
    [UIAlertView showWithTitle:tips message:nil cancelButtonTitle:@"取消" otherButtonTitles:arr tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if(buttonIndex>0){
            NSString* tel = [NSString stringWithFormat:@"tel://%@",manager.telphone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tel]];
        }
    }];

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
