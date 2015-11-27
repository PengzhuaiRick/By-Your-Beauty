//
//  UNIAppontMid.h
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UNIMyAppointCell.h"
@interface UNIAppontMid : UIView<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
@property (strong ,nonatomic)NSMutableArray* myData;
@property (strong, nonatomic)  UIButton *addProBtn;//添加项目按钮
@property (strong, nonatomic)  UITableView *myTableView;



//-(void)setupUI:(CGRect)frame;

//添加项目 刷新列表
-(void)addProject:(id)model;
@end
