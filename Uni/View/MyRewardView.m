//
//  MyRewardView.m
//  Uni
//
//  Created by apple on 15/12/4.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "MyRewardView.h"
#import "UNIRewardDetailCell.h"
@implementation MyRewardView
-(id)initWithFrame:(CGRect)frame andNum:(int)num andType:(int)ty{
    self = [super initWithFrame:frame];
    if (self) {
        type = ty;
        total = num;
        self.backgroundColor = [UIColor whiteColor];
        self.dataArray = [NSMutableArray array];
        [self setupTableView];
    }
    return self;
}
-(void)setupTableView{
    
    NSString* string = @"约满奖励";
    if (type == 2)
        string = @"准时奖励";
    
    UILabel* lab = [[UILabel alloc]initWithFrame:
                    CGRectMake(10, 0, self.frame.size.width-20 , KMainScreenWidth*20/320)];
    lab.text=string;
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth*15/320];
    [self addSubview:lab];

    
    float tabY =CGRectGetMaxY(lab.frame);
    float tabH = self.frame.size.height -tabY;
    UITableView* tab = [[UITableView alloc]initWithFrame:CGRectMake(0, tabY, self.frame.size.width,tabH)
                                                   style:UITableViewStylePlain];
    tab.backgroundColor= [UIColor whiteColor];
    tab.delegate = self;
    tab.dataSource = self;
    [self addSubview:tab];
    _midTableview = tab;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // return KMainScreenWidth*55/320;
    return KMainScreenWidth*80/320;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count ;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* cellName=@"Cell";
    UNIRewardDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[UNIRewardDetailCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width,KMainScreenWidth*80/320) reuseIdentifier:cellName andTpye:type];;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setupCellContent:self.dataArray[indexPath.row] andType:type andTotal:total];

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
