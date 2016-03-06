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
#import "UNIHttpUrlManager.h"
@implementation UNIRewardListView

-(id)initWithFrame:(CGRect)frame andState:(int)st{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = st;
        //[self setupTableView];
        self.allArray = [NSMutableArray array];
         [self startRequest];
       
    }
    return self;
}
-(void)startRequest{
    [LLARingSpinnerView RingSpinnerViewStart1andStyle:2];
    UNIMyRewardRequest* request = [[UNIMyRewardRequest alloc]init];
    [request postWithSerCode:@[API_PARAM_UNI,API_URL_MYRewardList]
                      params:@{@"status":@(self.status),@"page":@(self.page),@"size":@(20)}];
    request.rewardListBlock=^(NSArray* array ,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [LLARingSpinnerView RingSpinnerViewStop1];
            [self.myTable.header endRefreshing];
            [self.myTable.footer endRefreshing];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            if (self.page == 0)
                [self.allArray removeAllObjects];
            
            if (array.count>0)
                [self.allArray addObjectsFromArray:array];
            
            if (self.page> 0)
                [self.allArray removeAllObjects];

            
            [self setupTableView:array];
        });
        
    };
}


-(void)setupTableView:(NSArray*)arr{
    noDataView.hidden = self.allArray.count>0;
    if (self.myTable){
        [self.myTable reloadData];
        if (arr.count<20){
            if (self.page > 0)
            [ self.myTable.footer setHidden:YES];
            else
                [ self.myTable.footer setHidden:NO];
        }
        return;
    }
    
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                       style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.showsVerticalScrollIndicator=NO;
    tabview.separatorStyle = 0;
    [self addSubview:tabview];
    tabview.tableFooterView = [UIView new];
    self.myTable =tabview;
    [self setupNodataView];
    
    tabview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 0;
        [self startRequest];
    }];
    
    tabview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.page++;
        [self startRequest];
    }];
   //self.myTable.footer.automaticallyHidden = YES;
   
}
-(void)setupNodataView{
    
    UIView* nodata = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myTable.frame.size.width, _myTable.frame.size.height)];
    nodata.hidden=YES;
    [_myTable addSubview:nodata];
    noDataView = nodata;
    
    UIImageView* img = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"main_img_nodata1"]];
    float imgWH = KMainScreenWidth>400?60:50,
    imgX = (nodata.frame.size.width - imgWH)/2;
    img.frame = CGRectMake(imgX, 30, imgWH, imgWH);
    [nodata addSubview:img];
    
    UNIHttpUrlManager* manager = [UNIHttpUrlManager sharedInstance];
    UILabel* lab = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(img.frame)+20, nodata.frame.size.width, 30)];
    lab.text=manager.NO_ORDER_TIPS;
    lab.font = [UIFont systemFontOfSize:KMainScreenWidth>400?16:14];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.textColor = [UIColor colorWithHexString:kMainTitleColor];
    [nodata addSubview:lab];
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
