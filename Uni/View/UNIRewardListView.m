//
//  UNIRewardListView.m
//  Uni
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import "UNIRewardListView.h"
#import "UNIRewardListCell.h"
#import "UNIMyRewardRequest.h"
#import <MJRefresh/MJRefresh.h>

@implementation UNIRewardListView

-(id)initWithFrame:(CGRect)frame andState:(int)st{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = st;
         //[self setupTableView];
         [self startRequest];
       
    }
    return self;
}
-(void)startRequest{
    [LLARingSpinnerView RingSpinnerViewStart];
    self.allArray = [NSMutableArray array];
    UNIMyRewardRequest* request = [[UNIMyRewardRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_MYRewardList]
                      params:@{@"status":@(self.status),@"page":@(self.page),@"size":@(20)}];
    request.rewardListBlock=^(NSArray* array ,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop];
            [self.myTable.header endRefreshing];
            [self.myTable.footer endRefreshing];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
//            if (array.count<20)
//                [self.myTable.footer endRefreshingWithNoMoreData] ;
            if (array && array.count>0)
                [self.allArray addObjectsFromArray:array];
            
            [self setupTableView:array];
        });
        
    };
}


-(void)setupTableView:(NSArray*)ARR{
    if (self.myTable){
        [self.myTable reloadData];
        if (ARR.count<20) {
            [self.myTable.footer endRefreshingWithNoMoreData];
        }
        return;}
    
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                       style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.showsVerticalScrollIndicator=NO;
    [self addSubview:tabview];
    tabview.tableFooterView = [UIView new];
    self.myTable =tabview;
    
    tabview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self.allArray removeAllObjects];
        [self startRequest];
    }];
    
    tabview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self startRequest];
    }];
    
    if (ARR.count<20) {
        [tabview.footer endRefreshingWithNoMoreData];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
    //return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return KMainScreenWidth*90/320;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* name = @"cell";
    UNIRewardListCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell){
        cell = [[UNIRewardListCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth*90/320) reuseIdentifier:name];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setupCellContentWith:self.allArray[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //[self.delegate UNIRewardListViewDelegate:self.allArray[indexPath.row]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
