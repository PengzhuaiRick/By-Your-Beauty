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
-(id)initWithFrame:(CGRect)frame andPrice:(CGFloat)price{
    self = [super initWithFrame:frame];
    if (self) {
        gPrice = price;
        self.payStyle = 1;
        [self setupTableView];
    }
    return self;
}

-(void)setupTableView{
    
    float labH = KMainScreenWidth*45/320;
    
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, labH)];
    lab.text=@"   马上购买";
    lab.backgroundColor = [UIColor colorWithHexString:kMainThemeColor];
    lab.font = [UIFont systemFontOfSize:labH/2];
    lab.textColor = [UIColor whiteColor];
    [self addSubview:lab];
    
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
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }
        switch (indexPath.row ) {
            case 0:
                cell.textLabel.text = @"微信支付";
                cell.imageView.image = [UIImage imageNamed:@"KZ_img_weixin"];
                break;
            case 1:
                cell.textLabel.text = @"支付宝";
                cell.imageView.image = [UIImage imageNamed:@"KZ_img_zhifubao"];
                
                break;
        
    }
    return cell;
                return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            self.payStyle = 1;
            [self jumpToBizPay];
            break;
        case 1:

             self.payStyle = 2;
            [self payWithZFB];
            break;
    }
}

-(void)payWithZFB{
    /*
     *点击获取prodcut实例并初始化订单信息
     */

    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = ZFBPID;
    NSString *seller = ZFBACCOUNT;
    NSString *privateKey =ZFBRSAPrivateKey;
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
//    if ([partner length] == 0 ||
//        [seller length] == 0 ||
//        [privateKey length] == 0)
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"缺少partner或者seller或者私钥。"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"4412831990091123"; //订单ID（由商家自行制定）
    order.productName = @""; //商品标题
    order.productDescription =@""; //商品描述
    order.amount = [NSString stringWithFormat:@"%d",234]; //商品价格
    order.notifyURL =  @"http://www.baidu.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"UniZFBPay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
    }

}
- (NSString *)jumpToBizPay {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
    //解析服务端返回json数据
    NSError *error;
    //加载一个NSURL对象
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    //将请求的url数据放到NSData对象中
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ( response != nil) {
        NSMutableDictionary *dict = NULL;
        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"url:%@",urlString);
        if(dict != nil){
            NSMutableString *retcode = [dict objectForKey:@"retcode"];
            if (retcode.intValue == 0){
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                [WXApi sendReq:req];
                //日志输出
                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                return @"";
            }else{
                return [dict objectForKey:@"retmsg"];
            }
        }else{
            return @"服务器返回错误，未获取到json对象";
        }
    }else{
        return @"服务器返回错误";
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
