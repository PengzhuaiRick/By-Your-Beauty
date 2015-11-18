//
//  MainBottomController.h
//  Uni
//  首页底部 我未预约项目
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainBottomController : UITableViewController

@property(nonatomic,assign)int num;
@property(nonatomic,strong)NSMutableArray* myData;

//刷新列表
-(void)reflashTabel:(int)Num;

-(void)insertTableViewData;

-(void)deleteTableViewData:(int)Num;
@end
