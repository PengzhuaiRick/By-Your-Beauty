//
//  UNIPurChaseView.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UNIPurChaseView : UIView<UITableViewDataSource,UITableViewDelegate>{
    float gPrice;

}
@property(nonatomic,strong)UITableView* myTableview;
@property(nonatomic,assign)int payStyle; // 1:微信 2:支付宝
-(id)initWithFrame:(CGRect)frame andPrice:(CGFloat)price;
@end
