//
//  UNIPurChaseView.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

@protocol UNIPurChaseViewDelegate <NSObject>

-(void)UNIPurChaseViewDelegateMethod:(NSString*)payStyle andNum:(int)num;

@end

#import <UIKit/UIKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "Order.h"
#import "DataSigner.h"
#import "UNIGoodsDetailRequest.h"
@interface UNIPurChaseView : UIView<UITableViewDataSource,UITableViewDelegate>{
    int num; //购买数量
    NSString* orderNO; //订单号
//    int getNum; //获取回来的数量
//    float getPrice; //获取回来的单价
    float tolPrice; //获取回来的总价
}

@property(nonatomic,strong)UITableView* myTableview;
@property(nonatomic,copy)NSString* payStyle; // ALIPAY_APP","WXPAY_APP
@property(nonatomic,assign) id<UNIPurChaseViewDelegate> delegate;
@property(nonatomic,strong)UNIGoodsModel* model;
@property(nonatomic,strong)UIButton* closeBtn;
-(id)initWithFrame:(CGRect)frame andNum:(int)num andModel:(UNIGoodsModel*)model;
@end
