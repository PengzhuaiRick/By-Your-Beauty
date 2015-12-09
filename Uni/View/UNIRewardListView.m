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
         [self startRequest];

    }
    return self;
}
-(void)startRequest{
    self.allArray = [NSMutableArray array];
    UNIMyRewardRequest* request = [[UNIMyRewardRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_MYRewardList]
                      params:@{@"status":@(self.status),@"page":@(self.page),@"size":@(20)}];
    request.rewardListBlock=^(NSArray* array ,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTable.header endRefreshing];
            [self.myTable.footer endRefreshing];
            if (er) {
                [YIToast showText:er.localizedDescription];
                return ;
            }
            if (array && array.count>0) {
                if (array.count<20)
                    self.myTable.footer.hidden = YES ;
                
                [self.allArray addObjectsFromArray:array];
                [self setupTableView];
                
               
            }else
                [YIToast showText:tips];
        });
        
    };
}


-(void)setupTableView{
    if (self.myTable){
        [self.myTable reloadData];
        return;}
    
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                       style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.layer.masksToBounds=YES;
    tabview.layer.cornerRadius = 10;
    tabview.showsVerticalScrollIndicator=NO;
    [self addSubview:tabview];
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
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* name = @"cell";
    UNIRewardListCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell){
        cell = [[NSBundle mainBundle]loadNibNamed:@"UNIRewardListCell" owner:self options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setupCellContentWith:self.allArray[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate UNIRewardListViewDelegate:self.allArray[indexPath.row]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
