//
//  UNIVerifyController.m
//  Uni
//  确认订单
//  Created by apple on 16/8/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIVerifyController.h"
#import "UNIOrderDetailCell1.h"
#import "UNIOrderDetailCell3.h"
#import "WTOrderDetailCell2.h"
#import "UNIPayStyleCell.h"
#import "UNIShopManage.h"
#import "UNIShopCarRequest.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Order.h"
#import "DataSigner.h"
#import "UNIGoodsDetailRequest.h"
@interface UNIVerifyController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString* style;
    NSString* orderNo;//生成订单号
    float allPrice;
    UNIPayStyleCell* cell3;
    UNIPayStyleCell* cell4;
}
@property(strong,nonatomic)NSArray* myData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

@end

@implementation UNIVerifyController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealWithResultOfTheWCpay:) name:@"dealWithResultOfTheWCpay" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dealWithResultOfTheWCpay" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
    [self setupUI];
    [self setupNavigation];
    [self startRequest];
}
-(void)setupData{
    style = @"WXPAY_APP2";

}
-(void)setupUI{
    _priceLab.font = kWTFont(18);
    _verifyBtn.titleLabel.font= kWTFont(18);
}
-(void)setupNavigation{
    self.title = @"订单详情";
    self.view.backgroundColor = [UIColor colorWithHexString:kMainBackGroundColor];
    
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}
-(void)startRequest{
    __weak UNIVerifyController* myself = self;
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_GetCartComfirm] params:nil];
    rq.getCartComfirm=^(float sumPrice,NSArray* arr,NSString* tips,NSError* err){
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (arr) {
            self->allPrice = sumPrice;
            myself.priceLab.text = [NSString stringWithFormat:@"合计: ￥%.2f",sumPrice];
            myself.myData = arr;
            [myself.tableView reloadData];
        }else
            [YIToast showText:tips];
    };
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if (indexPath.section == 1){
        if (indexPath.row <_myData.count)
            return KMainScreenWidth* 92/414;
        return KMainScreenWidth* 100/414;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0)
            return KMainScreenWidth* 44/414;
        return KMainScreenWidth* 61/414;
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num=1;
    if (section == 1)
        num =(int)_myData.count+1;
    if (section == 2)
        num =3;
    
    return num;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            UNIOrderDetailCell1* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIOrderDetailCell1" owner:self options:nil].lastObject;
            UNIShopManage* manager = [UNIShopManage getShopData];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.label1.text = manager.shopName;
            cell.label2.text = manager.address;
            return cell;
        }break;
        case 1:{
            if (indexPath.row <_myData.count) {
                UNIOrderDetailCell3* cell=[[NSBundle mainBundle]loadNibNamed:@"UNIOrderDetailCell3" owner:self options:nil].lastObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UNIShopCarModel* model = _myData[indexPath.row];
                cell.label1.text = model.goodName;
                if (model.specifications)
                    cell.label2.text = [NSString stringWithFormat:@"规格: %@",model.specifications];
                cell.label3.text =[NSString stringWithFormat:@"￥%.2f",model.price];
                cell.label4.text =[NSString stringWithFormat:@"x%d",model.num];
                NSArray* imgs = [model.goodLogoUrl componentsSeparatedByString:@","];
                [cell.mianimg sd_setImageWithURL:[NSURL URLWithString:imgs[0]] placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
                return cell;
            }else{
                WTOrderDetailCell2* cell=[[NSBundle mainBundle]loadNibNamed:@"WTOrderDetailCell2" owner:self options:nil].lastObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.title4.hidden = YES;
                cell.label1.text =[NSString stringWithFormat:@"￥%.2f",allPrice];
                cell.label2.text =@"-￥0";
                cell.label3.text =@"￥0";
                return cell;

            }
        }break;
        case 2:{
            if (indexPath.row == 0) {
                UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell3"];
                cell.selectionStyle= UITableViewCellSelectionStyleNone;
                cell.textLabel.textColor = [UIColor colorWithHexString:@"626262"];
                cell.textLabel.font = kWTFont(14);
                cell.textLabel.text = @"请选择支付方式";
                return cell;
            }else{
                UNIPayStyleCell* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIPayStyleCell" owner:self options:nil].lastObject;
                cell.selectionStyle = 0;
                cell.handleBtn.tag = indexPath.row;
                __weak UNIVerifyController* myself= self;
                [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
                 subscribeNext:^(UIButton* x) {
                     if (x.selected) return;
                     
                     x.selected = !x.selected;
                     int row = x.tag==1?2:1;
                     self->style = x.tag==2?@"ALIPAY_APP2":@"WXPAY_APP2";
                     NSIndexPath* index = [NSIndexPath indexPathForRow:row inSection:2];
                     UNIPayStyleCell* cell = [myself.tableView cellForRowAtIndexPath:index];
                     cell.handleBtn.selected = !cell.handleBtn.selected;
                     
                 }];
                if (indexPath.row == 1) {
                    cell.mainImg.image = [UIImage imageNamed:@"KZ_img_weixin"];
                    cell.label1.text = @"微信支付";
                    cell.handleBtn.selected=YES;
                    cell3 = cell;
                }else{
                    cell.mainImg.image = [UIImage imageNamed:@"KZ_img_zhifubao"];
                    cell.label1.text = @"支付宝";
                    cell.handleBtn.selected=NO;
                    cell4 = cell;
                }
                return cell;
            }
        }break;
    }
    return nil;
}
- (IBAction)payBtnAction:(id)sender {
    [self requestTheOrderNo];
}
#pragma mark 请求订单号
-(void)requestTheOrderNo{
    __weak UNIVerifyController* myself = self;
     [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIShopCarRequest* rq = [[UNIShopCarRequest alloc]init];
    [rq postWithSerCode:@[API_URL_GetNewPayInfo] params:@{@"payType":style}];
    rq.getNewPayInfo=^(NSDictionary* dictionary,NSString* tips,NSError* err){
        [LLARingSpinnerView RingSpinnerViewStop1];
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (dictionary) {
            self->orderNo =[dictionary objectForKey:@"out_trade_no"];
            if ( [self->style isEqualToString:@"WXPAY_APP2"]){
                [myself jumpToBizPay:dictionary];}
            if ( [self->style isEqualToString:@"ALIPAY_APP2"]){
                [myself payWithZFB:dictionary];}
        }else
            [YIToast showText:tips];
    };
}
-(void)payWithZFB:(NSDictionary*)dic{
    
    Order *order = [[Order alloc] init];
    NSString* str =[dic valueForKey:@"orderstr"];
    if (str) {
        [order loadOrderString:str];
    }
    
    NSString *appScheme = @"UniZFBPay";
    NSString *orderString = order.orderString;
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        //NSLog(@"reslut = %@",resultDic);
        [self dealWithResultOfTheZFB:resultDic];
        // [self resultOfZFBpay:resultDic];
        
    }];
}

- (void)jumpToBizPay:(NSDictionary*)dia{
    if (![WXApi isWXAppInstalled]) {
        [UIAlertView showWithTitle:@"提示" message:@"请检查是否安装微信客户端" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {}];
        return;
    }
    
    PayReq* req = [[PayReq alloc] init];
    req.openID = [dia objectForKey:@"appid"];
    req.prepayId= [dia objectForKey:@"prepayid"];
    req.partnerId= [dia objectForKey:@"partnerid"];
    req.nonceStr= [dia objectForKey:@"noncestr"];
    req.timeStamp=[[dia objectForKey:@"timestamp"] intValue];
    req.package = [dia objectForKey:@"package"];
    req.sign = [dia objectForKey:@"sign"];
    NSString* tip = nil;
    if (!req.openID)  tip = @"参数有误";
    if (!req.prepayId) tip = @"参数有误";
    if (!req.partnerId) tip = @"参数有误";
    if (!req.nonceStr) tip = @"参数有误";
    if (!req.timeStamp) tip = @"参数有误";
    if (!req.package) tip = @"参数有误";
    if (!req.sign) tip = @"参数有误";
    if(tip){
        [UIAlertView showWithTitle:@"提示" message:tip cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
    }else
        [WXApi sendReq:req];
}

-(void)dealWithResultOfTheZFB:(NSDictionary*)noiti{
    int num = [[noiti objectForKey:@"resultStatus"] intValue];
    NSString* string = @"支付失败!";
    NSString* message = [noiti objectForKey:@"memo"];
    if (num == 9000){
        string = @"支付成功!";
        [self checkTradeOrderStatus];
        return;
    }
    switch (num) {
        case 4000: message=@"支付宝系统异常"; break;
        case 4001: message=@"数据格式不正确";  break;
        case 4003: message=@"该用户绑定的支付宝账户被冻结或不允许支付"; break;
        case 4004: message=@"该用户已解除绑定";  break;
        case 4005: message=@"绑定失败或没有绑定"; break;
        case 4006: message=@"订单支付失败"; break;
        case 4010: message=@"重新绑定账户";  break;
        case 6000: message=@"支付服务正在进行升级操作"; break;
        case 6001: message=@"用户中途取消支付操作";  break;
        case 7001: message=@"网页支付失败"; break;
    }
    [UIAlertView showWithTitle:string message:message cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
    }];
}

-(void)dealWithResultOfTheWCpay:(NSNotification*)noiti{
    int num = [[noiti.userInfo objectForKey:@"result"] intValue];
    NSString* errString = nil;
    switch (num) {
        case 0:
            errString = @"交易成功";
            break;
        case -1:
            errString = @"交易失败";
            break;
        case -2:
            errString = @"用户点击取消并返回";
            break;
        case -3:
            errString = @"发送失败";
            break;
        case -4:
            errString = @"授权失败";
            break;
        case -5:
            errString = @"微信不支持";
            break;
            
    }
    NSString* result=nil;
    if (num == 0){
        result = @"支付成功!";
        [self checkTradeOrderStatus];
    }else{
        result = @"支付失败!";
        [UIAlertView showWithTitle:result message:errString cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        }];
    }
    
}
#pragma mark 支付成功后 和后台验证
-(void)checkTradeOrderStatus{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIGoodsDetailRequest* req = [[UNIGoodsDetailRequest alloc]init];
    req.ctorderStatusBlock=^(int code, NSString* tip,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            [UIAlertView showWithTitle:tip message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (code == 0) {
                    [self.navigationController popViewControllerAnimated:YES];
                    //                    UNIOrderListController* view = [[UNIOrderListController alloc]init];
                    //                    view.type = 1;
                    //                    [self.navigationController pushViewController:view animated:YES];
                }
            }];
        });
        
    };
    [req postWithSerCode:@[API_URL_GetOrderStatus] params:@{@"out_trade_no":orderNo}];
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
