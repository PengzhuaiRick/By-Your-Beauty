//
//  UNIPurChaseView.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

@protocol UNIPurChaseViewDelegate <NSObject>

-(void)UNIPurChaseViewDelegateMethod;

@end

#import <UIKit/UIKit.h>
#import "UNIGoodsDetailRequest.h"
@interface UNIPurChaseView : UIView<UITableViewDataSource,UITableViewDelegate>{
    int num; //购买数量
    NSString* orderNO; //订单号
}

@property(nonatomic,strong)UITableView* myTableview;
@property(nonatomic,assign)int payStyle; // 3:微信 2:支付宝
@property(nonatomic,assign) id<UNIPurChaseViewDelegate> delegate;
@property(nonatomic,strong)UNIGoodsModel* model;
-(id)initWithFrame:(CGRect)frame andNum:(int)num andModel:(UNIGoodsModel*)model;
@end
