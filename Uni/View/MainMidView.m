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
        self.backgroundColor = [UIColor clearColor];
        UITableView* tab = [[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        tab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tab.backgroundColor= [UIColor clearColor];
        tab.scrollEnabled = NO;
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
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _midTableview.frame.size.width, KMainScreenWidth*16/320)];
    view.image =[UIImage imageNamed:@"mian_img_cellH"];
    UILabel* lab = [[UILabel alloc]initWithFrame:
                    CGRectMake(10, 2,  _midTableview.frame.size.width-10, KMainScreenWidth*0.05)];
    lab.text=string;
    lab.textColor = [UIColor colorWithHexString:@"575757"];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.043];
    [view addSubview:lab];
    _midTableview.tableHeaderView = view;
}

-(void)setupTableviewFootView{
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,  _midTableview.frame.size.width,KMainScreenWidth*5/320)];
    view.image =[UIImage imageNamed:@"main_img_cellF"];
    _midTableview.tableFooterView = view;
    
//    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _midTableview.frame.size.width, 5)];
//    view.backgroundColor = [UIColor whiteColor];
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = 5;
//    _midTableview.tableFooterView=view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   // return KMainScreenWidth*55/320;
    return (self.frame.size.height-KMainScreenWidth*0.05-10)/2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int n = _dataArray.count>=1?2:(int)_dataArray.count;
    return n ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellName=@"Cell";
    MainMidCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MainMidCell" owner:self options:nil].lastObject;
        // [cell updateFrame:_midTableview.frame];
    }
    [cell setupCellContent:_dataArray.lastObject andType:type];
    
    if (type==2) {
        cell.handleBtn.tag = indexPath.row+10;
        [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
             [self.delegate mainMidViewDelegataButton:self.dataArray[x.tag-10]];
        }];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate mainMidViewDelegataCell:type];
}


-(void)startReloadData:(NSArray*)data andType:(int)type1{
    type=type1;
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
