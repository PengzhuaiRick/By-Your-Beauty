//
//  UNIOrderListView.m
//  Uni
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UNIOrderListView.h"
#import "UNIOrderListCell.h"
#import <MJRefresh/MJRefresh.h>
#import "UNIHttpUrlManager.h"
@implementation UNIOrderListView

-(id)initWithFrame:(CGRect)frame andState:(int)st{
    self = [super initWithFrame:frame];
    if (self) {
        self.status = st;
        self.allArray = [NSMutableArray array];
         [self startRequest];
        //[self setupTableView];
    }
    return self;
}
-(void)startRequest{
    
    UNIOrderRequest* request = [[UNIOrderRequest alloc]init];
    [request postWithSerCode:@[API_URL_MyOrderList]
                      params:@{@"status":@(self.status),@"page":@(self.page),@"size":@(20)}];
    request.myOrderListBlock=^(NSArray* array ,NSString* tips,NSError* er){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myTable.header endRefreshing];
            [self.myTable.footer endRefreshing];
            if (er) {
                [YIToast showText:NETWORKINGPEOBLEM];
                return ;
            }
            
            if (self.page == 0)
                [self.allArray removeAllObjects];
            
            
            if (array.count<20)
                [self.myTable.footer endRefreshingWithNoMoreData] ;
            
                [self.allArray addObjectsFromArray:array];
                [self setupTableView];
        });
    };
}
-(void)setupNodataView{
    
    UIView* nodata = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _myTable.frame.size.width, _myTable.frame.size.height)];
    nodata.hidden=self.allArray.count>0;
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
    
    nodata=nil; img=nil; lab=nil;
}


-(void)setupTableView{

   self->noDataView.hidden=self.allArray.count>0;
    
    if (self.myTable){
        [self.myTable reloadData];
        return;}
    
    UITableView* tabview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)
                                                       style:UITableViewStylePlain];
    tabview.delegate = self;
    tabview.dataSource = self;
    tabview.showsVerticalScrollIndicator=NO;
    tabview.separatorStyle = 0;
    [self addSubview:tabview];
    self.myTable =tabview;
    tabview.tableFooterView = [UIView new];
    [self setupNodataView];
        tabview.header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            self.page = 0;
            [self startRequest];
        }];
    
        tabview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            self.page++;
            [self startRequest];
        }];
  
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
    UNIOrderListCell* cell = [tableView dequeueReusableCellWithIdentifier:name];
    if (!cell){
        cell = [[UNIOrderListCell alloc]initWithCellSize:CGSizeMake(tableView.frame.size.width, KMainScreenWidth*90/320) reuseIdentifier:name];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setupCellContentWith:self.allArray[indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate UNIOrderListViewDelegate:self.allArray[indexPath.row]];
}


@end
