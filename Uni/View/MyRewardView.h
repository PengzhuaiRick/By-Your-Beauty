//
//  MyRewardView.h
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMidCell.h"
@interface MyRewardView : UIView<UITableViewDataSource,UITableViewDelegate>{
    int type;
    int total;
    UIView* nodataView;
}
@property(nonatomic,strong)UITableView* midTableview;
@property(nonatomic,strong)NSMutableArray* dataArray;

-(id)initWithFrame:(CGRect)frame andNum:(int)num andType:(int)ty;

-(void)startReflashTableView:(NSArray*)arr andNum:(int)num;
@end
