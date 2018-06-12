//
//  Order.h
//  AlixPayDemo
//
//  Created by 方彬 on 11/2/13.
//
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

@property(nonatomic, copy, readonly) NSString * partner;
@property(nonatomic, copy, readonly) NSString * seller;
@property(nonatomic, copy, readonly) NSString * tradeNO;
@property(nonatomic, copy, readonly) NSString * productName;
@property(nonatomic, copy, readonly) NSString * productDescription;
@property(nonatomic, copy, readonly) NSString * amount;
@property(nonatomic, copy, readonly) NSString * notifyURL;

@property(nonatomic, copy, readonly) NSString * service;
@property(nonatomic, copy, readonly) NSString * paymentType;
@property(nonatomic, copy, readonly) NSString * inputCharset;
@property(nonatomic, copy, readonly) NSString * itBPay;
@property(nonatomic, copy, readonly) NSString * showUrl;

@property(nonatomic, copy, readonly) NSString * orderString;
@property(nonatomic, copy, readonly) NSString * appScheme;



@property(nonatomic, copy, readonly) NSString * rsaDate;//可选
@property(nonatomic, copy, readonly) NSString * appID;//可选

@property(nonatomic, readonly) NSMutableDictionary * extraParams;


- (void) loadData:(NSDictionary *)dic;

-(void) loadOrderString:(NSString*)orderString;
@end
