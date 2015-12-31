//
//  MyRewardView.m
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MyRewardView.h"

@implementation MyRewardView
-(id)initWithFrame:(CGRect)frame andNum:(int)num andType:(int)ty{
    self = [super initWithFrame:frame];
    if (self) {
        type = ty;
        total = num;
        self.backgroundColor = [UIColor clearColor];
        self.dataArray = [NSMutableArray array];
        [self setupTableView];
    }
    return self;
}
-(void)setupTableView{
    float tabY =KMainScreenWidth*16/320;
    float tabH = self.frame.size.height -tabY -KMainScreenWidth*10/320;
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY, self.frame.size.width,tabH)
                                                   style:UITableViewStylePlain];
    tab.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tab.backgroundColor= [UIColor whiteColor];
    tab.delegate = self;
    tab.dataSource = self;
    [self addSubview:tab];
    _midTableview = tab;
    
    
    NSString* string = @"约满奖励";
    if (type == 2)
        string = @"准时奖励";
    
    [self setupTableviewHeader:string];
    [self setupTableviewFootView];
    
   
}

-(void)setupTableviewHeader:(NSString*)string{
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _midTableview.frame.size.width, KMainScreenWidth*16/320)];
    view.image =[UIImage imageNamed:@"mian_img_cellH"];
    UILabel* lab = [[UILabel alloc]initWithFrame:
                    CGRectMake(10, 2,  _midTableview.frame.size.width-10, KMainScreenWidth*0.05)];
    lab.text=string;
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab.font = [UIFont boldSystemFontOfSize:KMainScreenWidth*0.043];
    [view addSubview:lab];
    [self addSubview:view];
}

-(void)setupTableviewFootView{
    float viewY = CGRectGetMaxY(_midTableview.frame);
    UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, viewY,  _midTableview.frame.size.width,KMainScreenWidth*10/320)];
    view.image =[UIImage imageNamed:@"main_img_cellF"];
    [self addSubview:view];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // return KMainScreenWidth*55/320;
    return KMainScreenWidth*60/320;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellName=@"Cell";
    MainMidCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MainMidCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setAppointCell:self.dataArray[indexPath.row] and:total and:type];
    
        cell.handleBtn.tag = indexPath.row+10;
        [[cell.handleBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
         subscribeNext:^(UIButton* x) {
            // [self.delegate mainMidViewDelegataButton:self.dataArray[x.tag-10]];
         }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.delegate mainMidViewDelegataCell:type];
}

-(void)startReflashTableView:(NSArray*)arr{
    NSArray* array =[arr sortedArrayUsingComparator:^NSComparisonResult(UNIMyRewardModel* obj1, UNIMyRewardModel* obj2) {
        if (obj1.rewardNum > obj2.rewardNum)
            return NSOrderedDescending;
        else
            return NSOrderedAscending;
    }];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:array];
    [self.midTableview reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
