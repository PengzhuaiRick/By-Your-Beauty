//
//  UNIOrderListView.h
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//
@protocol UNIOrderListViewDelegate <NSObject>

-(void)UNIOrderListViewDelegate:(id)model;

@end
#import <UIKit/UIKit.h>

@interface UNIOrderListView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UIView* noDataView;
}
@property(nonatomic, assign)int status;  //状态；-1—全部；0—未领；1—已领
@property(nonatomic, assign)int page;  ////当前
@property(nonatomic,strong)UITableView* myTable;
@property(nonatomic,strong)NSMutableArray* allArray;
@property(nonatomic,assign) id<UNIOrderListViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame andState:(int)st;

@end
