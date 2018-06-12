//
//  UNIRewardListView.h
//  Uni
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

@protocol UNIRewardListViewDelegate <NSObject>

-(void)UNIRewardListViewDelegate:(id)model;

@end
#import <UIKit/UIKit.h>
@interface UNIRewardListView : UIView<UITableViewDataSource,UITableViewDelegate>{
    UIView* noDataView;
}
@property(nonatomic, assign)int status;  //状态；-1—全部；0—未领；1—已领
@property(nonatomic, assign)int page;  ////当前
@property(nonatomic,strong)UITableView* myTable;
@property(nonatomic,strong)NSMutableArray* allArray;
@property(nonatomic,assign) id<UNIRewardListViewDelegate> delegate;

-(id)initWithFrame:(CGRect)frame andState:(int)st;
@end
