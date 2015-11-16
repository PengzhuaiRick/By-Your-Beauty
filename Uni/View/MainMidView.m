//
//  MainMidView.m
//  Uni
//
//  Created by apple on 15/11/9.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MainMidView.h"

@implementation MainMidView
-(id)initWithFrame:(CGRect)frame headerTitle:(NSString*)string{
    self = [super initWithFrame:frame];
    if (self) {
        UITableView* tab = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        tab.delegate = self;
        tab.dataSource = self;
        [self addSubview:tab];
        _midTableview = tab;
        [self setupTableviewHeader:string];
        [self setupTableviewFootView];
    }
    return self;
}

-(void)setupTableviewHeader:(NSString*)string{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KMainScreenWidth, 50)];
    UILabel* lab = [[UILabel alloc]initWithFrame:view.frame];
    lab.text=string;
    [view addSubview:lab];
    _midTableview.tableHeaderView = view;
}

-(void)setupTableviewFootView{
    _midTableview.tableFooterView = [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellName=@"Cell";
    MainMidCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MainMidCell" owner:self options:nil].lastObject;
         [cell updateFrame:_midTableview.frame];
    }
   
    return cell;
}

-(void)startReloadData:(NSArray*)data{
    _dataArray = data;
    [_midTableview reloadData];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
