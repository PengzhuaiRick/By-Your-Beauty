//
//  UNIPurChaseView.m
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIPurChaseView.h"
#import "UIActionSheet+Blocks.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
@implementation UNIPurChaseView
-(id)initWithFrame:(CGRect)frame andNum:(int)Num andModel:(UNIGoodsModel*)model{
    self = [super initWithFrame:frame];
    if (self) {
        num = Num;
        _model = model;
        self.payStyle = 1;
        [self setupTableView];
    }
    return self;
}

-(void)setupTableView{
    
    float labH = KMainScreenWidth>320?45:40;
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
        [self.delegate UNIPurChaseViewDelegateMethod];
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
            lab.font = [UIFont systemFontOfSize:KMainScreenWidth>320?18:15];
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
                return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            self.payStyle = 3;
            break;
        case 1:

             self.payStyle = 2;
            break;
    }
    [self requestTheOrderNo];
    [self.delegate UNIPurChaseViewDelegateMethod];
}
#pragma mark 请求订单号
-(void)requestTheOrderNo{
    [LLARingSpinnerView RingSpinnerViewStart1];
    NSDictionary* dic=@{@"goodsId":@"1",@"goodsType":@"2",@"payType":@(self.payStyle),@"shopPrice":[NSString stringWithFormat:@"%.f",_model.shopPrice]};
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_PARAM_UNI,API_URL_GetOutTradeNo] params:dic];
    requet.kzgoodsGetOrderBlock=^(NSString* orderNo,NSString*tips,NSError* err){
        [LLARingSpinnerView RingSpinnerViewStop1];
        if (err) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if (orderNo.length>0) {
            self->orderNO = orderNo;
            if ( self.payStyle ==3)
                [self requestWXPayKey];
            if ( self.payStyle ==2)
                [self requestAliPayKey];
        }
    };
}

#pragma mark 获取支付宝 支付KEY
-(void)requestAliPayKey{
    
    [LLARingSpinnerView RingSpinnerViewStart1];
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_PARAM_PAY,API_URL_GetAlipayConfig] params:nil];
    requet.kzalipayBlock =^(NSString* partner ,NSString* key,NSString* seller,NSString* ras_private_key,NSString* tips,NSError* er){
         [LLARingSpinnerView RingSpinnerViewStop1];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
        if(partner.length>0)
            [self payWithZFB:partner and:seller andand:ras_private_key];
    };
}

-(void)payWithZFB:(NSString*)partner1 and:(NSString*)seller1 andand:(NSString*)ras_private_key{

    NSString *partner = partner1;
    NSString *seller = seller1;
    NSString *privateKey =ras_private_key;
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    NSDictionary* dic = @{@"partner":partner,
                          @"seller_id":seller,
                          @"out_trade_no":orderNO,
                          @"subject":_model.projectName,
                          @"total_fee":[NSString stringWithFormat:@"%.2f",num*_model.shopPrice],
                          @"notify_url":@"http://uni.dodwow.com/uni_pay/uni_alipay_wappay/notify_url.php",
                          @"service":@"mobile.securitypay.pay",
                          @"payment_type":@"1",
                          @"_input_charset":@"utf-8",
                          @"it_b_pay":@"30m",
                          @"show_url":@"m.alipay.com",
                          @"private_key":privateKey};
    [order loadData:dic];
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
    [LLARingSpinnerView RingSpinnerViewStart1];
    UNIGoodsDetailRequest* requet = [[UNIGoodsDetailRequest alloc]init];
    [requet postWithSerCode:@[API_PARAM_PAY,API_URL_GetWXConfig] params:nil];
    requet.kzwxpayBlock =^(NSString* appid ,NSString* mchid,NSString* appsecret,NSString* tips,NSError* er){
        [LLARingSpinnerView RingSpinnerViewStop1];
        if (er) {
            [YIToast showText:NETWORKINGPEOBLEM];
            return ;
        }
        if(appid.length>0)
            [self jumpToBizPay:mchid];
    };

}
- (void)jumpToBizPay:(NSString*)mchid{
    
    [LLARingSpinnerView RingSpinnerViewStart1];
    NSString* price = [NSString stringWithFormat:@"%.f",num*_model.shopPrice*100];
    NSString *urlString   = @"http://uni.dodwow.com/uni_pay/uni_wx_pay/api/unifiedorder.php";
    NSDictionary* dic = @{@"out_trade_no":orderNO,@"body":_model.projectName,@"total_fee":price,@"mchid":mchid};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html"]];
    NSDictionary* ddic = [NSDictionary dictionaryWithObject:[self dictionaryToJson:dic] forKey:@"json"];
    NSLog(@"%@",ddic);
    [manager POST:urlString parameters:ddic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        NSDictionary* dict = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
             [LLARingSpinnerView RingSpinnerViewStop1];
            //调起微信支付
            PayReq* req = [[PayReq alloc] init];
            req.openID = 
            req.prepayId= [dict objectForKey:@"prepayid"];;
            req.partnerId= mchid;
            req.nonceStr= [dict objectForKey:@"noncestr"];
            req.timeStamp=[[dict objectForKey:@"timestamp"] intValue];
            req.package = [dict objectForKey:@"package"];
            req.sign = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
         [LLARingSpinnerView RingSpinnerViewStop1];
        [YIToast showText:NETWORKINGPEOBLEM];
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //return jsonData;
}


@end
