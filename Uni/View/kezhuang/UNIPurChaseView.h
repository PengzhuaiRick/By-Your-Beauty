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
    float cell1;
    float cell2;
    float restH;
}
@property(nonatomic,strong)UITableView* myTableview;
-(id)initWithFrame:(CGRect)frame andPrice:(CGFloat)price;
@end
