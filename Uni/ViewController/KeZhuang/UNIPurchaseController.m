//
//  UNIPurchaseController.m
//  Uni
//  购买界面
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//
#import "UNIPurchaseController.h"
#import "UNIPayGoodsCell.h"
#import "UNIPayStyleCell.h"
#import "UNIPurChaseView.h"
#import "BTKeyboardTool.h"
@interface UNIPurchaseController ()<UITableViewDataSource,UITableViewDelegate,KeyboardToolDelegate>{
    NSString* orderNo;
    NSString* style;
    int sellNum;
    UNIPayGoodsCell* cell1;
    UITableViewCell* cell2;
    UNIPayStyleCell* cell3;
    UNIPayStyleCell* cell4;
}
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UILabel *bottomPrice;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@end

@implementation UNIPurchaseController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"填写订单"];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dealWithResultOfTheWCpay:) name:@"dealWithResultOfTheWCpay" object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"填写订单"];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:@"dealWithResultOfTheWCpay" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigation];
    [self setupUI];
    [self changeUIValue];
}
-(void)setupNavigation{
    self.title = @"填写订单";
    self.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"main_btn_back"] style:0 target:self action:@selector(leftBarButtonEvent:)];
}

-(void)leftBarButtonEvent:(UIBarButtonItem*)item{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI{
    sellNum = 1;
    style = @"WXPAY_APP2";
    _bottomPrice.font = kWTFont(18);
    _payBtn.titleLabel.font = kWTFont(18);
    
    __weak UNIPurchaseController* myself = self;
    [RACObserve(self.model, sellNum)subscribeNext:^(id x) {
        [myself changeUIValue];
    }];
}
-(void)changeUIValue{
    cell1.numField.text = [NSString stringWithFormat:@"%d",self.model.sellNum];
    self.bottomPrice.text = [NSString stringWithFormat:@"总价:￥%.2f",self.model.shopPrice*self.model.sellNum];
    
    cell2.detailTextLabel.text =self.bottomPrice.text;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 15)];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.row == 0)
        return KMainScreenWidth* 111/414;
    
     return KMainScreenWidth* 61/414;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        cell1 = [[NSBundle mainBundle]loadNibNamed:@"UNIPayGoodsCell" owner:self options:nil].lastObject;
        cell1.selectionStyle = 0;
        cell1.label1.text = _model.projectName;
        cell1.label2.text = [NSString stringWithFormat:@"￥%.2f",_model.shopPrice];
        cell1.numField.text = [NSString stringWithFormat:@"%d",_model.sellNum];
        
        NSArray* imgs = [_model.imgUrl componentsSeparatedByString:@","];
        [cell1.mainIma sd_setImageWithURL:[NSURL URLWithString:imgs[0]] placeholderImage:[UIImage imageNamed:@"main_img_cellbg"]];
        BTKeyboardTool* tool = [BTKeyboardTool keyboardTool];
        tool.toolDelegate = self;
        [tool dismissTwoBtn];
        cell1.numField.inputAccessoryView = tool;
        
        __weak UNIPurchaseController* myself = self;
        [[cell1.addBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(id x) {
            myself.model.sellNum++;
        }];
        [[cell1.cutBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(id x) {
             if (myself.model.sellNum>1)
                 myself.model.sellNum--;
         }];
        
        [[cell1.numField rac_textSignal]subscribeNext:^(NSString* x) {
            int num = x.intValue;
            if (num<1) num = 1;
            myself.model.sellNum = num;
            
        }];
        
        return cell1;
    }
    else if (indexPath.row == 1) {
        cell2= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
        cell2.selectionStyle = 0;
        cell2.textLabel.text = @"  合计:";
        cell2.textLabel.font = kWTFont(14);
        cell2.detailTextLabel.text = _bottomPrice.text;
        cell2.detailTextLabel.font = kWTFont(14);
        cell2.detailTextLabel.textColor = [UIColor colorWithHexString:kMainPinkColor];
        return cell2;
    }else{
        UNIPayStyleCell* cell = [[NSBundle mainBundle]loadNibNamed:@"UNIPayStyleCell" owner:self options:nil].lastObject;
        cell.selectionStyle = 0;
        cell.handleBtn.tag = indexPath.row;
        
        __weak UNIPurchaseController* myself= self;
        [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
        subscribeNext:^(UIButton* x) {
            if (x.selected) return;
            
            x.selected = !x.selected;
            int row = x.tag==2?3:2;
            self->style = x.tag==3?@"ALIPAY_APP2":@"WXPAY_APP2";
            NSIndexPath* index = [NSIndexPath indexPathForRow:row inSection:0];
            UNIPayStyleCell* cell = [myself.myTable cellForRowAtIndexPath:index];
            cell.handleBtn.selected = !cell.handleBtn.selected;
            
        }];
        if (indexPath.row == 2) {
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
    
    return nil;
}
- (IBAction)payBtnAction:(id)sender {
    [self requestTheOrderNo];
}
#pragma mark 请求订单号
-(void)requestTheOrderNo{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    NSDictionary* dic=@{@"goodsId":@(_model.projectId),@"goodsType":@(_model.type),@"payType":style,@"shopPrice":[NSString stringWithFormat:@"%.f",_model.shopPrice*_model.sellNum],@"price":@(_model.shopPrice),
                        @"num":@(_model.sellNum)};
    __weak id myself = self;
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_URL_GetOutTradeNo] params:dic];
    requet.kzgoodsGetOrderBlock=^(NSDictionary* dictionary,NSString*tips,NSError* err){
        [LLARingSpinnerView RingSpinnerViewStop1];
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (dictionary) {
            self->orderNo =[dictionary objectForKey:@"out_trade_no"];
            if ([self->style isEqualToString:@"WXPAY_APP2"]){
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
    __weak UNIPurchaseController* myself = self;
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIGoodsDetailRequest* req = [[UNIGoodsDetailRequest alloc]init];
    req.ctorderStatusBlock=^(int code, NSString* tip,NSError* err){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            [UIAlertView showWithTitle:tip message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (code == 0) {
                    [myself.navigationController popViewControllerAnimated:YES];
                    if (myself.handleBlock) myself.handleBlock(nil);
                    
                }
            }];
        });
        
    };
    [req postWithSerCode:@[API_URL_GetOrderStatus] params:@{@"out_trade_no":orderNo}];
}


-(void)keyboardTool:(BTKeyboardTool *)tool buttonClick:(KeyBoardToolButtonType)type{
    if (type == kKeyboardToolButtonTypeDone) {
        [self.view endEditing:YES];
    }
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
