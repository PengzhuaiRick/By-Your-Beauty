//
//  MainMidView.h
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

@protocol MainMidViewDelegate <NSObject>
-(void)mainMidViewDelegataCell:(int)type;
-(void)mainMidViewDelegataButton:(id)model;

@end

#import <UIKit/UIKit.h>
#import "MainMidCell.h"

@interface MainMidView : UIView<UITableViewDataSource,UITableViewDelegate>{
    int type;
    float tabH;
}
@property(nonatomic,strong)UILabel* titleLab;
@property(nonatomic,strong)UITableView* midTableview;
@property(nonatomic,strong)NSArray* dataArray;
@property(nonatomic,assign) id<MainMidViewDelegate> delegate;

-(void)startReloadData:(NSArray*)data andType:(int)type1;
-(id)initWithFrame:(CGRect)frame headerTitle:(NSString*)string;

@end
