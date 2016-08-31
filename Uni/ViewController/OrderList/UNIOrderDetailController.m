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
#import "UNIOrderDetailCell5.h"
#import "WTOrderDetailCell1.h"
#import "WTOrderDetailCell2.h"

#import "UNIShopManage.h"
#import "YILocationManager.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"
#import "UNIOrderListModel.h"
#import "UNITransfromX&Y.h"

#import "UNIOrderRequest.h"
#import "UNICouponCellTableViewCell.h"
@interface UNIOrderDetailController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString* couponString;
    CGSize couponSize;
}
@property (weak, nonatomic) IBOutlet UITableView *topTableView;
@property (strong, nonatomic)UNIOrderDetailModel* detailModel;
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
    [self startRequest];
}
-(void)startRequest{
    UNIOrderRequest* request = [[UNIOrderRequest alloc]init];
    [request postWithSerCode:@[API_URL_GetCartOrderDetail]
                      params:@{@"orderNo":_model.orderNo}];
    __weak UNIOrderDetailController* myself = self;
    request.cartOrderDetail=^(UNIOrderDetailModel* model,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (model) {
                myself.detailModel = model;
                [myself setupUI];
                [myself.topTableView reloadData];
                
            }else
                 [YIToast showText:tips];
        });
    };
}
-(void)setupNavigation{
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}
-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setupUI{
    NSMutableString* str =[NSMutableString string];
    for (UNIOrderListGoods* mod in _detailModel.goods) {
        if (mod.couponName.length>1)
            [str appendFormat:@"%@\n",mod.couponName];
    }
    NSString *coupon =nil;
    if (str.length>5)
        coupon = [str substringToIndex:str.length-1];
    else
        coupon = @"没有对应的优惠券!";
    couponString = coupon;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode =0;
    paragraphStyle.alignment =0;
    
    NSDictionary * attributes = @{NSFontAttributeName :kWTFont(14),
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [couponString boundingRectWithSize:CGSizeMake(KMainScreenWidth, MAXFLOAT)
                                                options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes:attributes
                                                context:nil].size;
    couponSize = contentSize;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 15;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
        return  KMainScreenWidth* 74/414;
    
    if (indexPath.section == 1)
        return KMainScreenWidth* 110/414;
    
    if (indexPath.section == 2) {
        int num = (int)_model.goods.count;
        if (indexPath.row == num)
             return couponSize.height+20;
       else if (indexPath.row == num+1)
            return KMainScreenWidth* 115/414;
       else if (indexPath.row == num + 2||indexPath.row == num + 3)
            return 44;
       else if (indexPath.row == num + 4)
            return KMainScreenWidth* 84/414;
        else
            return KMainScreenWidth* 92/414;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num=1;
    if (section == 2)
        num = (int)_model.goods.count+5;
    
    return num;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        switch (indexPath.section) {
            case 0:{
                
                UNIOrderDetailCell1* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIOrderDetailCell1" owner:self options:nil].lastObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UNIShopManage* man =[UNIShopManage getShopData];
                cell.label1.text = man.shopName;
                cell.label2.text = man.address;
                return cell;
                }break;
            case 1:{
                WTOrderDetailCell1* cell = [[NSBundle mainBundle]loadNibNamed:@"WTOrderDetailCell1" owner:self options:nil].lastObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.lable1.text = _detailModel.ordertext;
                cell.lable2.text = _model.orderNo;
                cell.lable3.text = _model.createtime;
                return cell;
            }break;
            case 2:{
                if (indexPath.row == _model.goods.count) {
                    UNICouponCellTableViewCell* cell = [[NSBundle mainBundle]loadNibNamed:@"UNICouponCellTableViewCell" owner:self options:nil].lastObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.label2.text = couponString;
                    return cell;

                }
                else if (indexPath.row == _model.goods.count+1) {
                    WTOrderDetailCell2* cell=[[NSBundle mainBundle]loadNibNamed:@"WTOrderDetailCell2" owner:self options:nil].lastObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.label1.text =[NSString stringWithFormat:@"￥%.2f",_detailModel.totalPrice];
                    cell.label2.text =[NSString stringWithFormat:@"-￥%.2f",_detailModel.totalReturn];
                    cell.label3.text =@"￥0";
                    cell.label4.text =[NSString stringWithFormat:@"￥%.2f",_detailModel.endPrice];
                    return cell;
                }
                else if (indexPath.row == _model.goods.count+2 ||
                         indexPath.row == _model.goods.count+3) {
                   static NSString* name = @"cell";
                    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
                    if (!cell) {
                        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:name];
                        cell.selectionStyle= UITableViewCellSelectionStyleNone;
                        cell.textLabel.textColor = [UIColor colorWithHexString:@"626262"];
                        cell.textLabel.font = kWTFont(14);
                        cell.detailTextLabel.font = kWTFont(14);
                        cell.detailTextLabel.numberOfLines = 0;
                        cell.detailTextLabel.lineBreakMode = 0;
                        
                    }
                    if (indexPath.row == _model.goods.count+2) {
                        cell.textLabel.text = @"支付方式:";
                        cell.detailTextLabel.text = _detailModel.paytext;
                    }else if (indexPath.row == _model.goods.count+3){
                        cell.textLabel.text = @"配送方式:";
                        cell.detailTextLabel.text = _detailModel.deliveryType;
                    }

                    return cell;
                }
               else if (indexPath.row == _model.goods.count+4) {
                    UNIOrderDetailCell5* cell=[[NSBundle mainBundle]loadNibNamed:@"UNIOrderDetailCell5" owner:self options:nil].lastObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                   cell.label3.text = _model.createtime;
                    return cell;
               }else{
                   UNIOrderDetailCell3* cell=[[NSBundle mainBundle]loadNibNamed:@"UNIOrderDetailCell3" owner:self options:nil].lastObject;
                   cell.selectionStyle = UITableViewCellSelectionStyleNone;
                   UNIOrderListGoods* info= _model.goods[indexPath.row];
                   cell.label1.text = info.goodName;
                   cell.label2.text = nil;
                   cell.label3.text = [NSString stringWithFormat:@"￥%.2f",info.price];
                   cell.label4.text = [NSString stringWithFormat:@"x%d",info.num];
                   if (info.specifications)
                       cell.label2.text =[NSString stringWithFormat:@"规格: %@",info.specifications];
                   NSArray* arr = [info.goodLogoUrl componentsSeparatedByString:@","];
                   NSString* imgUrl=nil;
                   imgUrl = arr.count>0?arr[0]:info.goodLogoUrl;
                   [cell.mianimg sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
                   
                   return cell;
               }
                
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
