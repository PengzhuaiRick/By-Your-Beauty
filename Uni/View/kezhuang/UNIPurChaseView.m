//
//  UNIPurChaseView.m
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIPurChaseView.h"
#import "UIActionSheet+Blocks.h"

#import "UNIHttpUrlManager.h"
@implementation UNIPurChaseView
-(id)initWithFrame:(CGRect)frame andNum:(int)Num andModel:(UNIGoodsModel*)model{
    self = [super initWithFrame:frame];
    if (self) {
        num = Num;
        _model = model;
        self.payStyle = nil;
        [self setupTableView];
    }
    return self;
}

-(void)setupTableView{
    
    float labH = KMainScreenWidth>400?45:40;
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, labH)];
    lab.text=@"    选择支付方式";
    lab.backgroundColor = [UIColor colorWithHexString:kMainThemeColor];
    lab.font = [UIFont systemFontOfSize:labH/2];
    lab.textColor = [UIColor whiteColor];
    [self addSubview:lab];
    
    float btnWH =labH - 16;
    float btnX = self.frame.size.width - btnWH - 10;
    float btnY = 8;
    UIButton* btn =[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(btnX, btnY, btnWH, btnWH);
    [btn setBackgroundImage:[UIImage imageNamed:@"KZ_btn_close"] forState:UIControlStateNormal];
    [self addSubview:btn];
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        [self.delegate UNIPurChaseViewDelegateMethod:nil andNum:0];
    }];
    _closeBtn = btn;
    
    float tabY =CGRectGetMaxY(lab.frame);
    float tabH = self.frame.size.height - tabY;
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY, self.frame.size.width, tabH) style:UITableViewStylePlain];
    tab.scrollEnabled = NO;
    tab.delegate = self;
    tab.dataSource = self;
    [self addSubview:tab];
    _myTableview = tab;
    
    lab=nil;btn=nil;tab=nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return tableView.frame.size.height/2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2 ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString* name = @"cell";
    UIImageView* imgView=nil;
    UILabel*lab = nil;
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
            
            float imgWH = 40;
            float ceeH = tableView.frame.size.height/2;
            imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (ceeH - imgWH)/2, imgWH,imgWH)];
            [cell addSubview:imgView];
            
            float labX = CGRectGetMaxX(imgView.frame)+10;
            float labW = tableView.frame.size.width - labX;
            lab = [[UILabel alloc]initWithFrame:CGRectMake(labX, (ceeH - imgWH)/2, labW, imgWH)];
            lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?18:15];
            [cell addSubview:lab];
        }
        switch (indexPath.row ) {
            case 0:
                lab.text = @" 微信支付";
               imgView.image = [UIImage imageNamed:@"KZ_img_weixin"];
                break;
            case 1:
                lab.text = @" 支付宝";
                imgView.image = [UIImage imageNamed:@"KZ_img_zhifubao"];
                
                break;
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            self.payStyle = @"WXPAY_APP";
            break;
        case 1:

             self.payStyle = @"ALIPAY_APP";
            break;
    }
   // [self requestTheOrderNo];
    [self.delegate UNIPurChaseViewDelegateMethod:self.payStyle andNum:num];
}
#pragma mark 请求订单号
-(void)requestTheOrderNo{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    NSDictionary* dic=@{@"goodsId":@(_model.projectId),@"goodsType":@(_model.type),@"payType":self.payStyle,@"shopPrice":[NSString stringWithFormat:@"%.f",_model.shopPrice*num],@"price":@(_model.shopPrice),
                        @"num":@(num)};
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_URL_GetOutTradeNo] params:dic];
    requet.kzgoodsGetOrderBlock=^(NSDictionary* dictionary,NSString*tips,NSError* err){
        [LLARingSpinnerView RingSpinnerViewStop1];
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (dictionary) {
//            self->getNum = _num;
//            self->getPrice = _price;
//            self->tolPrice =_price;
//            self->orderNO = orderNo;
            if ( [self.payStyle isEqualToString:@"WXPAY_APP"])
                [self jumpToBizPay:dictionary];
            if ( [self.payStyle isEqualToString:@"ALIPAY_APP"])
                [self payWithZFB:dictionary];
        }
    };
}

#pragma mark 获取支付宝 支付KEY
-(void)requestAliPayKey{
    
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_URL_GetAlipayConfig] params:nil];
    requet.kzalipayBlock =^(NSString* partner ,NSString* key,NSString* seller,NSString* ras_private_key,NSString* tips,NSError* er){
         [LLARingSpinnerView RingSpinnerViewStop1];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
//        if(partner.length>0)
//            [self payWithZFB:partner and:seller andand:ras_private_key];
    };
}

-(void)payWithZFB:(NSDictionary*)dic{

//    NSString *partner = partner1;
//    NSString *seller = seller1;
//    NSString *privateKey =ras_private_key;
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    NSString* str =[dic valueForKey:@"orderstr"];
    if (str) {
         [order loadOrderString:str];
    }
   
//    NSDictionary* dic = @{@"partner":partner,
//                          @"seller_id":seller,
//                          @"out_trade_no":orderNO,
//                          @"subject":_model.projectName,
//                          //@"total_fee":[NSString stringWithFormat:@"%.2f",num*_model.shopPrice],
//                          @"total_fee":[NSString stringWithFormat:@"%.2f",tolPrice],
//                          //@"total_fee":@"0.01",
//                          @"notify_url":@"http://uni.dodwow.com/uni_pay/uni_alipay_wappay/notify_url.php",
//                          @"service":@"mobile.securitypay.pay",
//                          @"payment_type":@"1",
//                          @"_input_charset":@"utf-8",
//                          @"it_b_pay":@"30m",
//                          @"show_url":@"m.alipay.com",
//                          @"private_key":privateKey};
//    [order loadData:dic];
//    [order loadOrderString:@"_input_charset=utf-8&body=购买游戏币-[美丽由你提供]&it_b_pay=30m&notify_url=http://uni.dodwow.com/v2/alipay_notify.php&openid=&out_trade_no=1460974525&partner=2088121108997680&payment_type=1&product_id=1&seller_id=youunimail@163.com&service=mobile.securitypay.pay&show_url=m.alipay.com&sign=EaMmH6kh5MBb7xeHxd6W9occrcispUFxHsH5nCXv1gvgtTgwY0jCJtxTo5djs5bOznK9MJL9dsIM5E8ULmGEuhIx6jNE4fvVohqwjINtUGmT1FMCI5PKJqHt6xBexmS5M%2B1x46%2BpATlicHg0H4hfDIpvujzlQsiwgRhAyvLXC0Y%3D&sign_type=RSA&subject=购买游戏币-&total_fee=1&tradeType=APP"];

  //  order.partner = partner;
   // order.seller = seller;
   // order.tradeNO = @"4412831990091123"; //订单ID（由商家自行制定）
//    order.tradeNO = orderNO; //订单ID（由商家自行制定）
//    order.productName =_model.projectName; //商品标题
//    order.productDescription =_model.desc; //商品描述
//    order.amount =[NSString stringWithFormat:@"%.2f",num*_model.shopPrice]; //商品价格
//    order.productName =@"ALBION清新莹润滋养护理"; //商品标题
    //order.productDescription =@"采用世界知名化妆品牌ALBION奥碧虹的清新系列,完美护肤四步曲,打造有透明感及有弹性的肌肤."; //商品描述
//    order.amount =@"899"; //商品价格

//    order.notifyURL =  @"http://uni.dodwow.com/uni_pay/uni_alipay_wappay/notify_url.php"; //回调URL
    
//    order.service = @"mobile.securitypay.pay";
//    order.paymentType = @"1";
//    order.inputCharset = @"utf-8";
 //   order.itBPay = @"30m";
 //   order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"UniZFBPay";
    
    //将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = order.orderString;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
            [self resultOfZFBpay:resultDic];
            
        }];
//    }
}
-(void)resultOfZFBpay:(NSDictionary*)dic{
    int resultStatus =[[dic valueForKey:@"resultStatus"] intValue];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dealWithResultOfTheZFB" object:nil userInfo:@{@"result":@(resultStatus)}];
}


#pragma mark 获取微信支付 支付KEY
-(void)requestWXPayKey{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_URL_GetWXConfig] params:nil];
    requet.kzwxpayBlock =^(NSString* appid ,NSString* mchid,NSString* appsecret,NSString* tips,NSError* er){
        [LLARingSpinnerView RingSpinnerViewStop1];
        if (er) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
//        if(appid.length>0)
//            [self jumpToBizPay:mchid];
    };

}
- (void)jumpToBizPay:(NSDictionary*)dia{
    if (![WXApi isWXAppInstalled]) {
        [UIAlertView showWithTitle:@"提示" message:@"请检查是否安装微信客户端" cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
        }];
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







//
//    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
//   // NSString* price = [NSString stringWithFormat:@"%.f",num*_model.shopPrice*100];
////    NSString *urlString   = @"http://uni.dodwow.com/uni_pay/uni_wx_pay/api/unifiedorder.php";
//    NSString *urlString   = [UNIHttpUrlManager sharedInstance].WX_GET_PREAPYID;
//    NSDictionary* dic = @{@"out_trade_no":[dia objectForKey:@"out_trade_no"],
//                          @"body":_model.projectName,
//                          @"price":[dia objectForKey:@"total_price"],
//                          @"num":@(1),
//                          @"mchid":[dia objectForKey:@"partnerid"]};
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html"]];
//    NSDictionary* ddic = [NSDictionary dictionaryWithObject:[self dictionaryToJson:dic] forKey:@"json"];
//    NSLog(@"%@",ddic);
//    [manager POST:urlString parameters:ddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        NSDictionary* dict = responseObject;
//        dispatch_async(dispatch_get_main_queue(), ^{
//             [LLARingSpinnerView RingSpinnerViewStop1];
//            //调起微信支付
//            PayReq* req = [[PayReq alloc] init];
//            req.openID = [dia objectForKey:@"appid"];
//            req.prepayId= [dia objectForKey:@"prepayid"];
//            req.partnerId= [dia objectForKey:@"partnerid"];
//            req.nonceStr= [dia objectForKey:@"noncestr"];
//            req.timeStamp=[[dia objectForKey:@"timestamp"] intValue];
//            req.package = [dia objectForKey:@"package"];
//            req.sign = [dia objectForKey:@"sign"];
//            NSString* tip = nil;
//            if (!req.openID)  tip = @"参数有误";
//            if (!req.prepayId) tip = @"参数有误";
//            if (!req.partnerId) tip = @"参数有误";
//            if (!req.nonceStr) tip = @"参数有误";
//            if (!req.timeStamp) tip = @"参数有误";
//            if (!req.package) tip = @"参数有误";
//            if (!req.sign) tip = @"参数有误";
//            if(tip){
//                [UIAlertView showWithTitle:@"提示" message:tip cancelButtonTitle:@"确定" otherButtonTitles:nil tapBlock:nil];
//            }else
//                [WXApi sendReq:req];
//        });
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//         [LLARingSpinnerView RingSpinnerViewStop1];
//        [YIToast showText:NETWORKINGPEOBLEM];
//    }];
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //return jsonData;
}


@end
