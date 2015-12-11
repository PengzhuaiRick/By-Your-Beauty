//
//  UNIPurChaseView.h
//  Uni
//
//  Created by apple on 15/12/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UNIPurStyleCell;
@interface UNIPurChaseView : UIView<UITableViewDataSource,UITableViewDelegate>{
    float gPrice;
    float cell1;
    float cell2;
    float restH;
    UNIPurStyleCell* wcCell;
    UNIPurStyleCell* zfCell;
}
@property(nonatomic,strong)UITableView* myTableview;
-(id)initWithFrame:(CGRect)frame andPrice:(CGFloat)price;
@end
