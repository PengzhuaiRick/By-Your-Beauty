//
//  UNIAppontMid.h
//  Uni
//
//  Created by apple on 15/11/25.
//  Copyright © 2015年 apple. All rights reserved.
//

@protocol UNIAppontMidDelegate <NSObject>

-(void)UNIAppontMidDelegateMethod;

@end

#import <UIKit/UIKit.h>
//#import "UNIAddMyAppointCell.h"
@interface UNIAppontMid : UIView<UITableViewDataSource,UITableViewDelegate,UNIAppontMidDelegate>{
   
}

@property (strong ,nonatomic)NSMutableArray* myData;
@property (strong ,nonatomic) UILabel* lab1;
@property (strong, nonatomic)  UIButton *addProBtn;//添加项目按钮
@property (strong, nonatomic)  UITableView *myTableView;
@property (assign, nonatomic) float cellH;
@property (assign, nonatomic) id<UNIAppontMidDelegate>delegate;

-(id)initWithFrame:(CGRect)frame andModel:(id)model;
//-(void)setupUI:(CGRect)frame;

//添加项目 刷新列表
-(void)addProject:(NSArray*)modelArr;
@end
