//
//  MainMidController.h
//  Uni
//  首页中部 我已预约列表
//  Created by apple on 15/11/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMidController : UITableViewController
@property(nonatomic,assign)int pageNum;
@property(nonatomic,strong)NSMutableArray* myData;


//刷新列表
-(void)reflashTabel:(int)Num;

-(void)insertTableViewData;
-(void)deleteTableViewData:(int)Num;
@end
