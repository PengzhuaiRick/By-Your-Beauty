//
//  Order.m
//  AlixPayDemo
//
//  Created by 方彬 on 11/2/13.
//
//

#import "Order.h"
#import "DataSigner.h"

@implementation Order
@synthesize partner = _partner;
@synthesize seller = _seller;
@synthesize tradeNO = _tradeNO;
@synthesize productName = _productName;
@synthesize productDescription = _productDescription;
@synthesize amount = _amount;
@synthesize notifyURL = _notifyURL;
@synthesize service = _service;
@synthesize paymentType = _paymentType;
@synthesize inputCharset = _inputCharset;
@synthesize itBPay = _itBPay;
@synthesize showUrl = _showUrl;
@synthesize rsaDate = _rsaDate;
@synthesize appID = _appID;
@synthesize orderString = _orderString;
@synthesize appScheme = _appScheme;

- (id) init
{
    self = [super init];
    if (self)
    {
        _appScheme = @"coinconsumeralipay";
    }
    return self;
}


- (NSString *)description {
	NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
	
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
	if (self.tradeNO) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.tradeNO];
    }
	if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
	
	if (self.productDescription) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
	if (self.amount) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.amount];
    }
    if (self.notifyURL) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyURL];
    }
	
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    if (self.rsaDate) {
        [discription appendFormat:@"&sign_date=\"%@\"",self.rsaDate];
    }
    if (self.appID) {
        [discription appendFormat:@"&app_id=\"%@\"",self.appID];
    }
	for (NSString * key in [self.extraParams allKeys]) {
		[discription appendFormat:@"&%@=\"%@\"", key, [self.extraParams objectForKey:key]];
	}
	return discription;
}

- (void) loadData:(NSDictionary *)dic
{
    _partner =[self safeObject:dic ForKey:@"partner"];
    _seller =[self safeObject:dic ForKey:@"seller_id"];
    _tradeNO = [self safeObject:dic ForKey:@"out_trade_no"];
    _productName =[self safeObject:dic ForKey:@"subject"];
    _productDescription = @"购买";
    _amount =[self safeObject:dic ForKey:@"total_fee"];
    _notifyURL =[self safeObject:dic ForKey:@"notify_url"] ;
    
    _service = [self safeObject:dic ForKey:@"service"];
    _paymentType =[self safeObject:dic ForKey:@"payment_type"];
    _inputCharset = [self safeObject:dic ForKey:@"_input_charset"];
    _itBPay =[self safeObject:dic ForKey:@"it_b_pay"] ;
    _showUrl =[self safeObject:dic ForKey:@"show_url"];
    
    NSString *key =[self safeObject:dic ForKey:@"private_key"];
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [self description];
    
    id<DataSigner> signer = CreateRSADataSigner(key);
    NSString *signedString = [signer signString:orderSpec];
    
    if (signedString)
    {
        _orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                        orderSpec, signedString, @"RSA"];
    }
}
-(void) loadOrderString:(NSString*)orderString{
    _orderString =orderString;
}

- (id)safeObject:(NSDictionary*)dic ForKey:(id)aKey{
    id obj = [dic objectForKey:aKey];
    if ([obj isEqual:[NSNull null]]) {
        obj = nil;
    }
    return obj;
}
@end
