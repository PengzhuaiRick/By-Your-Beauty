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
@property (weak, nonatomic) IBOutlet UIButton *addProBtn;//添加项目按钮
@property (weak, nonatomic) IBOutlet UITableView *myTableView;


-(void)setupUI;

//添加项目 刷新列表
-(void)addProject:(id)model;
@end
